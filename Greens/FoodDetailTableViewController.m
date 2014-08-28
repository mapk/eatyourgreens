//
//  FoodDetailTableViewController.m
//  Greens
//
//  Created by Todd Mathison on 6/12/14.
//  Copyright (c) 2014 Todd Mathison. All rights reserved.
//

#import "FoodDetailTableViewController.h"
#import "Food.h"
#import "Utils.h"

@interface FoodDetailTableViewController ()

@end

@implementation FoodDetailTableViewController

@synthesize food;

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

    [self setTitle:@"Food Colors"];
    [self.view setBackgroundColor:kColor_Background];
    [self.tableView setBackgroundColor:self.view.backgroundColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return food.examples.count + 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat value = 50;
    
    if(indexPath.row == 0)
        value = 50;
    else if(indexPath.row == 1)
    {
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectZero];
        [lbl setText:food.description];
        [lbl setFont:[UIFont systemFontOfSize:17.0f]];
        [lbl setLineBreakMode:NSLineBreakByWordWrapping];
        [lbl setNumberOfLines:0];
        
        CGSize size = [Utils sizeForLabel:lbl forMaxSize:CGSizeMake(280, 0)];
        value = size.height;
    }
    else
        value = 44;
    
    return value;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    static NSString *CellIdentifier = @"Cell";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell setBackgroundColor:tableView.backgroundColor];
    
    if(indexPath.row == 0)
    {
        [cell setBackgroundColor:food.backgroundColor];
        [cell.textLabel setTextColor:food.textColor];
        [cell.textLabel setText:food.title];
        [cell.textLabel setFont:[UIFont systemFontOfSize:17.0f]];
    }
    else
    {
        [cell.textLabel setTextColor:[UIColor colorWithRed:80.0f/255.0f green:84.0f/255.0f blue:93.0f/255.0f alpha:1.0f]];
        [cell setBackgroundColor:kColor_Background];

        if(indexPath.row == 1)
        {
            [cell.textLabel setText:food.description];
            [cell.textLabel setNumberOfLines:0];
            [cell.textLabel setFont:kStandardFont];
            [cell.textLabel setLineBreakMode:NSLineBreakByWordWrapping];
        }
        else
        {
            [cell.textLabel setFont:kStandardFont];
            [cell.textLabel setText:(NSString *)[food.examples objectAtIndex:indexPath.row - 2]];
            [cell.textLabel setNumberOfLines:1];
        }

    }
    
    [cell.textLabel setBackgroundColor:[UIColor clearColor]];

    
    
    return cell;
}


@end
