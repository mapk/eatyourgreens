//
//  AppDelegate.m
//  Greens
//
//  Created by Todd Mathison on 6/10/14.
//  Copyright (c) 2014 Todd Mathison. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "EntriesTableViewController.h"
#import "FoodsTableViewController.h"
#import "TipsTableViewController.h"
#import "SettingsTableViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "Entry.h"
#import "Utils.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window setRootViewController:[self tabBarController]];
    [self.window makeKeyAndVisible];
    
    return YES;
}

-(UITabBarController *)tabBarController
{
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    [tabBarController setDelegate:self];
    
    FoodsTableViewController *vc1 = [[FoodsTableViewController alloc] init];
    EntriesTableViewController *vc2 = [[EntriesTableViewController alloc] init];
    ViewController *vc3 = [[ViewController alloc] init];
    TipsTableViewController *vc4 = [[TipsTableViewController alloc] init];
    SettingsTableViewController *vc5 = [[SettingsTableViewController alloc] init];
    
    UITabBarItem *tb1 = [[UITabBarItem alloc] initWithTitle:@"Colors" image:[UIImage imageNamed:@"nav-apple"] selectedImage:[UIImage imageNamed:@"nav-apple-active"]];
    UITabBarItem *tb2 = [[UITabBarItem alloc] initWithTitle:@"Entries" image:[UIImage imageNamed:@"nav-colorwheel"] selectedImage:[UIImage imageNamed:@"nav-colorwheel-active"]];
    UITabBarItem *tb3 = [[UITabBarItem alloc] initWithTitle:@"Camera" image:[UIImage imageNamed:@"nav-camera"] tag:999];
    UITabBarItem *tb4 = [[UITabBarItem alloc] initWithTitle:@"Tips" image:[UIImage imageNamed:@"nav-book"] selectedImage:[UIImage imageNamed:@"nav-book-active"]];
    UITabBarItem *tb5 = [[UITabBarItem alloc] initWithTitle:@"Settings" image:[UIImage imageNamed:@"nav-cog"] selectedImage:[UIImage imageNamed:@"nav-cog"]];

    UIColor *navColor = [UIColor colorWithRed:54.0f/255.0f green:59.0f/255.0f blue:71.0f/255.0f alpha:1.0];
    [[UINavigationBar appearance] setBarTintColor:navColor];

    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:vc1];
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:vc2];
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:vc3];
    UINavigationController *nav4 = [[UINavigationController alloc] initWithRootViewController:vc4];
    UINavigationController *nav5 = [[UINavigationController alloc] initWithRootViewController:vc5];
    
    [nav1.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [nav2.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [nav3.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [nav4.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [nav5.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    [nav1.navigationBar setTintColor:[UIColor whiteColor]];
    [nav2.navigationBar setTintColor:[UIColor whiteColor]];
    [nav3.navigationBar setTintColor:[UIColor whiteColor]];
    [nav4.navigationBar setTintColor:[UIColor whiteColor]];
    [nav5.navigationBar setTintColor:[UIColor whiteColor]];
    
    [nav1 setTabBarItem:tb1];
    [nav2 setTabBarItem:tb2];
    [nav3 setTabBarItem:tb3];
    [nav4 setTabBarItem:tb4];
    [nav5 setTabBarItem:tb5];
    
    /*
    NSDictionary *tabTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                       [UIColor whiteColor], NSForegroundColorAttributeName,
                                       [NSValue valueWithUIOffset:UIOffsetMake(0,0)], UITextAttributeTextShadowOffset,
                                       [UIFont fontWithName:@"Comfortaa-Regular" size:12.0], UITextAttributeFont, nil];
    
    NSDictionary *tabTextAttributesSelected = [NSDictionary dictionaryWithObjectsAndKeys:
                                               [UIColor greenColor], NSForegroundColorAttributeName,
                                               [NSValue valueWithUIOffset:UIOffsetMake(0,0)], UITextAttributeTextShadowOffset,
                                               [UIFont fontWithName:@"Comfortaa-Regular" size:12.0], UITextAttributeFont, nil];
    
    [tb1 setTitleTextAttributes:tabTextAttributes forState:UIControlStateNormal];
    [tb2 setTitleTextAttributes:tabTextAttributes forState:UIControlStateNormal];
    [tb3 setTitleTextAttributes:tabTextAttributes forState:UIControlStateNormal];
    [tb4 setTitleTextAttributes:tabTextAttributes forState:UIControlStateNormal];
    
    [tb1 setTitleTextAttributes:tabTextAttributesSelected forState:UIControlStateSelected];
    [tb2 setTitleTextAttributes:tabTextAttributesSelected forState:UIControlStateSelected];
    [tb3 setTitleTextAttributes:tabTextAttributesSelected forState:UIControlStateSelected];
    [tb4 setTitleTextAttributes:tabTextAttributesSelected forState:UIControlStateSelected];
    */
    
    
    [tabBarController.tabBar setBackgroundImage:[UIImage imageNamed:@"tab_bar_background"]];
    
    [tabBarController setViewControllers:@[nav1, nav2, nav3, nav4, nav5]];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, -vc1.view.frame.size.height, vc1.view.frame.size.width, vc1.view.frame.size.height)];
    [v setTag:999];
    [v setBackgroundColor:[UIColor colorWithRed:242.0f/255.0f green:242.0f/255.0f blue:242.0f/255.0f alpha:1.0f]];
    
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 28, v.frame.size.width, 64)];
    [v addSubview:navBar];
    
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, navBar.frame.size.width, navBar.frame.size.height - 20)];
    [lblTitle setFont:[UIFont boldSystemFontOfSize:17.0f]];
    [lblTitle setTextColor:[UIColor whiteColor]];
    [lblTitle setBackgroundColor:[UIColor clearColor]];
    [lblTitle setText:@"Eat Your Greens"];
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    [navBar addSubview:lblTitle];
    
    UIImage *img = [UIImage imageNamed:@"home-colorwheel"];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
    [imgView setFrame:CGRectMake(v.frame.size.width/2 - img.size.width/2, CGRectGetMaxY(navBar.frame) + 10, img.size.width, img.size.height)];
    [v addSubview:imgView];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectZero];
    [lbl setText:@"Start taking pictures of your food and see what colors you've been eating."];
    [lbl setTextAlignment:NSTextAlignmentCenter];
    [lbl setNumberOfLines:2];
    [lbl setLineBreakMode:NSLineBreakByWordWrapping];
    [lbl setFrame:CGRectMake(25, v.frame.size.height - 60, 270, 35)];
    [lbl setFont:kStandardFont];
    [v addSubview:lbl];
    
    [tabBarController.tabBar addSubview:v];
    
    return tabBarController;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)app didReceiveLocalNotification:(UILocalNotification *)notif
{
    UITabBarController *tab = (UITabBarController *)self.window.rootViewController;
    [tab setSelectedIndex:3];
}


