//
//  CTLeftSideMenuViewController.m
//  CitySpade
//
//  Created by Cho-Yeung Lam on 21/1/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import "CTLeftSideMenuViewController.h"
#import "MFSideMenu.h"
#import "CTLoginViewController.h"
#import "RESTfulEngine.h"
#import "Constants.h"
#import "NSString+Encryption.h"

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetUserName:) name:kNotificationLoginSuccess object:nil];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
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
        return 2;
    }
    else if (section == 1) {
        return 2;
    }
    else if (section == 2) {
        return 5;
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
        switch (indexPath.row) {
            case 0:
            {
                cell.imageView.image = [UIImage imageNamed:@"leftside_login"];
                cell.textLabel.text = @"Login";
            }
                break;
            case 1:
            {
                cell.imageView.image = [UIImage imageNamed:@"leftside_mysaves"];
                cell.textLabel.text = @"My Saves";
            }
            default:
                break;
        }
    }
    else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
            {
                cell.imageView.image = [UIImage imageNamed:@"leftside_forsale"];
                cell.textLabel.text = @"For Sale";
            }
                break;
            case 1:
            {
                cell.imageView.image = [UIImage imageNamed:@"leftside_forrent"];
                cell.textLabel.text = @"For Rent";
            }
            default:
                break;
        }
    }
    else if (indexPath.section == 2) {
        switch (indexPath.row) {
            case 0:
            {
                cell.imageView.image = [UIImage imageNamed:@"leftside_blog"];
                cell.textLabel.text = @"Our Blogs";
            }
                break;
            case 1:
            {
                cell.imageView.image = [UIImage imageNamed:@"leftside_about"];
                cell.textLabel.text = @"About";
            }
                break;
            case 2:
            {
                cell.imageView.image = [UIImage imageNamed:@"leftside_support"];
                cell.textLabel.text = @"Support";
            }
                break;
            case 3:
            {
                cell.imageView.image = [UIImage imageNamed:@"leftside_privacy"];
                cell.textLabel.text = @"Privacy";
            }
                break;
            case 4:
            {
                cell.imageView.image = [UIImage imageNamed:@"leftside_termofuse"];
                cell.textLabel.text = @"Term of use";
            }
                break;
                
            default:
                break;
        }
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
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //Login
            
            CTLoginViewController *loginVC = [[CTLoginViewController alloc] initWithNibName:@"CTLoginViewController" bundle:nil];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
            nav.navigationBar.opaque = YES;
            nav.navigationBar.translucent = NO;
            [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar_shadow"] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
            [nav.navigationBar setShadowImage:[UIImage new]];
            [self presentViewController:nav animated:YES completion:nil];
        }
        else if (indexPath.row == 1) {
            //My Saves
        }
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            //For Sale
            [RESTfulEngine loadListingsWithQuery:@{@"rent": @"0"} onSucceeded:^(NSMutableArray *resultArray) {
                //
            } onError:^(NSError *engineError) {
                //
            }];
        }
        else if (indexPath.row == 1) {
            //For Rent
            [RESTfulEngine loadListingsWithQuery:@{@"rent": @"1"} onSucceeded:^(NSMutableArray *resultArray) {
                //
            } onError:^(NSError *engineError) {
                //
            }];
        }
    }
    
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
    [[tableView cellForRowAtIndexPath:indexPath] setBackgroundColor:CellSelectedColor];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[tableView cellForRowAtIndexPath:indexPath] setBackgroundColor:CellNotSelectedColor];
}

#pragma mark - 
#pragma mark - Handle Login Success
- (void)didGetUserName:(NSNotification *)aNotification
{
    UITableViewCell *nameCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    nameCell.textLabel.text = [NSString usernameWithEmail:[aNotification object]];
    nameCell.textLabel.frame = CGRectMake(nameCell.textLabel.frame.origin.x, nameCell.textLabel.frame.origin.y, 200, nameCell.textLabel.frame.size.height);
    nameCell.textLabel.textColor = CellSelectedColor;
}

@end
