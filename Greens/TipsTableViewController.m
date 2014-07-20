//
//  TipsTableViewController.m
//  Greens
//
//  Created by Todd Mathison on 6/12/14.
//  Copyright (c) 2014 Todd Mathison. All rights reserved.
//

#import "TipsTableViewController.h"
#import "Tips.h"
#import "TipDetailViewController.h"

@interface TipsTableViewController ()

@end

@implementation TipsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self setTitle:@"Tips & Reminders"];
    
    [self.tableView setTableHeaderView:[self tableHeader]];
    
    array = [NSMutableArray arrayWithArray:[Tips fetchSavedTips]];
    
    for(int i = 0;i<array.count;i++)
    {
        Tips *t = (Tips *)[array objectAtIndex:i];
        
        NSDate *now = [NSDate date];
        NSDate *daysAgo = [now dateByAddingTimeInterval:-i*24*60*60];
        
        [t setDate:daysAgo];
    }
    
    searchArray = [NSMutableArray arrayWithArray:array];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

-(UIView *)tableHeader
{
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 40)];
    [searchBar setPlaceholder:@"Search"];
    [searchBar setDelegate:self];
    return searchBar;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return searchArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    static NSString *CellIdentifier = @"Cell";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    UILabel *lblHeadline, *lblDate;
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        lblHeadline = [[UILabel alloc] initWithFrame:CGRectMake(15, 25, 260, 20)];
        [lblHeadline setFont:[UIFont systemFontOfSize:14.0f]];
        [lblHeadline setTag:999];
        [lblHeadline setBackgroundColor:[UIColor clearColor]];
        [cell.contentView addSubview:lblHeadline];
        
        lblDate = [[UILabel alloc] initWithFrame:CGRectMake(220, 5, 95, 20)];
        [lblDate setTag:998];
        [lblDate setTextAlignment:NSTextAlignmentRight];
        [lblDate setBackgroundColor:[UIColor clearColor]];
        [lblDate setTextColor:[UIColor lightGrayColor]];
        [lblDate setFont:[UIFont systemFontOfSize:14.0f]];
        [cell.contentView addSubview:lblDate];
        
    }
    else
    {
        lblHeadline = (UILabel *)[cell.contentView viewWithTag:999];
        lblDate = (UILabel *)[cell.contentView viewWithTag:998];
    }
    
    Tips *t = (Tips *)[searchArray objectAtIndex:indexPath.row];
    [cell.textLabel setText:[NSString stringWithFormat:@"%@\n ", t.color]];
    [cell.textLabel setNumberOfLines:2];
    [cell.textLabel setLineBreakMode:NSLineBreakByWordWrapping];
    
    [lblHeadline setText:t.headline];
    [lblDate setText:[t dateString]];
    
    [cell.detailTextLabel setText:t.message];
    [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
    [cell.detailTextLabel setNumberOfLines:2];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Tips *t = (Tips *)[searchArray objectAtIndex:indexPath.row];
    
    TipDetailViewController *detail = [[TipDetailViewController alloc] init];
    [detail setTips:t];
    [self.navigationController pushViewController:detail animated:YES];
    
}

#pragma mark UISearchBarDelegate methods
-(BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *s = [searchBar.text stringByReplacingCharactersInRange:range withString:text];
    s = [s stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if(s.length == 0)
    {
        searchArray = [NSMutableArray arrayWithArray:array];
    }
    else
    {
        [searchArray removeAllObjects];
        
        for(int i = 0;i<array.count;i++)
        {
            Tips *t = (Tips *)[array objectAtIndex:i];
            
            NSString *string = [NSString stringWithFormat:@"%@%@%@%@", t.color, t.message, t.message, t.headline];
            if([string.lowercaseString rangeOfString:s.lowercaseString].length > 0)
                [searchArray addObject:t];
        }
    }
    
    [self.tableView reloadData];
    
    return YES;
}

@end
