//
//  AppDelegate.h
//  Greens
//
//  Created by Todd Mathison on 6/10/14.
//  Copyright (c) 2014 Todd Mathison. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, ImageViewControllerDelegate, UIAlertViewDelegate>
{
    ImageViewController *imageViewController;
}

@property (strong, nonatomic) UIWindow *window;

@end



/*

 meal entry
 screen search notes
 icon match the actual pie chart on the list of meal entries
 
 camera - see if I can remove the navigation bar and add the grid lines
 
 
 pie chart screen
 
 
 settings -
 use list of foods from tips & reminders
 these are the foods you don’t like or are allergic too
 don’t show tips from this list that the user selects



*/