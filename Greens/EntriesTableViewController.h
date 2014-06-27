//
//  EntriesTableViewController.h
//  Greens
//
//  Created by Todd Mathison on 6/12/14.
//  Copyright (c) 2014 Todd Mathison. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Entry;

@interface EntriesTableViewController : UITableViewController
{
    NSArray *entries;
    NSMutableArray *entrySections;
}

-(void)newEntry:(Entry *)entry;

@end
