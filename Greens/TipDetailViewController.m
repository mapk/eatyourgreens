//
//  TipDetailViewController.m
//  Greens
//
//  Created by Todd Mathison on 7/19/14.
//  Copyright (c) 2014 Todd Mathison. All rights reserved.
//

#import "TipDetailViewController.h"
#import "Tips.h"
#import "Food.h"
#import "Utils.h"

@interface TipDetailViewController ()

@end

@implementation TipDetailViewController

@synthesize tips;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:kColor_Background];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    
    
    NSArray *foods = [Food foods];
    Food *food = nil;
    
    for(Food *f in foods)
        if([f.title isEqualToString:tips.colorText])
            food = f;
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    [lbl setBackgroundColor:food.backgroundColor];
    [lbl setText:[NSString stringWithFormat:@"  %@", food.title]];
    [lbl setTextColor:food.textColor];
    [lbl setFont:[UIFont systemFontOfSize:17.0f]];
    [self.view addSubview:lbl];
    

    UILabel *lblFood = [[UILabel alloc] initWithFrame:CGRectZero];
    [lblFood setFont:kStandardFont];
    [lblFood setBackgroundColor:[UIColor clearColor]];
    [lblFood setNumberOfLines:0];
    [lblFood setLineBreakMode:NSLineBreakByWordWrapping];
    [lblFood setText:tips.food];
    
    CGSize szFood = [Utils sizeForLabel:lblFood forMaxSize:CGSizeMake(300, 0)];
    [lblFood setFrame:CGRectMake(10, CGRectGetMaxY(lbl.frame) + 10, szFood.width, szFood.height)];
    
    [self.view addSubview:lblFood];
    
    
    UILabel *lblDate = [[UILabel alloc] initWithFrame:CGRectZero];
    [lblDate setFont:kStandardFont];
    [lblDate setTextAlignment:NSTextAlignmentRight];
    [lblDate setBackgroundColor:[UIColor clearColor]];
    [lblDate setTextColor:[UIColor colorWithRed:203.0f/255.0f green:203.0f/255.0f blue:203.0f/255.0f alpha:1.0f]];
    [lblDate setText:[tips dateString]];
    [lblDate setText:[lblDate.text stringByReplacingOccurrencesOfString:@">" withString:@""]];
    [lblDate setText:[lblDate.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    
    CGSize szDate = [Utils sizeForLabel:lblDate forMaxSize:CGSizeZero];
    [lblDate setFrame:CGRectMake(self.view.frame.size.width - szDate.width - 10, lblFood.frame.origin.y, szDate.width, szDate.height)];
    
    [self.view addSubview:lblDate];
    
    
    
    UILabel *lblHeadline = [[UILabel alloc] initWithFrame:CGRectZero];
    [lblHeadline setFont:[UIFont boldSystemFontOfSize:15.0f]];
    [lblHeadline setBackgroundColor:[UIColor clearColor]];
    [lblHeadline setNumberOfLines:0];
    [lblHeadline setLineBreakMode:NSLineBreakByWordWrapping];
    [lblHeadline setText:tips.headline];

    CGSize szHeadline = [Utils sizeForLabel:lblHeadline forMaxSize:CGSizeMake(300, 0)];
    [lblHeadline setFrame:CGRectMake(10, CGRectGetMaxY(lblFood.frame) + 10, szHeadline.width, szHeadline.height)];
    
    [self.view addSubview:lblHeadline];
    
    UILabel *detailTextLabel = [[UILabel alloc] initWithFrame:CGRectZero];

    [detailTextLabel setFont:kStandardFont];
    [detailTextLabel setText:tips.message];
    [detailTextLabel setNumberOfLines:0];
    [detailTextLabel setLineBreakMode:NSLineBreakByWordWrapping];
    
    [self.view addSubview:detailTextLabel];
    
    CGSize szDetail = [Utils sizeForLabel:detailTextLabel forMaxSize:CGSizeMake(300, 0)];
    
    [detailTextLabel setFrame:CGRectMake(10, CGRectGetMaxY(lblHeadline.frame) + 10, szDetail.width, szDetail.height)];
    
    
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"Screen"
                                                                                        action:@"View"
                                                                                         label:[NSString stringWithFormat:@"Tip detail: %@", tips.headline]
                                                                                         value:nil] build]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
