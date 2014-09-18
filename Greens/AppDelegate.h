//
//  AppDelegate.h
//  Greens
//
//  Created by Todd Mathison on 6/10/14.
//  Copyright (c) 2014 Todd Mathison. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, ImageViewControllerDelegate>
{
    ImageViewController *imageViewController;
    UIWindow *loadingWindow;
}

@property (strong, nonatomic) UIWindow *window;

-(void)showHomeScreenForColor:(BOOL)showColor;

@end



/*
 
 Breakdown by page
 Avg. time spent in app
 Photos taken overall
 Meals shared overall
 Overall shares
 Breakdown per channel
 Overall foods marked as allergic on settings page
 Most common color eaten overall
 Overall notes entered
 Most common first-action after app opens
 
 Per user analytics
 App visits per user
 Page visits per user
 Breakdown by page
 Avg. time spent in app per user
 Photos taken per user
 Meals shared per user
 Shares per user
 Breakdown per channel
 Foods marked as allergic on settings page per user
 Most common color eaten per user
 Notes entered per user
 
*/