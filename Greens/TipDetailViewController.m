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
    
    NSArray *foods = [Food foods];
    Food *food = nil;
    
    for(Food *f in foods)
        if([f.title isEqualToString:tips.colorText])
            food = f;
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height, self.view.frame.size.width, 40)];
    [lbl setBackgroundColor:food.backgroundColor];
    [lbl setText:[NSString stringWithFormat:@"  %@", food.title]];
    [lbl setTextColor:food.textColor];
    [lbl setFont:[UIFont systemFontOfSize:17.0f]];
    [self.view addSubview:lbl];
    
    UILabel *lblDate = [[UILabel alloc] initWithFrame:CGRectZero];
    [lblDate setFont:kStandardFont];
    [lblDate setTextAlignment:NSTextAlignmentRight];
    [lblDate setBackgroundColor:[UIColor clearColor]];
    [lblDate setText:[tips dateString]];
    [lblDate setText:[lblDate.text stringByReplacingOccurrencesOfString:@">" withString:@""]];
    [lblDate setText:[lblDate.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    
    CGSize szDate = [Utils sizeForLabel:lblDate forMaxSize:CGSizeZero];
    [lblDate setFrame:CGRectMake(10, CGRectGetMaxY(lbl.frame) + 10, szDate.width, szDate.height)];
    
    [self.view addSubview:lblDate];

    UILabel *lblFood = [[UILabel alloc] initWithFrame:CGRectZero];
    [lblFood setFont:kStandardFont];
    [lblFood setBackgroundColor:[UIColor clearColor]];
    [lblFood setNumberOfLines:0];
    [lblFood setLineBreakMode:NSLineBreakByWordWrapping];
    [lblFood setText:tips.food];
    
    CGSize szFood = [Utils sizeForLabel:lblFood forMaxSize:CGSizeMake(300, 0)];
    [lblFood setFrame:CGRectMake(10, CGRectGetMaxY(lblDate.frame) + 10, szFood.width, szFood.height)];
    
    [self.view addSubview:lblFood];
    
    UILabel *lblHeadline = [[UILabel alloc] initWithFrame:CGRectZero];
    [lblHeadline setFont:kStandardFont];
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
