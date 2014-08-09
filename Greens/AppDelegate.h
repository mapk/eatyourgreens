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
    UIWindow *loadingWindow;
}

@property (strong, nonatomic) UIWindow *window;

@end


