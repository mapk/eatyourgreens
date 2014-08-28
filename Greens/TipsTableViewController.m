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
    [self setTitle:@"Tips"];
    [self.view setBackgroundColor:kColor_Background];
    [self.tableView setBackgroundColor:self.view.backgroundColor];
    
    [self.tableView setTableHeaderView:[self tableHeader]];
    
    searchArray = [NSMutableArray arrayWithArray:[Tips fetchSavedTips]];
    
//    searchArray = [NSMutableArray arrayWithArray:[Tips data]];
    
    /*
    for(int i = 0;i<array.count;i++)
    {
        Tips *t = (Tips *)[array objectAtIndex:i];
        
        NSDate *now = [NSDate date];
        NSDate *daysAgo = [now dateByAddingTimeInterval:-i*24*60*60];
        
        [t setDate:daysAgo];
    }
    */
    
//    searchArray = [NSMutableArray arrayWithArray:array];
    
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

-(void)showAlert:(NSString *)alertBody;
{
    Tips *t = nil;
    
    if(!searchArray)
        searchArray = [NSMutableArray arrayWithArray:[Tips fetchSavedTips]];

    
    for(Tips *t1 in searchArray)
        if([alertBody isEqualToString:t1.headline])
            t = t1;
    
    if(t)
    {
        TipDetailViewController *detail = [[TipDetailViewController alloc] init];
        [detail setTips:t];
        [self.navigationController pushViewController:detail animated:YES];
    }
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
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    static NSString *CellIdentifier = @"Cell";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    UILabel *lblHeadline, *lblDate;
    UIView *vSide;
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        lblHeadline = [[UILabel alloc] initWithFrame:CGRectMake(15, 25, 260, 20)];
        [lblHeadline setFont:kStandardFont];
        [lblHeadline setTag:999];
        [lblHeadline setBackgroundColor:[UIColor clearColor]];
        [cell.contentView addSubview:lblHeadline];
        
        lblDate = [[UILabel alloc] initWithFrame:CGRectMake(210, 5, 95, 20)];
        [lblDate setTag:998];
        [lblDate setTextAlignment:NSTextAlignmentRight];
        [lblDate setBackgroundColor:[UIColor clearColor]];
        [lblDate setTextColor:[UIColor lightGrayColor]];
        [lblDate setFont:kStandardFont];
        [cell.contentView addSubview:lblDate];
        
        vSide = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 90)];
        [vSide setTag:997];
        [cell.contentView addSubview:vSide];
        
    }
    else
    {
        lblHeadline = (UILabel *)[cell.contentView viewWithTag:999];
        lblDate = (UILabel *)[cell.contentView viewWithTag:998];
        vSide = (UIView *)[cell.contentView viewWithTag:997];
    }
    
    [cell setBackgroundColor:kColor_Background];
    
    
    Tips *t = (Tips *)[searchArray objectAtIndex:indexPath.row];
    [cell.textLabel setText:[NSString stringWithFormat:@"%@\n ", t.colorText]];
    [cell.textLabel setNumberOfLines:2];
    [cell.textLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [cell.textLabel setFont:[UIFont systemFontOfSize:17.0f]];
    [cell.textLabel setBackgroundColor:[UIColor clearColor]];
    
    [lblHeadline setText:t.headline];
    [lblDate setText:[t dateString]];
    
    [cell.detailTextLabel setText:t.message];
    [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
    [cell.detailTextLabel setNumberOfLines:2];
    [cell.detailTextLabel setFont:kStandardFont];
    [cell.detailTextLabel setBackgroundColor:[UIColor clearColor]];

    [vSide setBackgroundColor:t.color];

    
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
