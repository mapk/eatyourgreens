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
#import "Utils.h"
#import "Tips.h"
#import "UIView+Toast.h"
#import "UIImage+ImageEffects.h"

@interface EntryViewController ()

@end

@implementation EntryViewController

@synthesize entry, entries, index, isNew;

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
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.view setBackgroundColor:kColor_Background];
    pies = [[NSMutableArray alloc] init];
    expansionLevel = ExpansionLevelEntry;
    
    
    for(int i = 0;i<entries.count;i++)
    {
        Entry *e = (Entry *)[entries objectAtIndex:i];
        for(int j = 0;j<e.entryPoints.count;j++)
        {
            EntryPoint *ep = (EntryPoint *)[e.entryPoints objectAtIndex:j];
            if(ep.hue == (CGFloat)0)
                [ep setColor:ep.color];
        }
        
        e.entryPoints = [e.entryPoints sortedArrayUsingComparator:^NSComparisonResult(EntryPoint *p1, EntryPoint *p2){
            return [[NSNumber numberWithFloat:p1.hue] compare:[NSNumber numberWithFloat:p2.hue]];
        }];
        
        for(int j = 0;j<e.entryPoints.count;j++)
        {
            EntryPoint *ep = (EntryPoint *)[e.entryPoints objectAtIndex:j];
//            NSLog(@"Hue: %f", ep.hue);
        }
        
    }
    
    
    if(entries.count < 2)
        [self.view addSubview:[self viewForEntry:entry forFrame:self.view.frame forTag:0]];
    else
    {
        pageControlBeingUsed = NO;
        
        [self loadScroller];
        
        pager = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(scroller.frame), self.view.frame.size.width, 36)];
        [pager setNumberOfPages:entries.count];
        [pager setBackgroundColor:[UIColor clearColor]];
        pager.pageIndicatorTintColor = [UIColor colorWithRed:221.0f/255.0f green:221.0f/255.0f blue:221.0f/255.0f alpha:1.0];
        pager.currentPageIndicatorTintColor = [UIColor whiteColor];
        [pager addTarget:self action:@selector(pageChanged:) forControlEvents:UIControlEventValueChanged];
        [pager setCurrentPage:index];
        [self.view addSubview:pager];
    }
    
    if(isNew)
        [Tips checkForTip];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    pinchRecognizer =[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
    [pinchRecognizer setDelegate:self];
    [self.view addGestureRecognizer:pinchRecognizer];
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.view removeGestureRecognizer:pinchRecognizer];
}

-(void)pinch:(id)sender {

    if(pinchRecognizer)
    {
        if(pinchRecognizer.scale > 1.4)
        {
            pinchRecognizer.scale = 1.0;
            [self addExpandedGraph];
        }
        else if (pinchRecognizer.scale < .6)
        {
            pinchRecognizer.scale = 1.0;
            [self removeExpandedGraph];
        }
    }
    
}

