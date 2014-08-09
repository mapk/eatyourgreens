//
//  Tips.h
//  Greens
//
//  Created by Todd Mathison on 7/19/14.
//  Copyright (c) 2014 Todd Mathison. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tips : NSObject <NSCoding>


@property (nonatomic, strong) NSString *colorText;
@property (nonatomic, strong) NSString *headline;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *food;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) UIColor *color;

-(NSString *)dateString;
-(BOOL)save;

+(void)checkForTip;
+(NSArray *)data;
+(Tips *)tipWithColorText:(NSString *)c withHeadline:(NSString *)h withMessage:(NSString *)m withFood:(NSString *)f withColor:(UIColor *)color;
+(NSArray *)fetchSavedTips;
+(void)clearTips;
@end
