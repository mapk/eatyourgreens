//
//  ImageViewController.h
//  Greens
//
//  Created by Todd Mathison on 6/21/14.
//  Copyright (c) 2014 Todd Mathison. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImageViewControllerDelegate;
@class Entry;

@interface ImageViewController : UIViewController
{
    UIImageView *imgViewCrossHair;
    UIImageView *imgViewTouch;
    NSMutableArray *array;
    
    id <ImageViewControllerDelegate> __unsafe_unretained delegate;
}

@property (nonatomic, strong) Entry *entry;
@property (nonatomic, assign) id <ImageViewControllerDelegate> __unsafe_unretained delegate;

@end


@protocol ImageViewControllerDelegate <NSObject>
-(void)imageViewController:(ImageViewController *)imageViewController savedForEntry:(Entry *)entry;
@end