-(void)addExpandedGraph
{
    if(expansionLevel == ExpansionLevelEntry)
        expansionLevel = ExpansionLevelDay;
    else if (expansionLevel == ExpansionLevelDay)
        expansionLevel = ExpansionLevelWeek;
    else if (expansionLevel == ExpansionLevelWeek)
        expansionLevel = ExpansionLevel30Days;
    else if (expansionLevel == ExpansionLevel30Days)
        return;
    
    NSArray *graphEntries = [Entry fetchFiles];
    NSTimeInterval time = 60 * 60 * 24 * -1;
    
    if(expansionLevel == ExpansionLevelWeek)
        time = time * 7;
    else if (expansionLevel == ExpansionLevel30Days)
        time = time * 30;
    
    NSDate *startDate = nil;
    Entry *e = nil;
    
    if(entries.count < 2)
        e = entry;
    else
        e = (Entry *)[entries objectAtIndex:pager.currentPage];
    
    startDate = [e.date dateByAddingTimeInterval:time];

    if(filteredEntries)
    {
        [filteredEntries removeAllObjects];
        filteredEntries = nil;
    }

    if(filteredEntryPoints)
    {
        [filteredEntryPoints removeAllObjects];
        filteredEntryPoints = nil;
    }
    
    filteredEntries = [[NSMutableArray alloc] init];
    
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateStyle:NSDateFormatterShortStyle];
    [df setTimeStyle:NSDateFormatterShortStyle];

    
    
    for(int i = (int)graphEntries.count-1;i>-1;i--)
    {
        Entry *ent = (Entry *)[graphEntries objectAtIndex:i];
        
//        NSLog(@"Start: %@, Ent: %@, E: %@", [df stringFromDate:startDate], [df stringFromDate:ent.date], [df stringFromDate:e.date]);
        
        if(([ent.date compare:startDate] == NSOrderedDescending
           && [ent.date compare:e.date] == NSOrderedAscending) || [ent.date compare:e.date] == NSOrderedSame)
        {
            [filteredEntries addObject:ent];
        }
    }
    
    if(filteredEntries.count == 0)
        return;
    
    filteredEntryPoints = [[NSMutableArray alloc] init];
    for(Entry *e in filteredEntries)
        [filteredEntryPoints addObjectsFromArray:e.entryPoints];

    for(int i = 0;i<filteredEntryPoints.count;i++)
    {
        EntryPoint *ep = (EntryPoint *)[filteredEntryPoints objectAtIndex:i];
        if(ep.hue == 0)
            [ep setColor:ep.color];
        
//        NSLog(@"%f", ep.hue);
    }
    
    
    NSArray *a = [filteredEntryPoints sortedArrayUsingComparator:^NSComparisonResult(EntryPoint *ep1, EntryPoint *ep2){
        return [[NSNumber numberWithFloat:ep1.hue] compare:[NSNumber numberWithFloat:ep2.hue]];
    }];
    
    filteredEntryPoints = [NSMutableArray arrayWithArray:a];

    /*
    for(int i = 0;i<filteredEntryPoints.count;i++)
    {
        EntryPoint *ep = (EntryPoint *)[filteredEntryPoints objectAtIndex:i];
        NSLog(@"%f", ep.hue);
    }
    */
    
    UIView *v = [[UIView alloc] initWithFrame:self.view.bounds];
    [v setTag:101 + expansionLevel];
    [v setBackgroundColor:[UIColor whiteColor]];
    
    UIImage *wheelImage = [UIImage imageNamed:@"wheel-bg"];
    UIImageView *wheelImageView = [[UIImageView alloc] initWithImage:wheelImage];
    [wheelImageView setFrame:CGRectMake(v.frame.size.width/2 - wheelImage.size.width/2, 10, wheelImage.size.width, wheelImage.size.height)];
    [v addSubview:wheelImageView];

    XYPieChart *pie = [[XYPieChart alloc] initWithFrame:CGRectZero Center:CGPointMake(wheelImage.size.width/2, wheelImage.size.height/2) Radius:((wheelImageView.frame.size.width/2) - 15)];
    [pie setDataSource:self];
    [pie setDelegate:self];
    [pie setLabelColor:[UIColor clearColor]];
    
    [wheelImageView addSubview:pie];
    [pie reloadData];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [lbl setText:@" "];
    [lbl.layer setCornerRadius:50];
    [lbl.layer setMasksToBounds:YES];
    [lbl setBackgroundColor:[UIColor whiteColor]];
    [wheelImageView addSubview:lbl];
    [wheelImageView bringSubviewToFront:lbl];
    [lbl setCenter:CGPointMake(wheelImage.size.width/2, wheelImage.size.height/2)];
    
    
    NSString *sDate = [NSString stringWithFormat:@"From: %@\nTo: %@", [df stringFromDate:startDate], [df stringFromDate:e.date]];
    
    UILabel *lblDate = [[UILabel alloc] initWithFrame:CGRectMake(0, v.frame.size.height - 60, self.view.frame.size.width, 40)];
    [lblDate setFont:kStandardFont];
    [lblDate setTextAlignment:NSTextAlignmentCenter];
    [lblDate setText:sDate];
    [lblDate setNumberOfLines:0];
    [lblDate setLineBreakMode:NSLineBreakByWordWrapping];
    [v setAlpha:0.0];
    [v addSubview:lblDate];
    
    [self.view addSubview:v];
    
    [UIView animateWithDuration:.3 animations:^{[v setAlpha:1.0f];}];
    
}

-(void)removeExpandedGraph
{
    UIView *v = nil;
    
    if(expansionLevel == ExpansionLevel30Days)
    {
        expansionLevel = ExpansionLevelWeek;
        v = [self.view viewWithTag:101 + ExpansionLevel30Days];
    }
    else if (expansionLevel == ExpansionLevelWeek)
    {
        expansionLevel = ExpansionLevelDay;
        
        v = [self.view viewWithTag:101 + ExpansionLevelWeek];
    }
    else if (expansionLevel == ExpansionLevelDay)
    {
        expansionLevel = ExpansionLevelEntry;
        [filteredEntries removeAllObjects];
        
        v = [self.view viewWithTag:101 + ExpansionLevelDay];
    }
    
    if(v)
    {
        [UIView animateWithDuration:.3 animations:^{
            [v setAlpha:0.0f];
        } completion:^(BOOL finished){
            [v removeFromSuperview];
        }];
    }
}

