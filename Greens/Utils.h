//
//  Utils.h
//  Breakr
//
//  Created by Todd Mathison on 1/13/14.
//  Copyright (c) 2014 Todd Mathison. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Utils : NSObject


+(UIColor *)colorFromRGBHexString:(NSString *)colorString;
+(UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size;
+(UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width;
+(UIImage *)image:(UIImage *)image byScalingAndCroppingForSize:(CGSize)targetSize;
+ (UIImage *) imageWithView:(UIView *)view;
+(NSString *)createGUID;
+(CGSize)sizeForLabel:(UILabel *)label forMaxSize:(CGSize)maxSize;
+(CGSize)sizeForTextView:(UITextView *)label forMaxSize:(CGSize)maxSize;




+(UIImage *)mergeImage:(UIImage *)imageA withImage:(UIImage *)imageB;
@end
