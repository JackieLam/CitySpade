//
//  CTMapViewController.m
//  CitySpade
//
//  Created by Cho-Yeung Lam on 20/1/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import "CTMapViewController.h"
#import "CTListViewController.h"
#import "MFSideMenu.h"
#import <GoogleMaps/GoogleMaps.h>

@interface CTMapViewController() <GMSMapViewDelegate>

@end

@implementation CTMapViewController {
    GMSMapView *mapView;
}

- (id)init
{
    self = [super init];
    if (self) {
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86 longitude:151.20 zoom:6];
        mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
        mapView.myLocationEnabled = YES;
        self.view = mapView;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupMenuBarButtonItems];
    [self setupFrames];
}

#pragma mark - User Interface Setup
- (void)setupFrames
{
    CGRect screenFrame = [UIScreen mainScreen].bounds;
    CGFloat bottomHeight = 44;
    CGFloat bottomInset = 0;
    CGFloat logoLeftInset = 30;
    CGFloat logoTopInset = 10;
    CGFloat logoWidth = 100;
    CGFloat logoHeight = 30;

//The bottom background
    CGRect bottomFrame = CGRectMake(bottomInset, screenFrame.size.height - bottomHeight, screenFrame.size.width, bottomHeight);
    UIView *bottomView = [[UIView alloc] initWithFrame:bottomFrame];
    bottomView.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.7];
    [mapView addSubview:bottomView];

//CitySpade Logo
    CGRect logoFrame = CGRectMake(bottomInset+logoLeftInset, screenFrame.size.height-bottomHeight+logoTopInset, logoWidth, logoHeight);
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:logoFrame];
    logoImageView.image = [UIImage imageNamed:@"cityspade.png"];
    logoImageView.alpha = 1.0f;
    logoImageView.contentMode = UIViewContentModeScaleAspectFill;
    [mapView addSubview:logoImageView];
    //toList Button
    CGRect buttonFrame = CGRectMake(200, 400, 60, 20);
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = buttonFrame;
    button.backgroundColor = [UIColor redColor];
    button.titleLabel.text = @"List";
    [button addTarget:self action:@selector(listButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [mapView addSubview:button];

//SearchBarch
    CGFloat searchBarLeftInset = 10;
    CGFloat searchBarTopInset = 60;
    CGFloat searchBarWidth = screenFrame.size.width - 2 * searchBarLeftInset;
    CGFloat searchBarHeight = 50;
    CGRect searchBarFrame = CGRectMake(searchBarLeftInset, searchBarTopInset, searchBarWidth, searchBarHeight);
    UIView *searchBar = [[UIView alloc] initWithFrame:searchBarFrame];
    searchBar.backgroundColor = [UIColor whiteColor];
    searchBar.layer.shadowColor = [[UIColor blackColor] CGColor];
    searchBar.layer.shadowOffset = CGSizeMake(0, 0);
    searchBar.layer.shadowRadius = 3.0f;
    searchBar.layer.shadowOpacity = 0.8f;
    //SearchBar icon
    CGFloat searchIconLeftInset = 12;
    CGFloat searchIconTopInset = 12;
    CGFloat searchIconWidth = 16;
    CGFloat searchIconHeight = 16;
    CGRect searchBarIconFrame = CGRectMake(searchIconLeftInset, searchIconTopInset, searchIconWidth, searchIconHeight);
    UIImageView *searchBarIconImageView = [[UIImageView alloc] initWithFrame:searchBarIconFrame];
    searchBarIconImageView.image = [UIImage imageNamed:@"Search-icon.png"];
    [searchBar addSubview:searchBarIconImageView];
    //SearchBar textfield
    CGFloat textFieldLeftToSearchIcon = 5;
    CGFloat textFieldTopToBorder = 5;
    CGFloat textFieldWidth = screenFrame.size.width * 0.8;
    CGRect searchBarTextFieldFrame = CGRectMake(searchIconLeftInset + searchIconWidth + textFieldLeftToSearchIcon, textFieldTopToBorder, textFieldWidth, searchBarHeight-2*textFieldTopToBorder);
    UITextField *textField = [[UITextField alloc] initWithFrame:searchBarTextFieldFrame];
    textField.placeholder = @"e.g. New York, Timesquare";
    textField.enabled = YES;
    [searchBar addSubview:textField];
    
    
    [mapView addSubview:searchBar];
}

#pragma mark -
#pragma mark - UIBarButtonItems

- (void)setupMenuBarButtonItems {
    self.navigationItem.rightBarButtonItem = [self rightMenuBarButtonItem];
    if(self.menuContainerViewController.menuState == MFSideMenuStateClosed &&
       ![[self.navigationController.viewControllers objectAtIndex:0] isEqual:self]) {
        self.navigationItem.leftBarButtonItem = [self backBarButtonItem];
    } else {
        self.navigationItem.leftBarButtonItem = [self leftMenuBarButtonItem];
    }
}

- (UIBarButtonItem *)leftMenuBarButtonItem {
    return [[UIBarButtonItem alloc]
            initWithImage:[UIImage imageNamed:@"menu-icon.png"] style:UIBarButtonItemStyleBordered
            target:self
            action:@selector(leftSideMenuButtonPressed:)];
}

- (UIBarButtonItem *)rightMenuBarButtonItem {
    return [[UIBarButtonItem alloc]
            initWithImage:[UIImage imageNamed:@"menu-icon.png"] style:UIBarButtonItemStyleBordered
            target:self
            action:@selector(rightSideMenuButtonPressed:)];
}

- (UIBarButtonItem *)backBarButtonItem {
    return [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back-arrow"]
                                            style:UIBarButtonItemStyleBordered
                                           target:self
                                           action:@selector(backButtonPressed:)];
}


#pragma mark -
#pragma mark - UIBarButtonItem Callbacks

- (void)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)leftSideMenuButtonPressed:(id)sender {
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
        [self setupMenuBarButtonItems];
    }];
}

- (void)rightSideMenuButtonPressed:(id)sender {
    [self.menuContainerViewController toggleRightSideMenuCompletion:^{
        [self setupMenuBarButtonItems];
    }];
}


#pragma mark -
#pragma mark - IBActions

- (void)pushAnotherPressed:(id)sender {
    
}

#pragma mark - Handle the button click
- (void)listButtonClicked
{
    NSLog(@"list button clicked");
    CTListViewController *listVC = [[CTListViewController alloc] init];
    [self.navigationController pushViewController:listVC animated:YES];
}

@end