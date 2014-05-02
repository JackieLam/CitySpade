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
#import "CTSavingsViewController.h"
#import "RESTfulEngine.h"
#import "Constants.h"
#import "NSString+Encryption.h"
#import "FacebookDelegate.h"
#import "CTMapViewController.h"
#import "CTMapViewDelegate.h"
#import "REVClusterMap.h"
#import "BlockStates.h"
#import "CTWebViewController.h"

#define headerColor [UIColor colorWithRed:21.0/255.0 green:21.0/255.0  blue:21.0/255.0  alpha:1]
#define colorOfSeparator [UIColor colorWithRed:21.0/255.0 green:21.0/255.0  blue:21.0/255.0  alpha:1]
#define CellNotSelectedColor [UIColor colorWithRed:35.0/255.0 green:35.0/255.0  blue:35.0/255.0  alpha:1]
#define CellSelectedColor [UIColor colorWithRed:41.0/255.0 green:188.0/255.0 blue:184.0/255.0 alpha:1]
#define textNotSelectedColor [UIColor colorWithRed:177.0/255.0 green:177.0/255.0  blue:177.0/255.0  alpha:1]
#define textSelectedColor [UIColor whiteColor]

static NSString *blogUrl = @"http://www.cityspade.com/blog";
static NSString *aboutUrl = @"http://www.cityspade.com/about";
static NSString *supportUrl = @"http://www.cityspade.com/support";
static NSString *privacyUrl = @"http://www.cityspade.com/privacy";
static NSString *termofuseUrl = @"http://www.cityspade.com/terms";

@interface CTLeftSideMenuViewController()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) UIImageView *citySpadeLogo;
@property (nonatomic, strong) UITableView *tableView;


@property (nonatomic, strong) NSArray *sectionTitle;
@property (nonatomic, strong) NSDictionary *rowTitles;
@property (nonatomic, strong) NSArray *numberOfRows;
@property (nonatomic, strong) NSDictionary *thumbImageBaseName;

@end

