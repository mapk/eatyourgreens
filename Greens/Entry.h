//
//  Entry.h
//  Greens
//
//  Created by Todd Mathison on 6/22/14.
//  Copyright (c) 2014 Todd Mathison. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ColorCount : NSObject

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSNumber *count;

+(ColorCount *)colorCountWithText:(NSString *)t withCount:(NSInteger)c;

@end

@interface EntryPoint : NSObject <NSCoding>

@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) CGPoint point;
@property (nonatomic, assign) CGFloat hue;
@property (nonatomic, strong) NSString *text;

-(NSString *)colorText;

@end

@interface Entry : NSObject <NSCoding>

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSArray *entryPoints;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *imgPath;
@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, strong) NSString *iconPath;


-(void)save;
-(void)remove;
+(NSArray *)fetchFiles;

-(NSString *)longDate;
-(NSString *)shortTime;
+(NSString *)averageColor;
//-(NSString *)colorText;
@end
