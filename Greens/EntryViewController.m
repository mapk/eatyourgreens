//
//  EntryViewController.m
//  Greens
//
//  Created by Todd Mathison on 6/21/14.
//  Copyright (c) 2014 Todd Mathison. All rights reserved.
//

#import "EntryViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Entry.h"

@interface EntryViewController ()

@end

@implementation EntryViewController

@synthesize entry;

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
    
    [self.view setBackgroundColor:[UIColor colorWithRed:242.0f/255.0f green:242.0f/255.0f blue:242.0f/255.0f alpha:1.0f]];
    
    pie = [[XYPieChart alloc] initWithFrame:CGRectZero Center:CGPointMake(self.view.center.x, 200) Radius:130];
    [pie setDataSource:self];
    [pie setDelegate:self];
    [pie setLabelColor:[UIColor clearColor]];

    [self.view addSubview:pie];
    [pie reloadData];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 120)];
    [lbl setText:@" "];
    [lbl.layer setCornerRadius:60];
    [lbl.layer setMasksToBounds:YES];
    [lbl setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:lbl];
    [self.view bringSubviewToFront:lbl];
    [lbl setCenter:CGPointMake(self.view.center.x, 200)];
    [self.view bringSubviewToFront:lbl];
    
    UIImage *imgShare = [UIImage imageNamed:@"btn-share"];
    UIButton *btnShare = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnShare setImage:imgShare forState:UIControlStateNormal];
    [btnShare addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    [btnShare setFrame:CGRectMake(0, 350, imgShare.size.width, imgShare.size.height)];
    [self.view addSubview:btnShare];
    
    UIImage *imgPhoto = [UIImage imageNamed:@"btn-photo"];
    UIButton *btnPhoto = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnPhoto setImage:imgPhoto forState:UIControlStateNormal];
    [btnPhoto addTarget:self action:@selector(photo) forControlEvents:UIControlEventTouchUpInside];
    [btnPhoto setFrame:CGRectMake(CGRectGetMaxX(btnShare.frame) + 5, 350, imgPhoto.size.width, imgPhoto.size.height)];
    [self.view addSubview:btnPhoto];
    
    UIImage *imgEdit = [UIImage imageNamed:@"btn-edit"];
    UIButton *btnEdit = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnEdit setImage:imgEdit forState:UIControlStateNormal];
    [btnEdit addTarget:self action:@selector(edit) forControlEvents:UIControlEventTouchUpInside];
    [btnEdit setFrame:CGRectMake(CGRectGetMaxX(btnPhoto.frame) + 5, 350, imgEdit.size.width, imgEdit.size.height)];
    [self.view addSubview:btnEdit];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateStyle:NSDateFormatterFullStyle];
    [df setTimeStyle:NSDateFormatterNoStyle];

    NSDateFormatter *tf = [[NSDateFormatter alloc] init];
    [tf setDateStyle:NSDateFormatterNoStyle];
    [tf setTimeStyle:NSDateFormatterShortStyle];

    UILabel *lblDate = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(btnShare.frame) + 10, self.view.frame.size.width, 18)];
    [lblDate setTextAlignment:NSTextAlignmentCenter];
    [lblDate setText:[df stringFromDate:entry.date]];
    [self.view addSubview:lblDate];

    UILabel *lblTime = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lblDate.frame) + 10, self.view.frame.size.width, 18)];
    [lblTime setTextAlignment:NSTextAlignmentCenter];
    [lblTime setText:[tf stringFromDate:entry.date]];
    [self.view addSubview:lblTime];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)edit
{
}

-(void)photo
{
    imageViewController = [[ImageViewController alloc] init];
    [imageViewController setEntry:entry];
    [imageViewController setDelegate:self];
    [self.tabBarController presentViewController:imageViewController animated:YES completion:nil];
}

-(void)share
{
}

#pragma mark XYPieChartDataSource methods
- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
    return entry.entryPoints.count;
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
    return (CGFloat)1/entry.entryPoints.count;
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
    EntryPoint *entryPoint = (EntryPoint *)[entry.entryPoints objectAtIndex:index];
    
    return entryPoint.color;
}



#pragma mark XYPieChatDelegate methods
-(void)pieChart:(XYPieChart *)pieChart didDeselectSliceAtIndex:(NSUInteger)index
{}

-(void)pieChart:(XYPieChart *)pieChart didSelectSliceAtIndex:(NSUInteger)index
{}

-(void)pieChart:(XYPieChart *)pieChart willDeselectSliceAtIndex:(NSUInteger)index
{}

-(void)pieChart:(XYPieChart *)pieChart willSelectSliceAtIndex:(NSUInteger)index
{}


#pragma mark ImageViewControllerDelegate methods
-(void)imageViewController:(ImageViewController *)imageViewController savedForEntry:(Entry *)entry
{
    [self.tabBarController dismissViewControllerAnimated:YES completion:nil];
    [pie reloadData];
}


@end
