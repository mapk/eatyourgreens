//
//  ImageViewController.m
//  Greens
//
//  Created by Todd Mathison on 6/21/14.
//  Copyright (c) 2014 Todd Mathison. All rights reserved.
//

#import "ImageViewController.h"
#import "UIView+ColorOfPoint.h"
#import "Entry.h"
#import "Tips.h"

@interface ImageViewController ()

@end

@implementation ImageViewController

@synthesize entry, delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    array = [[NSMutableArray alloc] init];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:entry.image];
    [imageView setUserInteractionEnabled:YES];
    [imageView setFrame:self.view.frame];
    [self setView:imageView];
    
    UIImage *imgSave = [UIImage imageNamed:@"btn-save-photo"];
    UIButton *btnSave = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnSave setImage:imgSave forState:UIControlStateNormal];
    [btnSave setFrame:CGRectMake(self.view.frame.size.width/2 - imgSave.size.width/2, self.view.frame.size.height - imgSave.size.height - 20, imgSave.size.width, imgSave.size.height)];
    [btnSave addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnSave];

    UIImage *imgCancel = [UIImage imageNamed:@"btn-cancel"];
    UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnCancel setImage:imgCancel forState:UIControlStateNormal];
    [btnCancel setFrame:CGRectMake(20, self.view.frame.size.height - imgSave.size.height - 20, imgSave.size.width, imgSave.size.height)];
    [btnCancel addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnCancel];

    UIImage *imgCrosshair = [UIImage imageNamed:@"btn-crosshair-new"];
    imgViewCrossHair = [[UIImageView alloc] initWithImage:imgCrosshair];
    [imgViewCrossHair setFrame:CGRectMake(self.view.frame.size.width - imgCrosshair.size.width - 10, 25, imgCrosshair.size.width, imgCrosshair.size.height)];
    [self.view addSubview:imgViewCrossHair];
    
    if(entry.entryPoints.count > 0)
        for(int i = 0;i<entry.entryPoints.count;i++)
        {
            EntryPoint *ep = (EntryPoint *)[entry.entryPoints objectAtIndex:i];
            
            UIImage *imgTouch = [UIImage imageNamed:@"touch-crosshair"];
            UIImageView *iv = [[UIImageView alloc] initWithImage:imgTouch];
            [iv setFrame:CGRectMake(0, 0, imgTouch.size.width, imgTouch.size.height)];
            [iv setCenter:ep.point];
            [self.view addSubview:iv];
            [self.view bringSubviewToFront:imgViewTouch];
            [array addObject:iv];
        }

    
//    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
//    [self.view addGestureRecognizer:longPressGesture];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)save
{

    if(array.count == 0)
    {
        [[[UIAlertView alloc] initWithTitle:nil message:@"Drag the crosshair icon to a color you'd like to select.  Do this as many times as you'd like." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    
    NSMutableArray *entryPoints = [[NSMutableArray alloc] init];
    
    for(UIImageView *imageView in array)
    {
        EntryPoint *ep = [[EntryPoint alloc] init];
        [ep setColor:[self.view colorOfPoint:imageView.center]];
        [ep setPoint:imageView.center];
        [entryPoints addObject:ep];
    }
    
    [entry setEntryPoints:entryPoints];
    [entry save];
    
    [Tips checkForTip];
    
/*
    NSMutableString *s = [[NSMutableString alloc] initWithString:@""];
    
    for(EntryPoint *ep in entryPoints)
        [s appendFormat:@"\n%@", [ep colorText]];
    
    [[[UIAlertView alloc] initWithTitle:nil message:s delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
*/    
    
    if(delegate && [delegate respondsToSelector:@selector(imageViewController:savedForEntry:)])
        [delegate imageViewController:self savedForEntry:entry];
}


-(void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint viewPoint = [imgViewCrossHair convertPoint:[[touches anyObject] locationInView:self.view] fromView:self.view];
    
    if ([imgViewCrossHair pointInside:viewPoint withEvent:event])
    {
        UIImage *imgTouch = [UIImage imageNamed:@"touch-crosshair"];
        imgViewTouch = [[UIImageView alloc] initWithImage:imgTouch];
        [imgViewTouch setFrame:CGRectMake(imgViewCrossHair.frame.origin.x, imgViewCrossHair.frame.origin.y, imgTouch.size.width, imgTouch.size.height)];
        [self.view addSubview:imgViewTouch];
        [self.view bringSubviewToFront:imgViewTouch];
        
        

        if(loop == nil){
            loop = [[MagnifierView alloc] init];
            loop.viewToMagnify = self.view;
            
            [self.view.superview addSubview:loop];
            
        }
        
        loop.touchPoint = viewPoint;
        [loop setNeedsDisplay];
        
        
    }
    else
    {
        for(int i = 0;i<array.count;i++)
        {
            UIImageView *iv = (UIImageView *)[array objectAtIndex:i];
            CGPoint viewPoint = [iv convertPoint:[[touches anyObject] locationInView:self.view] fromView:self.view];
            
            if([iv pointInside:viewPoint withEvent:event])
            {
                [array removeObjectAtIndex:i];
                imgViewTouch = iv;
                break;
            }
        }
    }
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(imgViewTouch)
        for(UITouch *touch in touches)
        {
            [imgViewTouch setCenter:[touch locationInView:self.view]];
            
            [self handleGestureAction:[touch locationInView:self.view]];
            
        }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UIImage *imgTouch = [UIImage imageNamed:@"touch-crosshair"];
    UIImageView *imgViewNewTouch = [[UIImageView alloc] initWithImage:imgTouch];
    [imgViewTouch setFrame:CGRectMake(0, 0, imgTouch.size.width, imgTouch.size.height)];
    
    if(imgViewTouch)
    {
        UITouch *touch = [touches anyObject];
        [imgViewNewTouch setCenter:[touch locationInView:self.view]];
        [self.view addSubview:imgViewNewTouch];
        
        [array addObject:imgViewNewTouch];
        [imgViewTouch removeFromSuperview];
        imgViewTouch = nil;
        
        [loop removeFromSuperview];
        loop=nil;
        
    }
}



/*
-(void)handleGesture:(UILongPressGestureRecognizer *)longPressGesture
{
    
    CGPoint location = [longPressGesture locationInView:self.view];
    
    switch (longPressGesture.state) {
        case UIGestureRecognizerStateBegan:
            
            
//            touchTimer = [NSTimer scheduledTimerWithTimeInterval:0.5
//                                                               target:self
//                                                             selector:@selector(addLoop)
//                                                             userInfo:nil
//                                                              repeats:NO];
            
            
            // just create one loop and re-use it.
            if(loop == nil){
                loop = [[MagnifierView alloc] init];
                loop.viewToMagnify = self.view;
                
                [self.view.superview addSubview:loop];

            }
            
            loop.touchPoint = location;
            [loop setNeedsDisplay];
            break;
            
        case UIGestureRecognizerStateChanged:
            [self handleGestureAction:location];
            break;
            
        case UIGestureRecognizerStateEnded:
//            [touchTimer invalidate];
//            touchTimer = nil;
            
            [loop removeFromSuperview];
            loop=nil;
            break;
            
        default:
            break;
    }
}

- (void)addLoop {
    // add the loop to the superview.  if we add it to the view it magnifies, it'll magnify itself!
    [self.view.superview addSubview:loop];
}
*/ 

-(void) handleGestureAction:(CGPoint)location
{
    loop.touchPoint = location;
    [loop setNeedsDisplay];
    
}


@end