@implementation CTLeftSideMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    
    self.sectionTitle = @[@"Personal", @"Search", @"Company"];
    self.numberOfRows = @[@2, @2, @5];
    self.rowTitles = @{@0:@[@"Login", @"My Saves"],
                       @1:@[@"For Sale", @"For Rent"],
                       @2:@[@"Our Blogs", @"About", @"Support", @"Privacy", @"Term of use"]};
    self.thumbImageBaseName = @{@0:@[@"leftside_login", @"leftside_mysaves"],
                                @1:@[@"leftside_forsale", @"leftside_forrent"],
                                @2:@[@"leftside_blog", @"leftside_about", @"leftside_support", @"leftside_privacy", @"leftside_termofuse"]};
    
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
    return [self.numberOfRows[section] intValue];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.sectionTitle[section];
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
    
    NSString *theImageName = [self.thumbImageBaseName[[NSNumber numberWithInt:indexPath.section]] objectAtIndex:indexPath.row];
    NSString *grayImageName = [theImageName stringByAppendingString:@"_0"];
    cell.imageView.image = [UIImage imageNamed:grayImageName];
    if (indexPath.section == 0 && indexPath.row == 0) {
        // The Login Text
        if ([[NSUserDefaults standardUserDefaults] objectForKey:kAccessToken]) {
            cell.imageView.image = [UIImage imageNamed:@"leftside_login_2"];
            cell.textLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:kUserName];
            cell.textLabel.textColor = CellSelectedColor;
        }
        else cell.textLabel.text = @"Login";
    }
    else
        cell.textLabel.text = [self.rowTitles[[NSNumber numberWithInt:indexPath.section]] objectAtIndex:indexPath.row];
    
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
    NSString *theImageName = [self.thumbImageBaseName[[NSNumber numberWithInt:indexPath.section]] objectAtIndex:indexPath.row];
    NSString *whiteImageName = [theImageName stringByAppendingString:@"_1"];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:whiteImageName];
    cell.textLabel.textColor = textSelectedColor;
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //Login
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            if (![defaults objectForKey:kAccessToken]) { // Not logged in
                CTLoginViewController *loginVC = [[CTLoginViewController alloc] initWithNibName:@"CTLoginViewController" bundle:nil];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
                nav.navigationBar.opaque = YES;
                nav.navigationBar.translucent = NO;
                [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar_shadow"] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
                [nav.navigationBar setShadowImage:[UIImage new]];
                [self presentViewController:nav animated:YES completion:nil];
                [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
            }
            else {  // Logged in
                NSString *greenLogin = [theImageName stringByAppendingString:@"_2"];
                cell.imageView.image = [UIImage imageNamed:greenLogin];
                cell.textLabel.textColor = CellSelectedColor;
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Log out" message:@"Are you sure to log out?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Confirm", nil];
                alertView.alertViewStyle = UIAlertViewStyleDefault;
                alertView.delegate = self;
                [alertView show];
            }
        }
        else if (indexPath.row == 1) {
            //My Saves
            CTSavingsViewController *savingsVC = [[CTSavingsViewController alloc] init];
            [cell setBackgroundColor:CellSelectedColor];
            
            UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
            [navigationController pushViewController:savingsVC animated:NO];
            [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        }
    }
    else if (indexPath.section == 1) {
        UINavigationController *nav = (UINavigationController *)self.menuContainerViewController.centerViewController;
        CTMapViewController *mapVC = nav.viewControllers[0];
        REVClusterMapView *mapView = mapVC.ctmapView;
        // Set the forRent status of the mapVC's delegate accordingly
        if (indexPath.row == 0) {
            mapVC.title = @"For Sale";
            mapVC.ctmapView.delegate.forRent = NO;
        }
        else if (indexPath.row == 1) {
            mapVC.title = @"For Rent";
            mapVC.ctmapView.delegate.forRent = YES;
        }
        // Remove all annotations
        [mapView removeAnnotations:mapVC.ctmapView.annotations];
        [mapView clearAnnotationsCopy];
        [mapVC.pinsFilterRight removeAllObjects];
        [mapVC.pinsAll removeAllObjects];
        [BlockStates clearOnMapBlocks];
        
        // 这里发送一个信号为了让filterVC里面的rangeSlider改变数值
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationToggleRentSale object:@{@"rent": [NSNumber numberWithBool:indexPath.row]}];
        // 重新设置偏离一下Center Coordinate目的只是为了触发CTMapViewDelegate里面的regionDidChange方法
        [mapView setVisibleMapRect:MKMapRectMake(mapView.visibleMapRect.origin.x, mapView.visibleMapRect.origin.y+1, mapView.visibleMapRect.size.width, mapView.visibleMapRect.size.height)];
        
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        [cell setBackgroundColor:CellSelectedColor];
    }
    else if (indexPath.section == 2) {
        [cell setBackgroundColor:CellSelectedColor];
        NSArray *urlStringArray = [NSArray arrayWithObjects:blogUrl, aboutUrl, supportUrl, privacyUrl, termofuseUrl, nil];
        NSArray *titleArray = [NSArray arrayWithObjects:@"Blog", @"About", @"Support", @"Privacy", @"Term of Use", nil];
        CTWebViewController *webViewController = [[CTWebViewController alloc] init];
        webViewController.urlString = urlStringArray[indexPath.row];
        webViewController.title = titleArray[indexPath.row];
        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        [navigationController pushViewController:webViewController animated:NO];
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *theImageName = [self.thumbImageBaseName[[NSNumber numberWithInt:indexPath.section]] objectAtIndex:indexPath.row];
    NSString *grayImageName = [theImageName stringByAppendingString:@"_0"];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.section == 0 && indexPath.row == 0 && [[NSUserDefaults standardUserDefaults] objectForKey:kAccessToken]) {
        // Skip the changing
    }
    else {
        cell.imageView.image = [UIImage imageNamed:grayImageName];
        cell.textLabel.textColor = textNotSelectedColor;
        [cell setBackgroundColor:CellNotSelectedColor];
    }
}

#pragma mark -
#pragma mark - Handle Login Success

- (void)didGetUserName:(NSNotification *)aNotification
{
    UITableViewCell *nameCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    nameCell.textLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:kUserName];
    nameCell.textLabel.frame = CGRectMake(nameCell.textLabel.frame.origin.x, nameCell.textLabel.frame.origin.y, 200, nameCell.textLabel.frame.size.height);
    nameCell.imageView.image = [UIImage imageNamed:@"leftside_login_2"];
    nameCell.textLabel.textColor = CellSelectedColor;
    nameCell.backgroundColor = CellNotSelectedColor;
}

#pragma mark - 
#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0: { /* Do nothing */ }
            break;
        
        case 1: {
            [RESTfulEngine logoutOnSucceeded:^{
                if (FBSession.activeSession.state == FBSessionStateOpen
                    || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
                    [FBSession.activeSession closeAndClearTokenInformation];
                }
                UITableViewCell *nameCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                nameCell.textLabel.text = @"Login";
                nameCell.textLabel.textColor = textNotSelectedColor;
                nameCell.imageView.image = [UIImage imageNamed:@"leftside_login_0"];
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults removeObjectForKey:kUserName];
                [defaults synchronize];
            } onError:^(NSError *engineError) {
                // TODO: Log out fail
            }];
        }
            break;
            
        default:
            break;
    }
}

@end
