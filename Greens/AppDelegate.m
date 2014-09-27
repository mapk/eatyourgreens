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
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-54070427-2"];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window setRootViewController:[self tabBarController]];
    [self.window makeKeyAndVisible];
    
    [self showHomeScreenForColor:NO];

    
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
    UITabBarItem *tb3 = [[UITabBarItem alloc] initWithTitle:@"Camera" image:[UIImage imageNamed:@"nav-apple"] tag:999];
    UITabBarItem *tb4 = [[UITabBarItem alloc] initWithTitle:@"Tips" image:[UIImage imageNamed:@"nav-book"] selectedImage:[UIImage imageNamed:@"nav-book-active"]];
    UITabBarItem *tb5 = [[UITabBarItem alloc] initWithTitle:@"Settings" image:[UIImage imageNamed:@"nav-cog"] selectedImage:[UIImage imageNamed:@"nav-cog"]];

    UIColor *navColor = [UIColor colorWithRed:55.0f/255.0f green:61.0f/255.0f blue:72.0f/255.0f alpha:1.0];
    [[UINavigationBar appearance] setBarTintColor:navColor];

    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:vc1];
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:vc2];
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:vc3];
    UINavigationController *nav4 = [[UINavigationController alloc] initWithRootViewController:vc4];
    UINavigationController *nav5 = [[UINavigationController alloc] initWithRootViewController:vc5];
    
    [nav1.navigationBar setTranslucent:NO];
    [nav2.navigationBar setTranslucent:NO];
    [nav3.navigationBar setTranslucent:NO];
    [nav4.navigationBar setTranslucent:NO];
    [nav5.navigationBar setTranslucent:NO];
    
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

    
    UIImage *imgColors = [UIImage imageNamed:@"nav-colors"];
    UIButton *btnColors = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnColors setImage:imgColors forState:UIControlStateNormal];
    
    UIImage *imgEntries = [UIImage imageNamed:@"nav-entries"];
    UIButton *btnEntries = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnEntries setImage:imgEntries forState:UIControlStateNormal];
    
    UIImage *imgCamera = [UIImage imageNamed:@"nav-camera"];
    UIButton *btnCamera = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnCamera setImage:imgCamera forState:UIControlStateNormal];
    
    UIImage *imgTips = [UIImage imageNamed:@"nav-tips"];
    UIButton *btnTips = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnTips setImage:imgTips forState:UIControlStateNormal];
    
    UIImage *imgSettings = [UIImage imageNamed:@"nav-settings"];
    UIButton *btnSettings = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnSettings setImage:imgSettings forState:UIControlStateNormal];
    
    
    
    
    [tabBarController.tabBar setBackgroundImage:[UIImage imageNamed:@"tab_bar_background"]];
    [tabBarController setViewControllers:@[nav1, nav2, nav3, nav4, nav5]];
    
    
    
    [btnColors addTarget:self action:@selector(selectColors:) forControlEvents:UIControlEventTouchUpInside];
    [btnEntries addTarget:self action:@selector(selectEntries:) forControlEvents:UIControlEventTouchUpInside];
    [btnCamera addTarget:self action:@selector(selectCamera:) forControlEvents:UIControlEventTouchUpInside];
    [btnTips addTarget:self action:@selector(selectTips:) forControlEvents:UIControlEventTouchUpInside];
    [btnSettings addTarget:self action:@selector(selectSettings:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat v1 = (tabBarController.tabBar.frame.size.width/tabBarController.viewControllers.count) / 2;
    
    CGFloat s1 = v1 - imgColors.size.width/2;
    CGFloat s2 = v1 + v1*2 - imgEntries.size.width/2;
    CGFloat s3 = v1 + v1*4 - imgCamera.size.width/2;
    CGFloat s4 = v1 + v1*6 - imgTips.size.width/2;
    CGFloat s5 = v1 + v1*8 - imgSettings.size.width/2;
    
    [btnColors setFrame:CGRectMake(0, 0, imgColors.size.width, imgColors.size.height)];
    [btnEntries setFrame:CGRectMake(s2, 0, imgEntries.size.width, imgEntries.size.height)];
    [btnCamera setFrame:CGRectMake(s3, 0, imgCamera.size.width, imgCamera.size.height)];
    [btnTips setFrame:CGRectMake(s4 + 1, 0, imgTips.size.width, imgTips.size.height)];
    [btnSettings setFrame:CGRectMake(s5 + 1, 0, imgSettings.size.width, imgSettings.size.height)];
    
    
    [tabBarController.tabBar addSubview:btnColors];
    [tabBarController.tabBar addSubview:btnEntries];
    [tabBarController.tabBar addSubview:btnCamera];
    [tabBarController.tabBar addSubview:btnTips];
    [tabBarController.tabBar addSubview:btnSettings];
    
    [btnColors setTag:998];
    [btnEntries setTag:997];
    [btnCamera setTag:996];
    [btnTips setTag:995];
    [btnSettings setTag:994];
    
    [tabBarController.tabBar.layer setBorderColor:[UIColor clearColor].CGColor];
    [[UITabBar appearance] setShadowImage:[Utils imageWithColor:[UIColor clearColor] andSize:CGSizeMake(320, 1)]];

    return tabBarController;
}

-(void)showHomeScreenForColor:(BOOL)showColor
{
    
    UITabBarController *tab = (UITabBarController *)self.window.rootViewController;
    UINavigationController *nav = (UINavigationController *)[tab.viewControllers firstObject];
    UIViewController *vc1 = (UIViewController *)[nav.viewControllers firstObject];

    
    CGFloat height = -vc1.view.frame.size.height;
    if(vc1.view.frame.origin.y == 20)
        height = height + 93;
    
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, height, vc1.view.frame.size.width, height * -1)];
    [v setTag:999];
    [v setBackgroundColor:[UIColor colorWithRed:242.0f/255.0f green:242.0f/255.0f blue:242.0f/255.0f alpha:1.0f]];
    
    
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, -64, v.frame.size.width, 64)];
    [v addSubview:navBar];
    
    UIColor *navColor = [UIColor colorWithRed:55.0f/255.0f green:61.0f/255.0f blue:72.0f/255.0f alpha:1.0];
    [[UINavigationBar appearance] setBarTintColor:navColor];
    [navBar setBackgroundColor:navColor];
    [navBar setTranslucent:NO];
    
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
    
    NSString *color = [Entry averageColor];
    
    NSString *trackingLabel = @"";
    
    if(showColor && color.length > 0)
    {
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectZero];
        [lbl setText:@"Boy, do you enjoy eating the color:"];
        [lbl setTextAlignment:NSTextAlignmentCenter];
        [lbl setFrame:CGRectMake(15, v.frame.size.height - 83, 290, 20)];
        [lbl setFont:kStandardFont];
        [lbl setTextColor:kColor_Text];
        [v addSubview:lbl];
        
        UILabel *lblColor = [[UILabel alloc] initWithFrame:CGRectZero];
        [lblColor setText:color];
        [lblColor setTextAlignment:NSTextAlignmentCenter];
        [lblColor setFrame:CGRectMake(15, CGRectGetMaxY(lbl.frame) + 5, 290, 20)];
        [lblColor setFont:kStandardFont];
        [v addSubview:lblColor];
        
        NSString *sRed = @"Red";
        NSString *sOrangeYellow = @"Orange/Yellow";
        NSString *sGreen = @"Green";
        NSString *sWhiteTan = @"White/Tan";
        NSString *sBluePurple = @"Blue/Purple";

        
        if([color isEqualToString:sRed])
            [lblColor setTextColor:kColor_Red];
        else if([color isEqualToString:sOrangeYellow])
            [lblColor setTextColor:kColor_OrangeYellow];
        else if([color isEqualToString:sGreen])
            [lblColor setTextColor:kColor_Green];
        else if([color isEqualToString:sWhiteTan])
            [lblColor setTextColor:kColor_WhiteTan];
        else if([color isEqualToString:sBluePurple])
            [lblColor setTextColor:kColor_BluePurple];
        
        trackingLabel = [NSString stringWithFormat:@"Home with color: %@", color];
        
    }
    else
    {
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectZero];
        [lbl setText:@"Start taking pictures of your food and see what colors you've been eating."];
        [lbl setTextAlignment:NSTextAlignmentCenter];
        [lbl setNumberOfLines:2];
        [lbl setLineBreakMode:NSLineBreakByWordWrapping];
        [lbl setFrame:CGRectMake(15, v.frame.size.height - 83, 290, 50)];
        [lbl setFont:kStandardFont];
        [lbl setTextColor:kColor_Text];
        [v addSubview:lbl];
        
        UIImageView *imgViewLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
        [imgViewLogo setFrame:CGRectMake(v.frame.size.width/2 - imgViewLogo.image.size.width/2, lbl.frame.origin.y - 10 - imgViewLogo.image.size.height, imgViewLogo.image.size.width, imgViewLogo.image.size.height)];
        [v addSubview:imgViewLogo];
        
        trackingLabel = [NSString stringWithFormat:@"Home with logo"];

    }
    
    [tab.tabBar addSubview:v];
    
    
    
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"Screen"
                                                                                        action:@"View"
                                                                                         label:trackingLabel
                                                                                         value:nil] build]];

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
    
    UINavigationController *nav = (UINavigationController *)[[tab viewControllers] objectAtIndex:3];
    [nav popToRootViewControllerAnimated:NO];
    TipsTableViewController *tips = (TipsTableViewController *)[nav.viewControllers firstObject];
    
    [tips showAlert:notif.alertBody];
    
    
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"Notification"
                                                                                        action:@"Tip Recieved"
                                                                                         label:notif.alertBody
                                                                                         value:nil] build]];

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
    
    
    
    [self.window.rootViewController dismissViewControllerAnimated:NO completion:^{
        
        NSString *trackingLabel = @"Canceled";
    
        if([info objectForKey:UIImagePickerControllerOriginalImage])
        {
            trackingLabel = @"Picture selected";
            
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
        
        [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"Camera"
                                                                                            action:@"Closed"
                                                                                             label:trackingLabel
                                                                                             value:nil] build]];
        
        
        
    }];
}

