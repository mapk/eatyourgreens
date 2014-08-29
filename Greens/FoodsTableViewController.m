//
//  FoodsTableViewController.m
//  Greens
//
//  Created by Todd Mathison on 6/12/14.
//  Copyright (c) 2014 Todd Mathison. All rights reserved.
//

#import "FoodsTableViewController.h"
#import "Utils.h"
#import "Food.h"
#import "FoodDetailTableViewController.h"
#import "AppDelegate.h"

@interface FoodsTableViewController ()

@end

@implementation FoodsTableViewController

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
        
    [self setTitle:@"Colors"];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    foods = [Food foods];
    
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon-home"] style:UIBarButtonItemStylePlain target:self action:@selector(showHome)];
    [self.navigationItem setRightBarButtonItem:btn];
}

-(void)showHome
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate showHomeScreen];
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
//    [self setTitle:@"Colors"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return foods.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 91;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    static NSString *CellIdentifier = @"Cell";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    
    Food *f = (Food *)[foods objectAtIndex:indexPath.row];
    [cell.textLabel setText:f.title];
    [cell setBackgroundColor:f.backgroundColor];
    [cell.textLabel setTextColor:f.textColor];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    for(int i = 0;i<self.tabBarController.tabBar.subviews.count;i++)
    {
        UIView *v = (UIView *)[self.tabBarController.tabBar.subviews objectAtIndex:i];
        if(v.tag == 999)
            return;
    }
    
    
    
    
//    [self setTitle:@"Back"];

    Food *f = (Food *)[foods objectAtIndex:indexPath.row];
    FoodDetailTableViewController *detail = [[FoodDetailTableViewController alloc] initWithStyle:UITableViewStylePlain];
    [detail setFood:f];
    [self.navigationController pushViewController:detail animated:YES];
    
}

@end
