//
//  SettingsTableViewController.m
//  Greens
//
//  Created by Todd Mathison on 6/12/14.
//  Copyright (c) 2014 Todd Mathison. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "Food.h"


@interface SettingsTableViewController ()

@end

@implementation SettingsTableViewController

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

    foods = [Food foods];
    selected =  [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"selectedFoods"]];
    
    if(!selected)
    {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        for(int i = 0;i<foods.count;i++)
        {
            Food *f = (Food *)[foods objectAtIndex:i];
            for(int j = 0;j<f.examples.count;j++)
                [dict setObject:[NSNumber numberWithBool:NO] forKey:(NSString *)[f.examples objectAtIndex:j]];
        }
        
        selected = (NSMutableDictionary *)dict;
        [[NSUserDefaults standardUserDefaults] setObject:[NSDictionary dictionaryWithDictionary:selected] forKey:@"selectedFoods"];
        
    }
    
    
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.tableView setTableHeaderView:[self headerView]];
    
    [self setTitle:@"Settings"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

-(UIView *)headerView
{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 90)];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(36, 10, self.tableView.frame.size.width - 72, 70)];
    [lbl setText:@"Select the foods you might be allergic to, or any foods you don't like.  We won't send you notifications concerning those specific foods."];
    [lbl setFont:kStandardFont];
    [lbl setBackgroundColor:[UIColor clearColor]];
    [lbl setNumberOfLines:0];
    [lbl setLineBreakMode:NSLineBreakByWordWrapping];
    [v addSubview:lbl];
    
    return v;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return foods.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    Food *f = (Food *)[foods objectAtIndex:section];
    
    return f.examples.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
    
    Food *f = (Food *)[foods objectAtIndex:section];

    [v setBackgroundColor:f.backgroundColor];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, v.frame.size.width - 20, 30)];
    [lbl setBackgroundColor:[UIColor clearColor]];
    [lbl setFont:kStandardFont];
    [lbl setText:f.title];
    [lbl setTextColor:f.textColor];
    [v addSubview:lbl];
    
    return v;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    static NSString *CellIdentifier = @"Cell";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }

    [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
    
    Food *f = (Food *)[foods objectAtIndex:indexPath.section];
    NSString *s = (NSString *)[f.examples objectAtIndex:indexPath.row];
    
    [cell.textLabel setText:s];
    [cell.textLabel setFont:kStandardFont];
    
    NSNumber *n = (NSNumber *)[selected objectForKey:s];
    
    if([n boolValue])
    {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        [cell.textLabel setTextColor:[UIColor lightGrayColor]];
    }
    else
    {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [cell.textLabel setTextColor:[UIColor blackColor]];
    }
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *s = cell.textLabel.text;
    
    NSNumber *n = nil;
    
    if(cell.accessoryType == UITableViewCellAccessoryNone)
        n = [NSNumber numberWithBool:YES];
    else
        n = [NSNumber numberWithBool:NO];
    
    [selected removeObjectForKey:s];
    [selected setObject:n forKey:s];
    [[NSUserDefaults standardUserDefaults] setObject:[NSDictionary dictionaryWithDictionary:selected] forKey:@"selectedFoods"];
    
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
