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
#import "DescriptionViewController.h"

@interface EntryViewController ()

@end

@implementation EntryViewController

@synthesize entry, entries, index;

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
    pies = [[NSMutableArray alloc] init];
    
    if(entries.count < 2)
        [self.view addSubview:[self viewForEntry:entry forFrame:self.view.frame forTag:0]];
    else
    {
        
        scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-85)];
        [scroller setDelegate:self];

        for(int i = 0;i<entries.count;i++)
        {
            Entry *e = (Entry *)[entries objectAtIndex:i];
            [scroller addSubview:[self viewForEntry:e
                                           forFrame:CGRectMake(i*self.view.frame.size.width, 0, scroller.frame.size.width, scroller.frame.size.height)
                                             forTag:i]];
        }
        
        [scroller setPagingEnabled:YES];
        scroller.contentSize = CGSizeMake(scroller.frame.size.width * entries.count, scroller.frame.size.height);
        
        [self.view addSubview:scroller];
        
        pageControlBeingUsed = NO;
        
        pager = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(scroller.frame), self.view.frame.size.width, 36)];
        [pager setNumberOfPages:entries.count];
        [pager setBackgroundColor:[UIColor clearColor]];
        pager.pageIndicatorTintColor = [UIColor colorWithRed:221.0f/255.0f green:221.0f/255.0f blue:221.0f/255.0f alpha:1.0];
        pager.currentPageIndicatorTintColor = [UIColor whiteColor];
        [self.view addSubview:pager];
        
        [pager addTarget:self action:@selector(pageChanged:) forControlEvents:UIControlEventValueChanged];
        
        if(index > 0)
        {
            CGFloat start = (index * self.view.frame.size.width) + self.view.frame.size.width - 1;
            [scroller scrollRectToVisible:CGRectMake(start, 1, 1, 1) animated:YES];
        }
        
        [pager setCurrentPage:index];

    }
    
}

-(void)pageChanged:(id)sender
{
    CGRect frame;
    frame.origin.x = scroller.frame.size.width * pager.currentPage;
    frame.origin.y = 0;
    frame.size = scroller.frame.size;
    [scroller scrollRectToVisible:frame animated:YES];
    
    pageControlBeingUsed = YES;
    
}

-(UIView *)viewForEntry:(Entry *)e forFrame:(CGRect)frame forTag:(NSInteger)tag
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    [view setTag:999];
    [view setBackgroundColor:[UIColor clearColor]];
    
    XYPieChart *pie = [[XYPieChart alloc] initWithFrame:CGRectZero Center:CGPointMake(self.view.center.x, 200) Radius:130];
    [pie setTag:tag];
    [pie setDataSource:self];
    [pie setDelegate:self];
    [pie setLabelColor:[UIColor clearColor]];

    [view addSubview:pie];
    [pie reloadData];
    
    [pies addObject:pie];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 120)];
    [lbl setText:@" "];
    [lbl.layer setCornerRadius:60];
    [lbl.layer setMasksToBounds:YES];
    [lbl setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:lbl];
    [self.view bringSubviewToFront:lbl];
    [lbl setCenter:CGPointMake(self.view.center.x, 200)];
    [view bringSubviewToFront:lbl];
    
    UIImage *imgShare = [UIImage imageNamed:@"btn-share"];
    UIButton *btnShare = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnShare setImage:imgShare forState:UIControlStateNormal];
    [btnShare addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    [btnShare setFrame:CGRectMake(self.view.frame.size.width/2 - imgShare.size.width/2, 350, imgShare.size.width, imgShare.size.height)];
    [view addSubview:btnShare];
    
    UIImage *imgPhoto = [UIImage imageNamed:@"btn-photo"];
    UIButton *btnPhoto = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnPhoto setTag:tag];
    [btnPhoto setImage:imgPhoto forState:UIControlStateNormal];
    [btnPhoto addTarget:self action:@selector(photo:) forControlEvents:UIControlEventTouchUpInside];
    [btnPhoto setFrame:CGRectMake(CGRectGetMaxX(btnShare.frame) + 5, 330, imgPhoto.size.width, imgPhoto.size.height)];
    [view addSubview:btnPhoto];
    
    UIImage *imgEdit = [UIImage imageNamed:@"btn-edit"];
    UIButton *btnEdit = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnEdit setTag:tag];
    [btnEdit setImage:imgEdit forState:UIControlStateNormal];
    [btnEdit addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
    [btnEdit setFrame:CGRectMake(CGRectGetMaxX(btnPhoto.frame) + 5, 300, imgEdit.size.width, imgEdit.size.height)];
    [view addSubview:btnEdit];

    UILabel *lblDate = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(btnShare.frame) + 10, self.view.frame.size.width, 18)];
    [lblDate setTextAlignment:NSTextAlignmentCenter];
    [lblDate setText:[e longDate]];
    [view addSubview:lblDate];

    UILabel *lblTime = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lblDate.frame) + 10, self.view.frame.size.width, 18)];
    [lblTime setTextAlignment:NSTextAlignmentCenter];
    [lblTime setText:[e shortTime]];
    [view addSubview:lblTime];

    return view;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)edit:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSInteger tag = btn.tag;
    
    Entry *e = nil;
    
    if(entries.count < 2)
        e = entry;
    else
        e = (Entry *)[entries objectAtIndex:tag];
    
    DescriptionViewController *menu = [[DescriptionViewController alloc] init];
    [menu setViewController:self];
    [menu setEntry:e];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:menu];
    [nav.navigationBar setTintColor:[UIColor whiteColor]];
    
    [self.tabBarController setModalPresentationStyle:UIModalPresentationCurrentContext];
    [self presentViewController:nav animated:YES completion:nil];
}

