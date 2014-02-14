//
//  CTLeftSideMenuViewController.m
//  CitySpade
//
//  Created by Cho-Yeung Lam on 21/1/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import "CTLeftSideMenuViewController.h"

#define headerColor [UIColor colorWithRed:21.0/255.0 green:21.0/255.0  blue:21.0/255.0  alpha:1]
#define colorOfSeparator [UIColor colorWithRed:21.0/255.0 green:21.0/255.0  blue:21.0/255.0  alpha:1]
#define CellNotSelectedColor [UIColor colorWithRed:35.0/255.0 green:35.0/255.0  blue:35.0/255.0  alpha:1]
#define CellSelectedColor [UIColor colorWithRed:41.0/255.0 green:188.0/255.0 blue:184.0/255.0 alpha:1]
#define textNotSelectedColor [UIColor colorWithRed:177.0/255.0 green:177.0/255.0  blue:177.0/255.0  alpha:1]
#define textSelectedColor [UIColor whiteColor]

@interface CTLeftSideMenuViewController()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIImageView *citySpadeLogo;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation CTLeftSideMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    
    self.view.backgroundColor = CellNotSelectedColor;
    self.citySpadeLogo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 22.0f, self.view.frame.size.width-50.0f, 44.0f)];
    self.citySpadeLogo.contentMode = UIViewContentModeCenter;
    self.citySpadeLogo.image = [UIImage imageNamed:@"leftside_CitySpade"];
    self.citySpadeLogo.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.citySpadeLogo];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 66, self.view.frame.size.width, self.view.frame.size.height-65)];
    self.tableView.backgroundColor = CellNotSelectedColor;
    self.tableView.separatorColor = colorOfSeparator;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark - TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger defaultCount = 0;
    if (section == 0) {
        return 2;
    }
    else if (section == 1) {
        return 2;
    }
    else if (section == 2) {
        return 4;
    }
    else if (section == 3) {
        return 1;
    }
    return defaultCount;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *defaultHeader = nil;
    if (section == 0) {
        return @"Personal";
    }
    else if (section == 1) {
        return @"Search";
    }
    else if (section == 2) {
        return @"Company";
    }
    else if (section == 3) {
        return @"Our Blog";
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
    
    cell.backgroundColor = CellNotSelectedColor;
    cell.textLabel.textColor = textNotSelectedColor;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        cell.imageView.image = [UIImage imageNamed:@"leftside_login"];
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
    return 55.0f*0.5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 55.0f*0.5)];
    head.backgroundColor = headerColor;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 55.0f*0.5)];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:12.5f];

    if (section == 0) label.text = @"Personal";
    else if (section == 1) label.text = @"Search";
    else if (section == 2) label.text = @"Company";
    else if (section == 3) label.text = @"Our Blog";
        
    [head addSubview:label];
    return head;
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
