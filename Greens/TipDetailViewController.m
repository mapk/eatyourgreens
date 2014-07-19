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
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    NSArray *foods = [Food foods];
    Food *food = nil;
    
    for(Food *f in foods)
        if([f.title isEqualToString:tips.color])
            food = f;
    
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, self.view.frame.size.width, 30)];
    [lbl setBackgroundColor:[UIColor clearColor]];
    [lbl setText:food.title];
    [lbl setTextColor:food.textColor];
    [self.view addSubview:lbl];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
