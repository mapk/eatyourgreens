//
//  Entry.m
//  Greens
//
//  Created by Todd Mathison on 6/22/14.
//  Copyright (c) 2014 Todd Mathison. All rights reserved.
//

#import "Entry.h"

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

@end

@implementation Entry

@synthesize image, date, entryPoints, description;

-(void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:image forKey:@"image"];
    [coder encodeObject:date forKey:@"date"];
    [coder encodeObject:entryPoints forKey:@"entryPoints"];
    [coder encodeObject:description forKey:@"description"];
}

-(id)initWithCoder:(NSCoder *)coder
{
    if(self = [self init])
    {
        image = [coder decodeObjectForKey:@"image"];
        date = [coder decodeObjectForKey:@"date"];
        entryPoints = [coder decodeObjectForKey:@"entryPoints"];
        description = [coder decodeObjectForKey:@"description"];
    }
    
    return self;
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
        return [e1.date compare:e2.date];
    }];

}


@end
