//
//  MagnifierView.m
//  SimplerMaskTest
//

#import "MagnifierView.h"
#import <QuartzCore/QuartzCore.h>
#import "Utils.h"

@implementation MagnifierView
@synthesize viewToMagnify;
@dynamic touchPoint;

- (id)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame radius:118];
}

- (id)initWithFrame:(CGRect)frame radius:(int)r {
    int radius = r;
    
    if ((self = [super initWithFrame:CGRectMake(0, 0, radius, radius)])) {
        //Make the layer circular.
        self.layer.cornerRadius = radius / 2;
        self.layer.masksToBounds = YES;
    }
    
    return self;
}

-(void)setTouchPoint:(CGPoint)pt
{
    touchPoint = pt;
    // whenever touchPoint is set, update the position of the magnifier (to just above what's being magnified)
    self.center = CGPointMake(pt.x, pt.y-66);
}


-(CGPoint)getTouchPoint
{
    return touchPoint;
}


-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();

//    CGImageRef imgRef = CGBitmapContextCreateImage(context);
//    UIImage *image = [UIImage imageWithCGImage:imgRef];
//    image = [Utils imageWithImage:image scaledToWidth:image.size.width*2];
    
    
    CGRect bounds = self.bounds;
    
    CGImageRef mask = [UIImage imageNamed: @"loupe-mask@2x.png"].CGImage;
//    UIImage *glass = nil;   //[UIImage imageNamed: @"loupe-hi@2x.png"];
    
    CGContextSaveGState(context);
    CGContextClipToMask(context, bounds, mask);
    CGContextFillRect(context, bounds);
    CGContextScaleCTM(context, 1.0, 1.0);
    
    //draw your subject view here
    CGContextTranslateCTM(context,1*(self.frame.size.width*0.5),1*(self.frame.size.height*0.5));
    CGContextTranslateCTM(context,-1*(touchPoint.x),-1*(touchPoint.y));
    
    [self.viewToMagnify.layer renderInContext:context];
    
    CGContextRestoreGState(context);
//    [glass drawInRect: bounds];
}

- (void)dealloc {
//    [viewToMagnify release];
//    [super dealloc];
}




@end