-(void)removeView:(UIView *)view
{
    [view removeFromSuperview];
    view = nil;
}


#pragma mark UITabBarControllerDelegate methods
-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    for(int i = 0;i<tabBarController.tabBar.subviews.count;i++)
    {
        UIView *v = (UIView *)[tabBarController.tabBar.subviews objectAtIndex:i];
        if(v.tag == 999)
        {
            [UIView animateWithDuration:.2 animations:^{
                [v setAlpha:0.0f];
            } completion:^(BOOL finished){
                [self removeView:v];
            }];
        }
    }
    
    
    BOOL value = YES;
    
    UINavigationController *nav = (UINavigationController *)viewController;
    
    if([nav.viewControllers.firstObject isKindOfClass:[ViewController class]])
    {
        value = NO;
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        [imagePicker.navigationBar setTintColor:[UIColor whiteColor]];
        [imagePicker.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
        [imagePicker setDelegate:self];
        
        if([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]
           || [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront])
        {
            [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
            [imagePicker setCameraCaptureMode:UIImagePickerControllerCameraCaptureModePhoto];
        }
        else
        {
            [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            [imagePicker setMediaTypes:[NSArray arrayWithObject:(NSString *) kUTTypeImage]];
        }
        
        [self.window.rootViewController presentViewController:imagePicker animated:YES completion:nil];
        
        
        if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstPhoto"])
        {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstPhoto"];
            [[[UIAlertView alloc] initWithTitle:nil message:@"Use the Target icon to select the colors of your food." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:@"Set Target", nil] show];
        }
        
        
        /*
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take New Picture", @"Select Picture From Library", nil];
        [actionSheet showInView:self.window.rootViewController.view];
         */
    }
    
    return value;
}

/*
#pragma mark UIActionSheetDelegate methods
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == actionSheet.cancelButtonIndex) return;
    
    if(buttonIndex == 0)
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        [imagePicker setDelegate:self];
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [imagePicker setCameraCaptureMode:UIImagePickerControllerCameraCaptureModePhoto];
        [self.window.rootViewController presentViewController:imagePicker animated:YES completion:nil];
        
    }
    else if(buttonIndex == 1)
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        [imagePicker setDelegate:self];
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [imagePicker setMediaTypes:[NSArray arrayWithObject:(NSString *) kUTTypeImage]];
        [self.window.rootViewController presentViewController:imagePicker animated:YES completion:nil];
        
    }
    
}
*/

#pragma mark UIImagePickerControllerDelegate methods
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    loadingWindow = [Utils showLoadingScreen];
    
    [self.window.rootViewController dismissViewControllerAnimated:YES completion:^{
    
        if([info objectForKey:UIImagePickerControllerOriginalImage])
        {
            if(imageViewController)
            {
                [imageViewController setDelegate:nil];
                imageViewController = nil;
            }
            
            UIImage *image = (UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];
            
            Entry *entry = [[Entry alloc] init];
            [entry setDate:[NSDate date]];
            [entry setImage:image];
            
            imageViewController = [[ImageViewController alloc] init];
            [imageViewController setDelegate:self];
            [imageViewController setEntry:entry];
            [self.window.rootViewController presentViewController:imageViewController animated:YES completion:^{
                [Utils dismissLoadingWindow:loadingWindow];
            }];
        }
    }];
}

#pragma mark ImageViewControllerDelegate methods
-(void)imageViewController:(ImageViewController *)imageViewController savedForEntry:(Entry *)entry
{
    loadingWindow = [Utils showLoadingScreen];
    
    [self.window.rootViewController dismissViewControllerAnimated:YES completion:^{
        [Utils dismissLoadingWindow:loadingWindow];
    }];
    
    UITabBarController *tab = (UITabBarController *)self.window.rootViewController;
    
    UINavigationController *nav = (UINavigationController *)[tab.viewControllers objectAtIndex:1];
    [nav popToRootViewControllerAnimated:NO];

    EntriesTableViewController *entries = (EntriesTableViewController *)nav.viewControllers.firstObject;
    [entries newEntry:entry];
    [tab setSelectedIndex:1];
}

#pragma mark UIAlertViewDelegate methods
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == alertView.cancelButtonIndex)
    {
        [self.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    
}
@end