-(void)loadScroller
{
    scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
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
    
    if(index > 0)
    {
        CGFloat start = (index * self.view.frame.size.width) + self.view.frame.size.width - 1;
        [scroller scrollRectToVisible:CGRectMake(start, 1, 1, 1) animated:YES];
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
    
    UIImage *wheelImage = [UIImage imageNamed:@"wheel-bg"];
    UIImageView *wheelImageView = [[UIImageView alloc] initWithImage:wheelImage];
    [wheelImageView setTag:tag];
    [wheelImageView setFrame:CGRectMake(frame.size.width/2 - wheelImage.size.width/2, 10, wheelImage.size.width, wheelImage.size.height)];
    [view addSubview:wheelImageView];
    
    XYPieChart *pie = [[XYPieChart alloc] initWithFrame:CGRectZero Center:CGPointMake(wheelImage.size.width/2, wheelImage.size.height/2) Radius:((wheelImageView.frame.size.width/2) - 15)];
    [pie setTag:tag];
    [pie setDataSource:self];
    [pie setDelegate:self];
    [pie setLabelColor:[UIColor clearColor]];
    
    

    [wheelImageView addSubview:pie];
    [pie reloadData];
    
    [pies addObject:pie];
     
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [lbl setText:@" "];
    [lbl.layer setCornerRadius:50];
    [lbl.layer setMasksToBounds:YES];
    [lbl setBackgroundColor:[UIColor whiteColor]];
    [wheelImageView addSubview:lbl];
    [wheelImageView bringSubviewToFront:lbl];
    [lbl setCenter:CGPointMake(wheelImage.size.width/2, wheelImage.size.height/2)];
    
    UIImage *imgShare = [UIImage imageNamed:@"btn-share"];
    UIButton *btnShare = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnShare setTag:tag];
    [btnShare setImage:imgShare forState:UIControlStateNormal];
    [btnShare addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    [btnShare setFrame:CGRectMake(self.view.frame.size.width/2 - imgShare.size.width/2, 300, imgShare.size.width, imgShare.size.height)];
    [view addSubview:btnShare];
    
    UIImage *imgPhoto = [UIImage imageNamed:@"btn-photo"];
    UIButton *btnPhoto = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnPhoto setTag:tag];
    [btnPhoto setImage:imgPhoto forState:UIControlStateNormal];
    [btnPhoto addTarget:self action:@selector(photo:) forControlEvents:UIControlEventTouchUpInside];
    [btnPhoto setFrame:CGRectMake(CGRectGetMaxX(btnShare.frame) + 10, 285, imgPhoto.size.width, imgPhoto.size.height)];
    [view addSubview:btnPhoto];
    
    UIImage *imgEdit = [UIImage imageNamed:@"btn-edit"];
    UIButton *btnEdit = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnEdit setTag:tag];
    [btnEdit setImage:imgEdit forState:UIControlStateNormal];
    [btnEdit addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
    [btnEdit setFrame:CGRectMake(CGRectGetMaxX(btnPhoto.frame) + 5, 250, imgEdit.size.width, imgEdit.size.height)];
    [view addSubview:btnEdit];

    CGFloat height = [UIScreen mainScreen].bounds.size.height - self.navigationController.navigationBar.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height - self.tabBarController.tabBar.frame.size.height - 50;
    
    UILabel *lblDate = [[UILabel alloc] initWithFrame:CGRectMake(0, height, self.view.frame.size.width, 18)];
    [lblDate setFont:kStandardFont];
    [lblDate setTextAlignment:NSTextAlignmentCenter];
    [lblDate setText:[e longDate]];
    [view addSubview:lblDate];

    UILabel *lblTime = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lblDate.frame), self.view.frame.size.width, 18)];
    [lblTime setFont:kStandardFont];
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
    
    if(descriptionViewController)
    {
        [descriptionViewController setDelegate:nil];
        descriptionViewController = nil;
    }
    
    descriptionViewController = [[DescriptionViewController alloc] init];
    [descriptionViewController setViewController:self];
    [descriptionViewController setEntry:e];
    [descriptionViewController setDelegate:self];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:descriptionViewController];
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
    [imageViewController setReadOnly:YES];
    [imageViewController setEntry:e];
    [imageViewController setDelegate:self];
    [self.tabBarController presentViewController:imageViewController animated:YES completion:nil];
}

-(UIImage *)imageForPieForTag:(NSInteger)tag
{

    UIView *view = nil;
    
    if(scroller)
    {
        for(UIView *v in scroller.subviews)
            for(UIView *v1 in v.subviews)
                if(v1.tag == tag && [v1 isKindOfClass:[UIImageView class]])
                    view = v1;
    }
    else
    {
        for(UIView *v in self.view.subviews)
            for(UIView *v1 in v.subviews)
                if(v1.tag == tag && [v1 isKindOfClass:[UIImageView class]])
                    view = v1;
    }
    
    return [Utils imageWithView:view];

}

