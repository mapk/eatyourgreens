//
//  Entry.h
//  Greens
//
//  Created by Todd Mathison on 6/22/14.
//  Copyright (c) 2014 Todd Mathison. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EntryPoint : NSObject <NSCoding>

@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) CGPoint point;

@end

@interface Entry : NSObject <NSCoding>

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSArray *entryPoints;
@property (nonatomic, strong) NSString *description;

-(void)save;
-(void)remove;
+(NSArray *)fetchFiles;


@end
