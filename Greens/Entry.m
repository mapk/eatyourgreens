//
//  Entry.m
//  Greens
//
//  Created by Todd Mathison on 6/22/14.
//  Copyright (c) 2014 Todd Mathison. All rights reserved.
//

#import "Entry.h"
#import "Utils.h"

@implementation ColorCount

@synthesize text, count;

+(ColorCount *)colorCountWithText:(NSString *)t withCount:(NSInteger)c
{
    ColorCount *cc = [[ColorCount alloc] init];
    [cc setText:t];
    [cc setCount:[NSNumber numberWithInteger:c]];
    return cc;
}

@end

@implementation EntryPoint

@synthesize color, point, hue, text;

-(void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:color forKey:@"color"];
    [coder encodeFloat:point.x forKey:@"x"];
    [coder encodeFloat:point.y forKey:@"y"];
    [coder encodeFloat:hue forKey:@"hue"];
    [coder encodeObject:text forKey:@"text"];
}

-(id)initWithCoder:(NSCoder *)coder
{
    if(self = [self init])
    {
        color = [coder decodeObjectForKey:@"color"];
        point.x = [coder decodeFloatForKey:@"x"];
        point.y = [coder decodeFloatForKey:@"y"];
        hue = [coder decodeFloatForKey:@"hue"];
        text = [coder decodeObjectForKey:@"text"];
    }
    
    return self;
}

-(void)setColor:(UIColor *)c
{
    color = c;
    
    CGFloat _hue;
    CGFloat saturation;
    CGFloat brightness;
    CGFloat alpha;
    BOOL success = [color getHue:&_hue saturation:&saturation brightness:&brightness alpha:&alpha];
    
    if(success)
        [self setHue:_hue];
}

/*
-(NSString *)colorText_bak2
{
    NSString *s = @"";
    
    NSString *sRed = @"Red";
    NSString *sOrangeYellow = @"Orange/Yellow";
    NSString *sGreen = @"Green";
    NSString *sWhiteTan = @"White/Tan";
    NSString *sBluePurple = @"Blue/Purple";
    
    long count = CGColorGetNumberOfComponents(self.color.CGColor);
    

    
    CGFloat hue;
    CGFloat saturation;
    CGFloat brightness;
    CGFloat alpha;
    BOOL success = [self.color getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    //    NSLog(@"success: %i hue: %0.2f, saturation: %0.2f, brightness: %0.2f, alpha: %0.2f", success, hue, saturation, brightness, alpha);
    
    
    CGFloat hueValue = hue * 360;
    
    if(hueValue <= 59 && saturation < .1)
        s = sWhiteTan;
    else if(hueValue < 25)
        s = sRed;
    else if(hueValue > 24 && hueValue < 65)
        s = sOrangeYellow;
    else if(hueValue > 64 && hueValue < 155)
        s = sGreen;
    else if(hueValue > 154 && hueValue < 324)
        s = sBluePurple;
    else if(hueValue > 324)
        s = sRed;
    
    return s;
}
*/

