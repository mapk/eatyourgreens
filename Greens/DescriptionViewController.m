//
//  MenuViewController.m
//  Breakr
//
//  Created by Todd Mathison on 5/12/14.
//  Copyright (c) 2014 Todd Mathison. All rights reserved.
//

#import "DescriptionViewController.h"
#import "AppDelegate.h"
#import "Utils.h"
#import "UIImage+ImageEffects.h"
#import "Entry.h"
#import "Utils.h"

@interface DescriptionViewController ()

@end

@implementation DescriptionViewController

@synthesize viewController, entry, delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    UIView *v = [[UIView alloc] initWithFrame:self.view.frame];
    [v setBackgroundColor:[UIColor clearColor]];
    [v setAlpha:0.0f];
    [v setTag:999];
    [self.view addSubview:v];
    
    UIView *vWhite = [[UIView alloc] initWithFrame:v.bounds];
    [vWhite setBackgroundColor:[UIColor whiteColor]];
    [vWhite setAlpha:.4f];
    [v addSubview:vWhite];
    
    CGFloat startY = 60;
    
    if([UIScreen mainScreen].bounds.size.height > 500)
        startY = 120;
    
    UIBarButtonItem *btnClose = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(close)];
    [self.navigationItem setRightBarButtonItem:btnClose];
    
    UIColor *color = [UIColor colorWithRed:50.0f/255.0f green:50.0f/255.0f blue:50.0f/255.0f alpha:1.0f];
    
    UILabel *lblDate = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, self.view.frame.size.width, 18)];
    [lblDate setFont:kStandardFont];
    [lblDate setTextAlignment:NSTextAlignmentCenter];
    [lblDate setText:[entry longDate]];
    [lblDate setTextColor:color];
    [v addSubview:lblDate];
    
    UILabel *lblTime = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lblDate.frame) + 10, self.view.frame.size.width, 18)];
    [lblTime setFont:kStandardFont];
    [lblTime setTextAlignment:NSTextAlignmentCenter];
    [lblTime setText:[entry shortTime]];
    [lblTime setTextColor:color];
    [v addSubview:lblTime];

    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lblTime.frame) + 5, self.view.frame.size.width, 1)];
    [line setBackgroundColor:color];
    [v addSubview:line];
    
    txtViewDescription = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line.frame) + 5, self.view.frame.size.width, 100)];
    [txtViewDescription setBackgroundColor:[UIColor clearColor]];
    [txtViewDescription setTextColor:color];
    [txtViewDescription setText:entry.description];
    [txtViewDescription setEditable:YES];
    [txtViewDescription setScrollEnabled:YES];
    [txtViewDescription setFont:kStandardFont];
    [txtViewDescription setPlaceholder:@"Record what you ate, or anything else you'd like to note."];
    [v addSubview:txtViewDescription];
    
    [txtViewDescription becomeFirstResponder];
    
    
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"Screen"
                                                                                        action:@"View"
                                                                                         label:@"Notes"
                                                                                         value:nil] build]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    UIView *v = [self.view viewWithTag:999];
    
    [UIView animateWithDuration:.3 animations:^{
        [v setAlpha:1.0];
    } completion:^(BOOL finished){
    
        UIGraphicsBeginImageContext(viewController.view.bounds.size);
        [viewController.view drawViewHierarchyInRect:viewController.view.bounds afterScreenUpdates:NO];
        UIImage *blurImg = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
//        blurImg = [blurImg applyDarkEffect];
        blurImg = [blurImg applyBlurWithRadius:5 tintColor:[UIColor colorWithWhite:1.0f alpha:0.3f] saturationDeltaFactor:1.0f maskImage:nil];
        
        UIImageView *iv = [[UIImageView alloc] initWithImage:blurImg];
        [iv setFrame:CGRectMake(0, 64, blurImg.size.width, blurImg.size.height)];
        [self.view addSubview:iv];
        
        [self.view bringSubviewToFront:v];
        
        [UIView animateWithDuration:0.3 animations:^{
            
        }];
    
    }];
}


-(void)close
{
    loadingWindow = [Utils showLoadingScreen];
    [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(finishClose) userInfo:nil repeats:NO];
}

-(void)finishClose
{
    if(entry.description.length == 0 && txtViewDescription.text.length > 0)
        saved = YES;
    else if(entry.description.length > 0 && txtViewDescription.text.length == 0)
        saved = YES;
    else
        saved = ![entry.description isEqualToString:txtViewDescription.text];
    
    if(saved)
        [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"Notes"
                                                                                            action:@"Closed"
                                                                                             label:@"Changes Saved"
                                                                                             value:nil] build]];
    else
        [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"Notes"
                                                                                            action:@"Closed"
                                                                                             label:@"No Changes"
                                                                                             value:nil] build]];

    
    
    [entry setDescription:txtViewDescription.text];
    [entry save];
    
    UIView *v = [self.view viewWithTag:999];
    
    [UIView animateWithDuration:.3 animations:^{
        [v setAlpha:0];
    } completion:^(BOOL finished){
        
        [self dismissViewControllerAnimated:NO completion:^{
           
            [Utils dismissLoadingWindow:loadingWindow];
            
            if(saved && delegate && [delegate respondsToSelector:@selector(descriptionViewControllerCompleted:)])
                [delegate descriptionViewControllerCompleted:self];
                        
        }];
    }];

    
}







@end