#pragma mark ImageViewControllerDelegate methods
-(void)imageViewController:(ImageViewController *)imageViewController savedForEntry:(Entry *)entry
{
    loadingWindow = [Utils showLoadingScreen];
    
    [self.window.rootViewController dismissViewControllerAnimated:YES completion:^{
        [self selectEntries:nil];
        [Utils dismissLoadingWindow:loadingWindow];
    }];
    
    UITabBarController *tab = (UITabBarController *)self.window.rootViewController;
    
    UINavigationController *nav = (UINavigationController *)[tab.viewControllers objectAtIndex:1];
    [nav popToRootViewControllerAnimated:NO];

    EntriesTableViewController *entries = (EntriesTableViewController *)nav.viewControllers.firstObject;
    [entries newEntry:entry];
    [tab setSelectedIndex:1];
}

/*
#pragma mark UIAlertViewDelegate methods
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == alertView.cancelButtonIndex)
    {
        [self.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    
}
 */




-(void)selectColors:(id)sender
{

    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"Tab"
                                                                                        action:@"Tapped"
                                                                                         label:@"Colors"
                                                                                         value:nil] build]];
    
    UITabBarController *tab = (UITabBarController *)self.window.rootViewController;
    
    if(!sender)
        sender = [self.tabBarController.tabBar viewWithTag:998];
    
    UIButton *btn = (UIButton *)sender;
    [btn setImage:[UIImage imageNamed:@"nav-colors-active"] forState:UIControlStateNormal];
    
    UIButton *btnInvite = (UIButton *)[tab.tabBar viewWithTag:997];
    UIButton *btnComments = (UIButton *)[tab.tabBar viewWithTag:995];
    UIButton *btnUsers = (UIButton *)[tab.tabBar viewWithTag:994];
    
    [btnInvite setImage:[UIImage imageNamed:@"nav-entries"] forState:UIControlStateNormal];
    [btnComments setImage:[UIImage imageNamed:@"nav-tips"] forState:UIControlStateNormal];
    [btnUsers setImage:[UIImage imageNamed:@"nav-settings"] forState:UIControlStateNormal];
    
    BOOL value = [self tabBarController:tab shouldSelectViewController:[tab.viewControllers objectAtIndex:0]];
    if(value)
        [tab setSelectedIndex:0];
}

