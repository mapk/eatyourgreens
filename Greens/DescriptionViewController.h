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

@interface DescriptionViewController : UIViewController <UITextViewDelegate>
{
    UIPlaceHolderTextView *txtViewDescription;
}

@property (nonatomic, strong) UIViewController *viewController;
@property (nonatomic, strong) Entry *entry;

@end
