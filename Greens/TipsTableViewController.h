//
//  TipsTableViewController.h
//  Greens
//
//  Created by Todd Mathison on 6/12/14.
//  Copyright (c) 2014 Todd Mathison. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TipsTableViewController : UITableViewController <UISearchBarDelegate>
{
    NSMutableArray *array;
    NSMutableArray *searchArray;
}

@end
