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

@class EntryPoint, Entry;

@interface EntryViewController : UIViewController <XYPieChartDataSource, XYPieChartDelegate, ImageViewControllerDelegate>
{
    XYPieChart *pie;
    
    ImageViewController *imageViewController;
}

@property (nonatomic, strong) Entry *entry;

@end