-(void)selectEntries:(id)sender
{
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"Tab"
                                                                                        action:@"Tapped"
                                                                                         label:@"Entries"
                                                                                         value:nil] build]];
    
    
    UITabBarController *tab = (UITabBarController *)self.window.rootViewController;

    if(!sender)
        sender = [self.tabBarController.tabBar viewWithTag:997];
    
    UIButton *btn = (UIButton *)sender;
    [btn setImage:[UIImage imageNamed:@"nav-entries-active"] forState:UIControlStateNormal];
    
    UIButton *btnHome = (UIButton *)[tab.tabBar viewWithTag:998];
    UIButton *btnComments = (UIButton *)[tab.tabBar viewWithTag:995];
    UIButton *btnUsers = (UIButton *)[tab.tabBar viewWithTag:994];
    
    [btnHome setImage:[UIImage imageNamed:@"nav-colors"] forState:UIControlStateNormal];
    [btnComments setImage:[UIImage imageNamed:@"nav-tips"] forState:UIControlStateNormal];
    [btnUsers setImage:[UIImage imageNamed:@"nav-settings"] forState:UIControlStateNormal];

    BOOL value = [self tabBarController:tab shouldSelectViewController:[tab.viewControllers objectAtIndex:1]];
    if(value)
        [tab setSelectedIndex:1];
}