-(void)share:(id)sender
{
    
    
    UIGraphicsBeginImageContext(self.view.bounds.size);
    [self.view drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:NO];
    UIImage *blurImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    blurImg = [blurImg applyBlurWithRadius:5 tintColor:[UIColor colorWithWhite:1.0f alpha:0.3f] saturationDeltaFactor:1.0f maskImage:nil];
    
    UIImageView *iv = [[UIImageView alloc] initWithImage:blurImg];
    [iv setTag:9999];
    [iv setFrame:CGRectMake(0, 0, blurImg.size.width, blurImg.size.height)];
    [self.view addSubview:iv];
        
    
    
        
    
    UIButton *btn = (UIButton *)sender;
    NSInteger tag = btn.tag;

    UIImage *img = [self imageForPieForTag:tag];
    
    NSString *s = [NSString stringWithFormat:@"I'm eating a variety of color with the help of the mobile app, Eat Your Greens. Check out my color wheel of foods. http://EatYourGreensApp.com"];
    
    NSArray *items  = [NSArray arrayWithObjects:s,img,nil];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
    [activityViewController setCompletionHandler:^(NSString *activityType, BOOL completed) {
        
        UIView *v = [self.view viewWithTag:9999];
        [v removeFromSuperview];
        
    }];
    
    activityViewController.excludedActivityTypes =   @[UIActivityTypeCopyToPasteboard,
                                                       UIActivityTypeAirDrop,
                                                       UIActivityTypeSaveToCameraRoll,
                                                       UIActivityTypeAddToReadingList,
                                                       UIActivityTypeAssignToContact,
                                                       UIActivityTypePrint];
    
    
    NSAttributedString *as = [[NSAttributedString alloc] initWithString:@"Cancel" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:65.f/255.0f green:70.f/255.0f blue:80.f/255.0f alpha:1.0f]}];
    [[UIButton appearanceWhenContainedIn:[UIActivityViewController class], nil] setAttributedTitle:as forState:UIControlStateNormal];
    
    
    
    [self presentViewController:activityViewController animated:YES completion:nil];

}

#pragma mark XYPieChartDataSource methods
- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
    if(filteredEntries.count > 0)
    {
        NSInteger count = 0;
        
        for(Entry *e in filteredEntries)
            count = count + e.entryPoints.count;
        
        return count;
    }
    
    
    
    Entry *e = nil;
    
    if(entries.count < 2)
        e = entry;
    else
        e = (Entry *)[entries objectAtIndex:pieChart.tag];
    
    NSUInteger value = e.entryPoints.count;
    
//    if(value > 1)
//        value = value + value;
        
    return value;
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)i
{
    
    if(filteredEntries.count > 0)
    {
        NSInteger count = 0;
        
        for(Entry *e in filteredEntries)
            count = count + e.entryPoints.count;
        
        return (CGFloat)1/count;
    }
    
    
    Entry *e = nil;
    
    if(entries.count < 2)
        e = entry;
    else
        e = (Entry *)[entries objectAtIndex:pieChart.tag];

    CGFloat value = (CGFloat)1/e.entryPoints.count;
  
    /*
    if(e.entryPoints.count > 1)
    {
        if(i % 2 == 1)
            value = .005;
        else
            value = value - .005;
    }
     */
    
    return value;
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)i
{
    if(filteredEntries.count > 0)
    {
        EntryPoint *ep = (EntryPoint *)[filteredEntryPoints objectAtIndex:i];
        return ep.color;
    }

    
    
    Entry *e = nil;
    
    if(entries.count < 2)
        e = entry;
    else
        e = (Entry *)[entries objectAtIndex:pieChart.tag];

    EntryPoint *entryPoint = nil;
    UIColor *color = [UIColor clearColor];

    entryPoint = (EntryPoint *)[e.entryPoints objectAtIndex:i];
    color = entryPoint.color;
    
/*
    if(e.entryPoints.count == 1)
    {
        entryPoint = (EntryPoint *)[e.entryPoints objectAtIndex:i];
        color = entryPoint.color;
    }
    else
    {
        if(i % 2 == 0)
        {
            entryPoint = (EntryPoint *)[e.entryPoints objectAtIndex:i/2];
            color = entryPoint.color;
        }
    }
 */
    
    return color;
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

-(void)animationCompleteForPieChart:(XYPieChart *)pieChart
{
    if(filteredEntries.count > 0)
        return;
    
    if(!entry.iconPath)
    {
        UIImage *image = [self imageForPieForTag:pieChart.tag];
        image = [Utils image:image byScalingAndCroppingForSize:CGSizeMake(80, 80)];
        [entry setIcon:image];
        [entry save];
    }
}

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

#pragma mark DescriptionViewControllerDelegate methods
-(void)descriptionViewControllerCompleted:(DescriptionViewController *)vc
{
    [self.view makeToast:@"Description Saved"];
}

@end