-(void)photo:(id)sender
{
    if(imageViewController)
    {
        [imageViewController setDelegate:nil];
        imageViewController = nil;
    }
    
    UIButton *btn = (UIButton *)sender;
    NSInteger tag = btn.tag;
    
    Entry *e = nil;
    
    if(entries.count < 2)
        e = entry;
    else
        e = (Entry *)[entries objectAtIndex:tag];
    
    imageViewController = [[ImageViewController alloc] init];
    [imageViewController setEntry:e];
    [imageViewController setDelegate:self];
    [self.tabBarController presentViewController:imageViewController animated:YES completion:nil];
}

-(void)share
{
    NSString *s = [NSString stringWithFormat:@"Download #Eat Your Greens: http://eatyourgreens.com "];
    
    NSArray *items  = [NSArray arrayWithObjects:s,nil];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
    [activityViewController setCompletionHandler:^(NSString *activityType, BOOL completed) {
        
    }];
    
    activityViewController.excludedActivityTypes =   @[UIActivityTypeCopyToPasteboard,
                                                       UIActivityTypeAirDrop,
                                                       UIActivityTypeSaveToCameraRoll,
                                                       UIActivityTypeAddToReadingList,
                                                       UIActivityTypeAssignToContact,
                                                       UIActivityTypePrint];
    
    [self presentViewController:activityViewController animated:YES completion:nil];

}

#pragma mark XYPieChartDataSource methods
- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
    Entry *e = nil;
    
    if(entries.count < 2)
        e = entry;
    else
        e = (Entry *)[entries objectAtIndex:pieChart.tag];
    
    return e.entryPoints.count;
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)i
{
    Entry *e = nil;
    
    if(entries.count < 2)
        e = entry;
    else
        e = (Entry *)[entries objectAtIndex:pieChart.tag];

    return (CGFloat)1/e.entryPoints.count;
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)i
{
    Entry *e = nil;
    
    if(entries.count < 2)
        e = entry;
    else
        e = (Entry *)[entries objectAtIndex:pieChart.tag];

    EntryPoint *entryPoint = (EntryPoint *)[e.entryPoints objectAtIndex:i];
    
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
-(void)imageViewController:(ImageViewController *)imageViewController savedForEntry:(Entry *)ent
{
    [self.tabBarController dismissViewControllerAnimated:YES completion:nil];
    
    if(entries.count < 2)
    {
        XYPieChart *pie = (XYPieChart *)[pies objectAtIndex:0];
        [pie reloadData];
        return;
    }

    NSInteger value = 0;
    
    for(int i = 0;i<entries.count;i++)
    {
        Entry *e = (Entry *)[entries objectAtIndex:i];
        if([e.date compare:ent.date] == NSOrderedSame)
        {
            NSMutableArray *array = [NSMutableArray arrayWithArray:entries];
            [array removeObjectAtIndex:i];
            [array insertObject:ent atIndex:i];
            entries = [NSArray arrayWithArray:array];
            value = i;
            break;
        }
    }

    XYPieChart *xy = (XYPieChart *)[pies objectAtIndex:value];
    [xy reloadData];
}


#pragma mark UIScrollViewDelegate methods

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    if(!pageControlBeingUsed)
    {
        CGFloat pageWidth = scroller.frame.size.width;
        int page = floor((scroller.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        pager.currentPage = page;
    }
    
    if(pager.currentPage==1)
    {
        [UIView animateWithDuration:.3 animations:^{
        } completion:^(BOOL finished){
        }];
    }
    else
    {
        [UIView animateWithDuration:.3 animations:^{
        }];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pageControlBeingUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControlBeingUsed = NO;
    
}

@end
