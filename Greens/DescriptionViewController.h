//
//  MenuViewController.h
//  Breakr
//
//  Created by Todd Mathison on 5/12/14.
//  Copyright (c) 2014 Todd Mathison. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPlaceHolderTextView.h"

@class Entry;
@protocol DescriptionViewControllerDelegate;

@interface DescriptionViewController : UIViewController <UITextViewDelegate>
{
    UIPlaceHolderTextView *txtViewDescription;
    UIWindow *loadingWindow;
    id <DescriptionViewControllerDelegate> __unsafe_unretained delegate;
    
    BOOL saved;
}

@property (nonatomic, strong) UIViewController *viewController;
@property (nonatomic, strong) Entry *entry;
@property (nonatomic, assign) id <DescriptionViewControllerDelegate> __unsafe_unretained delegate;

@end


@protocol DescriptionViewControllerDelegate <NSObject>

-(void)descriptionViewControllerCompleted:(DescriptionViewController *)descriptionViewController;

@end