-(void)selectCamera:(id)sender
{
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"Tab"
                                                                                        action:@"Tapped"
                                                                                         label:@"Camera"
                                                                                         value:nil] build]];
    
    
    UITabBarController *tab = (UITabBarController *)self.window.rootViewController;

    UIButton *btnHome = (UIButton *)[tab.tabBar viewWithTag:998];
    UIButton *btnInvite = (UIButton *)[tab.tabBar viewWithTag:997];
    UIButton *btnComments = (UIButton *)[tab.tabBar viewWithTag:995];
    UIButton *btnUsers = (UIButton *)[tab.tabBar viewWithTag:994];
    
    [btnHome setImage:[UIImage imageNamed:@"nav-colors"] forState:UIControlStateNormal];
    [btnInvite setImage:[UIImage imageNamed:@"nav-entries"] forState:UIControlStateNormal];
    [btnComments setImage:[UIImage imageNamed:@"nav-tips"] forState:UIControlStateNormal];
    [btnUsers setImage:[UIImage imageNamed:@"nav-settings"] forState:UIControlStateNormal];
    
    BOOL value = [self tabBarController:tab shouldSelectViewController:[tab.viewControllers objectAtIndex:2]];
}

-(void)selectTips:(id)sender
{
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"Tab"
                                                                                        action:@"Tapped"
                                                                                         label:@"Tips"
                                                                                         value:nil] build]];
    
    
    UITabBarController *tab = (UITabBarController *)self.window.rootViewController;

    if(!sender)
        sender = [self.tabBarController.tabBar viewWithTag:995];
    
    UIButton *btn = (UIButton *)sender;
    [btn setImage:[UIImage imageNamed:@"nav-tips-active"] forState:UIControlStateNormal];
    
    UIButton *btnHome = (UIButton *)[tab.tabBar viewWithTag:998];
    UIButton *btnInvite = (UIButton *)[tab.tabBar viewWithTag:997];
    UIButton *btnUsers = (UIButton *)[tab.tabBar viewWithTag:994];
    
    [btnHome setImage:[UIImage imageNamed:@"nav-colors"] forState:UIControlStateNormal];
    [btnInvite setImage:[UIImage imageNamed:@"nav-entries"] forState:UIControlStateNormal];
    [btnUsers setImage:[UIImage imageNamed:@"nav-settings"] forState:UIControlStateNormal];

    BOOL value = [self tabBarController:tab shouldSelectViewController:[tab.viewControllers objectAtIndex:3]];
    if(value)
        [tab setSelectedIndex:3];
}

-(void)selectSettings:(id)sender
{
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"Tab"
                                                                                        action:@"Tapped"
                                                                                         label:@"Settings"
                                                                                         value:nil] build]];
    
    
    UITabBarController *tab = (UITabBarController *)self.window.rootViewController;

    if(!sender)
        sender = [self.tabBarController.tabBar viewWithTag:994];
    
    UIButton *btn = (UIButton *)sender;
    [btn setImage:[UIImage imageNamed:@"nav-settings-active"] forState:UIControlStateNormal];
    
    UIButton *btnHome = (UIButton *)[tab.tabBar viewWithTag:998];
    UIButton *btnInvite = (UIButton *)[tab.tabBar viewWithTag:997];
    UIButton *btnComments = (UIButton *)[tab.tabBar viewWithTag:995];
    
    [btnHome setImage:[UIImage imageNamed:@"nav-colors"] forState:UIControlStateNormal];
    [btnInvite setImage:[UIImage imageNamed:@"nav-entries"] forState:UIControlStateNormal];
    [btnComments setImage:[UIImage imageNamed:@"nav-tips"] forState:UIControlStateNormal];

    BOOL value = [self tabBarController:tab shouldSelectViewController:[tab.viewControllers objectAtIndex:4]];
    if(value)
        [tab setSelectedIndex:4];
}


@end