-(NSString *)colorText
{
    NSString *s = @"";
    
    NSString *sRed = @"Red";
    NSString *sOrangeYellow = @"Orange/Yellow";
    NSString *sGreen = @"Green";
    NSString *sWhiteTan = @"White/Tan";
    NSString *sBluePurple = @"Blue/Purple";
    
    /*
    long count = CGColorGetNumberOfComponents(self.color.CGColor);
    
    if(count == 4)
    {
        const CGFloat *_components = CGColorGetComponents(self.color.CGColor);
        CGFloat red = _components[0];
        CGFloat green = _components[1];
        CGFloat blue = _components[2];
        CGFloat alpha = _components[3];
        
        red = red * 255;
        green = green * 255;
        blue = blue * 255;
        

        if((red == 255 && green <= 102 && blue == 0)                //Red
           || (red == 255 && green == 0 && blue <= 150))
            s = sRed;
        else if ((red == 255 && green >= 108 && green <= 252 && blue == 0)          //OrangeYellow
                 || (red >= 240 && green == 255 && blue == 0))
            s = sOrangeYellow;
        else if ((red == 234 && green == 255 && blue == 0)          //Green
                 || (red >= 0 && green == 255 && blue <= 144))
            s = sGreen;
        else if ((red == 0 && green == 255 && blue >= 150)          //Blue/Purple
                 || (red == 0 && green <= 255 && blue == 255)
                 || (red >= 0 && red <=252 && green == 0 && blue == 255)
            || (red == 255  && green == 0 && blue <= 252 && blue >= 153))
            s = sBluePurple;
        else if ((red >= 229 && green >= 229 && blue >= 229)          //WhiteTan
                 || (red == green && blue >= red+19)
                 || (red == blue && green >= red+19)
            || (green == blue && red >= blue+19))
            s = sWhiteTan;
        
//        NSLog(@"Red = %f, Green = %f, Blue = %f", red, green, blue);
//        NSLog(@"%@", s);
    }
     */
    
    
    CGFloat _hue;
    CGFloat saturation;
    CGFloat brightness;
    CGFloat alpha;
    [self.color getHue:&_hue saturation:&saturation brightness:&brightness alpha:&alpha];
//    NSLog(@"success: %i hue: %0.2f, saturation: %0.2f, brightness: %0.2f, alpha: %0.2f", success, hue, saturation, brightness, alpha);
    
    
    CGFloat hueValue = _hue * 360;
    
    if(hueValue <= 59 && saturation < .1)
        s = sWhiteTan;
    else if(hueValue < 25)
        s = sRed;
    else if(hueValue > 24 && hueValue < 65)
        s = sOrangeYellow;
    else if(hueValue > 64 && hueValue < 155)
        s = sGreen;
    else if(hueValue > 154 && hueValue < 324)
        s = sBluePurple;
    else if(hueValue > 324)
        s = sRed;
    
    [self setText:s];
    
//    NSLog(@"%@", s);
    
    return s;
}


@end

@implementation Entry

@synthesize image, date, entryPoints, description, imgPath, icon, iconPath;

-(void)encodeWithCoder:(NSCoder *)coder
{
//    [coder encodeObject:image forKey:@"image"];
    [coder encodeObject:date forKey:@"date"];
    [coder encodeObject:entryPoints forKey:@"entryPoints"];
    [coder encodeObject:description forKey:@"description"];
    [coder encodeObject:imgPath forKey:@"imgPath"];
    [coder encodeObject:iconPath forKey:@"iconPath"];
    
}

-(id)initWithCoder:(NSCoder *)coder
{
    if(self = [self init])
    {
//        image = [coder decodeObjectForKey:@"image"];
        date = [coder decodeObjectForKey:@"date"];
        entryPoints = [coder decodeObjectForKey:@"entryPoints"];
        description = [coder decodeObjectForKey:@"description"];
        imgPath = [coder decodeObjectForKey:@"imgPath"];
        iconPath = [coder decodeObjectForKey:@"iconPath"];
        
        if(imgPath)
        {
            NSString *fileName = [NSString stringWithFormat:@"%@/%@.png", DOCUMENTS_FOLDER, imgPath];
            image = [UIImage imageWithContentsOfFile:fileName];
        }
        
        if(iconPath)
        {
            NSString *fileName = [NSString stringWithFormat:@"%@/%@.png", DOCUMENTS_FOLDER, iconPath];
            icon = [UIImage imageWithContentsOfFile:fileName];
        }
    }
    
    return self;
}

-(void)setImage:(UIImage *)img
{
    NSString *file = [Utils createGUID];
    
    NSString *fileName = [NSString stringWithFormat:@"%@/%@.png", DOCUMENTS_FOLDER, file];
    [self setImgPath:file];
    BOOL value = [UIImageJPEGRepresentation(img,.9) writeToFile:fileName atomically:YES];
    
    image = img;
}

-(void)setIcon:(UIImage *)img
{
    NSString *file = [Utils createGUID];

    NSString *fileName = [NSString stringWithFormat:@"%@/%@.png", DOCUMENTS_FOLDER, file];
    [self setIconPath:file];
    BOOL value = [UIImageJPEGRepresentation(img,.9) writeToFile:fileName atomically:YES];
    
    icon = img;
}

-(UIImage *)icon
{
    if(!icon && iconPath)
    {
        NSString *fileName = [NSString stringWithFormat:@"%@/%@.png", DOCUMENTS_FOLDER, iconPath];

        icon = [UIImage imageWithContentsOfFile:fileName];
    }
    
    return icon;
}

