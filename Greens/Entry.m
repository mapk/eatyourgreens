//
//  Entry.m
//  Greens
//
//  Created by Todd Mathison on 6/22/14.
//  Copyright (c) 2014 Todd Mathison. All rights reserved.
//

#import "Entry.h"
#import "Utils.h"

@implementation EntryPoint

@synthesize color, point;

-(void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:color forKey:@"color"];
    [coder encodeFloat:point.x forKey:@"x"];
    [coder encodeFloat:point.y forKey:@"y"];
}

-(id)initWithCoder:(NSCoder *)coder
{
    if(self = [self init])
    {
        color = [coder decodeObjectForKey:@"color"];
        point.x = [coder decodeFloatForKey:@"x"];
        point.y = [coder decodeFloatForKey:@"y"];
    }
    
    return self;
}

-(NSString *)colorText
{
    NSString *s = @"";
    
    NSString *sRed = @"Red";
    NSString *sOrangeYellow = @"Orange/Yellow";
    NSString *sGreen = @"Green";
    NSString *sWhiteTan = @"White/Tan";
    NSString *sBluePurple = @"Blue/Purple";
    
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
            image = [UIImage imageWithContentsOfFile:imgPath];
        
        if(iconPath)
            icon = [UIImage imageWithContentsOfFile:iconPath];
    }
    
    return self;
}

-(void)setImage:(UIImage *)img
{
    NSString *fileName = [NSString stringWithFormat:@"%@/%@.png", DOCUMENTS_FOLDER, [Utils createGUID]];
    [self setImgPath:fileName];
    [UIImageJPEGRepresentation(img,.9) writeToFile:fileName atomically:YES];
    
    image = img;
}

-(void)setIcon:(UIImage *)img
{
    NSString *fileName = [NSString stringWithFormat:@"%@/%@.png", DOCUMENTS_FOLDER, [Utils createGUID]];
    [self setIconPath:fileName];
    [UIImageJPEGRepresentation(img,.9) writeToFile:fileName atomically:YES];
    
    icon = img;
}

-(UIImage *)icon
{
    if(!icon && iconPath)
        icon = [UIImage imageWithContentsOfFile:iconPath];
    
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


@end
