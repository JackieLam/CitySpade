//
//  CTLeftSideMenuViewController.m
//  CitySpade
//
//  Created by Cho-Yeung Lam on 21/1/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import "CTLeftSideMenuViewController.h"

#define CellNotSelectedColor [UIColor colorWithRed:100.0/255.0 green:100.0/255.0  blue:100.0/255.0  alpha:1]
#define CellSelectedColor [UIColor colorWithRed:31.0/255.0 green:177.0/255.0 blue:170.0/255.0 alpha:1]

@implementation CTLeftSideMenuViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor colorWithRed:100.0/255.0 green:100.0/255.0  blue:100.0/255.0  alpha:1];
    self.tableView.separatorColor = [UIColor blackColor];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

#pragma mark - TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger defaultCount = 0;
    if (section == 0) {
        return 1;
    }
    else if (section == 1) {
        return 3;
    }
    else if (section == 2) {
        return 4;
    }
    return defaultCount;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *defaultView = nil;
    if (section == 0) {
        UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cityspade"]];
        logoImageView.contentMode = UIViewContentModeScaleAspectFit;
        return logoImageView;
    }
    return defaultView;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *defaultHeader = nil;
    if (section == 1) {
        return @"Search";
    }
    else if (section == 2) {
        return @"More";
    }
        
    return defaultHeader;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    cell.backgroundColor = [UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:1];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        //if login and if not
        cell.textLabel.text = @"Login";
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == 0) cell.textLabel.text = @"For Sale";
        else if (indexPath.row == 1) cell.textLabel.text = @"For Rent";
        else if (indexPath.row == 2) cell.textLabel.text = @"My Saves";
    }
    else if (indexPath.section == 2) {
        if (indexPath.row == 0) cell.textLabel.text = @"Leave Feedback";
        else if (indexPath.row == 1) cell.textLabel.text = @"Rate this App";
        else if (indexPath.row == 2) cell.textLabel.text = @"Share this App";
        else if (indexPath.row == 3) cell.textLabel.text = @"Settings";
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 44;
    }
    return 18;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[tableView cellForRowAtIndexPath:indexPath] setBackgroundColor:CellSelectedColor];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[tableView cellForRowAtIndexPath:indexPath] setBackgroundColor:CellNotSelectedColor];
}

@end