-(void)save
{
    NSTimeInterval epoch = [self.date timeIntervalSince1970];
    NSString *fileName = [NSString stringWithFormat:@"/%@.eyg", [[NSNumber numberWithInteger:epoch] stringValue]];
    NSString *filePath = [DOCUMENTS_FOLDER stringByAppendingString:fileName];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error = nil;
    if([fm fileExistsAtPath:filePath])
        [fm removeItemAtPath:filePath error:&error];
    
    [NSKeyedArchiver archiveRootObject:self toFile:filePath];
}

-(void)remove
{
    NSTimeInterval epoch = [self.date timeIntervalSince1970];
    NSString *fileName = [NSString stringWithFormat:@"/%@.eyg", [[NSNumber numberWithInteger:epoch] stringValue]];
    NSString *filePath = [DOCUMENTS_FOLDER stringByAppendingString:fileName];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error = nil;
    if([fm fileExistsAtPath:filePath])
        [fm removeItemAtPath:filePath error:&error];
}

+(NSArray *)fetchFiles
{
    NSMutableArray *array = [[NSMutableArray alloc] init];

    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray *files = [fm contentsOfDirectoryAtPath:DOCUMENTS_FOLDER error:&error];
    
    for(NSString *s in files)
        if([s hasSuffix:@"eyg"])
        {
            Entry *e = (Entry *)[NSKeyedUnarchiver unarchiveObjectWithFile:[DOCUMENTS_FOLDER stringByAppendingFormat:@"/%@", s]];
            [array addObject:e];
        }
    
    return [array sortedArrayUsingComparator:^NSComparisonResult(Entry *e1, Entry *e2){
        return [e2.date compare:e1.date];
    }];

}

-(NSString *)longDate
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateStyle:NSDateFormatterFullStyle];
    [df setTimeStyle:NSDateFormatterNoStyle];
    
    return [df stringFromDate:self.date];
}

-(NSString *)shortTime
{
    NSDateFormatter *tf = [[NSDateFormatter alloc] init];
    [tf setDateStyle:NSDateFormatterNoStyle];
    [tf setTimeStyle:NSDateFormatterShortStyle];

    return [tf stringFromDate:self.date];
}

+(NSString *)averageColor
{
    NSArray *array = [Entry fetchFiles];
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    
    for(Entry *e in array)
        for(EntryPoint *ep in e.entryPoints)
        {
            if(ep.text.length == 0)
                [ep colorText];
            
            [colors addObject:ep.text];
        }
    
    
    NSString *sRed = @"Red";
    NSString *sOrangeYellow = @"Orange/Yellow";
    NSString *sGreen = @"Green";
    NSString *sWhiteTan = @"White/Tan";
    NSString *sBluePurple = @"Blue/Purple";

    NSInteger iRed, iOrange, iGreen, iWhite, iBlue;
    
    iRed = 0;
    iOrange = 0;
    iGreen = 0;
    iWhite = 0;
    iBlue = 0;
    
    NSString *result = @"";
    
    for(NSString *s in colors)
    {
        if([s isEqualToString:sRed])
            iRed++;
        else if([s isEqualToString:sOrangeYellow])
            iOrange++;
        else if([s isEqualToString:sGreen])
            iGreen++;
        else if([s isEqualToString:sWhiteTan])
            iWhite++;
        else if([s isEqualToString:sBluePurple])
            iBlue++;
    }
    
    if(colors.count > 0)
    {
        NSMutableArray *counts = [[NSMutableArray alloc] init];
        [counts addObject:[ColorCount colorCountWithText:sRed withCount:iRed]];
        [counts addObject:[ColorCount colorCountWithText:sOrangeYellow withCount:iOrange]];
        [counts addObject:[ColorCount colorCountWithText:sGreen withCount:iGreen]];
        [counts addObject:[ColorCount colorCountWithText:sWhiteTan withCount:iWhite]];
        [counts addObject:[ColorCount colorCountWithText:sBluePurple withCount:iBlue]];

        NSArray *newArray = [counts sortedArrayUsingComparator:^NSComparisonResult(ColorCount *cc1, ColorCount *cc2) {
            return [cc2.count compare:cc1.count];
        }];
        
        ColorCount *cc = [newArray firstObject];
        result = cc.text;
    }
    
    
    return result;
}

@end
