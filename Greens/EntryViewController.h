//
//  EntryViewController.h
//  Greens
//
//  Created by Todd Mathison on 6/21/14.
//  Copyright (c) 2014 Todd Mathison. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYPieChart.h"
#import "ImageViewController.h"
#import "DescriptionViewController.h"

@class EntryPoint, Entry;

@interface EntryViewController : UIViewController <XYPieChartDataSource, XYPieChartDelegate, ImageViewControllerDelegate, UIScrollViewDelegate, DescriptionViewControllerDelegate>
{
//    XYPieChart *pie;
    
    ImageViewController *imageViewController;
    
    UIScrollView *scroller;
    UIPageControl *pager;
    BOOL pageControlBeingUsed;
    NSMutableArray *pies;
    
    DescriptionViewController *descriptionViewController;
    
}

@property (nonatomic, strong) Entry *entry;
@property (nonatomic, strong) NSArray *entries;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) BOOL isNew;

@end
