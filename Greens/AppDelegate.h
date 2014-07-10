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
}

@property (strong, nonatomic) UIWindow *window;

@end



/*

 home screen - always show that home screen when starting up, then clicking on a tab makes it go away
 splash screen
 food color fonts consistent across screens
 
 food color screens - line to space out each food item
 change text of back button on sub screen to read “Back”
 
 
 
 meal entry
 screen search notes
 icon match the actual pie chart on the list of meal entries
 
 camera - see if I can remove the navigation bar and add the grid lines
 
 prompt the user the first time to “use the icon to set the target”  only prompt the first time
 
 
 
 
 
 
 pie chart screen
 -	add white donut hole circle in the middle
 -	add background image behind the pie chart
 - 	when sharing - share out the picture of the pie chart
 
 date and time vertical spacing
 
 
 notes page - same font size as everywhere else
 
 
 
 settings -
 use list of foods from tips & reminders
 these are the foods you don’t like or are allergic too
 don’t show tips from this list that the user selects



*/