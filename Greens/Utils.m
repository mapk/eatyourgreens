//
//  Utils.m
//  Breakr
//
//  Created by Todd Mathison on 1/13/14.
//  Copyright (c) 2014 Todd Mathison. All rights reserved.
//

#import "Utils.h"


@implementation Utils


+(UIColor *)colorFromRGBHexString:(NSString *)colorString
{
    if(colorString.length == 6) {
        const char *colorUTF8String = [colorString UTF8String];
        int r, g, b;
        sscanf(colorUTF8String, "%2x%2x%2x", &r, &g, &b);
        return [UIColor colorWithRed:(r / 255.0) green:(g / 255.0) blue:(b / 255.0) alpha:1.0];
    }
    return nil;
}

+ (UIImage *) imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

+(UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size
{
    UIImage *img = nil;
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,color.CGColor);
    CGContextFillRect(context, rect);
    
    img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

+(UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width
{
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    newWidth = roundf(newWidth);
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+(UIImage *)image:(UIImage *)image byScalingAndCroppingForSize:(CGSize)targetSize
{
    UIImage *sourceImage = image;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
        {
            scaleFactor = widthFactor; // scale to fit height
        }
        else
        {
            scaleFactor = heightFactor; // scale to fit width
        }
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
        {
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
        }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil)
    {
        NSLog(@"could not scale image");
    }
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    
    return newImage;
}


+(NSString *)createGUID
{
    CFUUIDRef newUniqueId = CFUUIDCreate(kCFAllocatorDefault);
    NSString * uuidString = (__bridge_transfer NSString*)CFUUIDCreateString(kCFAllocatorDefault, newUniqueId);
    CFRelease(newUniqueId);
    
    return uuidString.lowercaseString;
}

+(CGSize)sizeForLabel:(UILabel *)label forMaxSize:(CGSize)maxSize
{
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setLineBreakMode:label.lineBreakMode];
    [style setAlignment:label.textAlignment];
    
    NSDictionary *attributes = @{NSFontAttributeName:label.font,NSParagraphStyleAttributeName:style};
    
    CGSize size = [label.text boundingRectWithSize:maxSize
                                           options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin
                                        attributes:attributes
                                           context:nil].size;
    
    size.width = ceilf(size.width);
    size.height = ceilf(size.height);
    
    return size;
}

+(CGSize)sizeForTextView:(UITextView *)textView forMaxSize:(CGSize)maxSize
{
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    NSDictionary *attributes = @{NSFontAttributeName:textView.font,NSParagraphStyleAttributeName:style};
    
    CGSize size = [textView.text boundingRectWithSize:maxSize
                                           options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin
                                        attributes:attributes
                                           context:nil].size;
    
    
    NSString *s = textView.text;
    
    while(s.length > 0 && [[s substringFromIndex:textView.text.length-1] isEqualToString:@"\n"])
    {
       size.height = size.height + textView.font.lineHeight;
       s = [s substringWithRange:NSMakeRange(0, s.length - 1)];
    }
    
    size.width = ceilf(size.width);
    size.height = ceilf(size.height);
    
    return size;
}


+(UIImage *)mergeImage:(UIImage *)imageA withImage:(UIImage *)imageB
{
    CGSize size = imageA.size;
    UIGraphicsBeginImageContext(size);
    
    CGPoint thumbPoint = CGPointMake(0,0);
    [imageA drawAtPoint:thumbPoint];
    
    [imageB drawAtPoint:CGPointMake(imageA.size.width/2 - imageB.size.width/2,imageA.size.height/2 - imageB.size.height/2)];
    
    UIImage *imageC = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageC;
}


@end
