//
//  EntriesTableViewController.m
//  Greens
//
//  Created by Todd Mathison on 6/12/14.
//  Copyright (c) 2014 Todd Mathison. All rights reserved.
//

#import "EntriesTableViewController.h"
#import "EntryViewController.h"
#import "Entry.h"
#import "Utils.h"
#import "AppDelegate.h"

@interface EntriesTableViewController ()

@end

@implementation EntriesTableViewController

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

    [self setTitle:@"Entries"];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view setBackgroundColor:kColor_Background];
    [self.tableView setBackgroundColor:self.view.backgroundColor];

    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon-home"] style:UIBarButtonItemStylePlain target:self action:@selector(showHome)];
    [self.navigationItem setRightBarButtonItem:btn];
    
    
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"Screen"
                                                                                        action:@"View"
                                                                                         label:@"Entries"
                                                                                         value:nil] build]];

}

-(void)showHome
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate showHomeScreenForColor:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];    
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];


    entrySections = [[NSMutableArray alloc] init];
    entries = [Entry fetchFiles];
    
    NSDate *oldDate = nil;
    
    NSMutableArray *current = [[NSMutableArray alloc] init];
    
    for(int i = 0;i<entries.count;i++)
    {
        Entry *entry = (Entry *)[entries objectAtIndex:i];
        
        if(!oldDate)
        {
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSInteger comps = (NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit);
            
            NSDateComponents *date1Components = [calendar components:comps fromDate:entry.date];

            oldDate = [calendar dateFromComponents:date1Components];
            [current addObject:entry];
            if(entries.count == 1)
                [entrySections addObject:[NSMutableArray arrayWithArray:current]];
        }
        else
        {
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSInteger comps = (NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit);
            
            NSDateComponents *date1Components = [calendar components:comps fromDate:entry.date];
            NSDateComponents *date2Components = [calendar components:comps fromDate:oldDate];
            
            if ([[calendar dateFromComponents:date1Components] compare:[calendar dateFromComponents:date2Components]] == NSOrderedSame)
                [current addObject:entry];
            else
            {
                [entrySections addObject:[NSMutableArray arrayWithArray:current]];
                oldDate = entry.date;
                [current removeAllObjects];
                [current addObject:entry];
            }
            
            if(i == entries.count -1)
                [entrySections addObject:[NSMutableArray arrayWithArray:current]];
        }
    }
    
    [self.tableView reloadData];

}


-(void)newEntry:(Entry *)entry
{
    NSMutableArray *dayEntries = [[NSMutableArray alloc] init];

    for(int i = 0;i<entrySections.count;i++)
    {
        NSArray *array = (NSArray *)[entrySections objectAtIndex:i];
        
        for(int j = 0;j<array.count;j++)
        {
            Entry *e = (Entry *)[array objectAtIndex:j];
            
            NSDateComponents *dc = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:e.date];
            NSDateComponents *dc1 = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:entry.date];
            
            if(dc1.day == dc.day && dc1.month == dc.month && dc1.year == dc.year)
                [dayEntries addObject:e];
        }
    }
    
    EntryViewController *entryViewController = [[EntryViewController alloc] init];
    [entryViewController setEntry:entry];
    
    if(dayEntries.count > 0)
    {
        [dayEntries insertObject:entry atIndex:0];
        [entryViewController setEntries:dayEntries];
    }
    
    [entryViewController setIsNew:YES];
    [self.navigationController pushViewController:entryViewController animated:YES];
     
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return entrySections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = (NSArray *)[entrySections objectAtIndex:section];
    
    return array.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setTimeStyle:NSDateFormatterNoStyle];
    [df setDateStyle:NSDateFormatterMediumStyle];
    
    NSArray *array = (NSArray *)[entrySections objectAtIndex:section];
    Entry *entry = (Entry *)[array firstObject];
    
    return (NSString *)[df stringFromDate:entry.date];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    static NSString *CellIdentifier = @"Cell";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    else
        for(UIView *v in cell.contentView.subviews)
            if(v.tag == 999)
                [v removeFromSuperview];
    
    [cell setBackgroundColor:tableView.backgroundColor];
    
    NSArray *array = (NSArray *)[entrySections objectAtIndex:indexPath.section];
    Entry *entry = (Entry *)[array objectAtIndex:indexPath.row];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateStyle:NSDateFormatterNoStyle];
    [df setTimeStyle:NSDateFormatterShortStyle];
    
    [cell.detailTextLabel setText:[df stringFromDate:entry.date]];
    
    UIImage *img = [Utils imageWithColor:[UIColor clearColor] andSize:CGSizeMake(40, 40)];
    [cell.imageView setImage:img];
    
    UIImageView *iv = [[UIImageView alloc] initWithImage:entry.icon];
    [iv setFrame:CGRectMake(10, 5, 40, 40)];
    [iv setTag:999];
    [cell.contentView addSubview:iv];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSArray *array = (NSArray *)[entrySections objectAtIndex:indexPath.section];
    Entry *entry = (Entry *)[array objectAtIndex:indexPath.row];

    EntryViewController *entryViewController = [[EntryViewController alloc] init];
    [entryViewController setEntry:entry];
    [entryViewController setEntries:array];
    [entryViewController setIndex:indexPath.row];
    [self.navigationController pushViewController:entryViewController animated:YES];
}


-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *array = (NSMutableArray *)[entrySections objectAtIndex:indexPath.section];
    Entry *entry = (Entry *)[array objectAtIndex:indexPath.row];
    [entry remove];
    [array removeObjectAtIndex:indexPath.row];
    
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    if(array.count == 0)
    {
        [entrySections removeObjectAtIndex:indexPath.section];
        [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

@end
