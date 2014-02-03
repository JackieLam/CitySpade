//
//  CTMapView.m
//  CitySpade
//
//  Created by Cho-Yeung Lam on 22/1/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

//TODO: optimize the memory of the map
#import "CTMapView.h"
#import <GoogleMaps/GoogleMaps.h>

@implementation CTMapView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    
    if (self) {
        CGRect screenFrame = [UIScreen mainScreen].bounds;
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:40.7576 longitude:-73.9627 zoom:12];
        self.mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
        self.mapView.frame = screenFrame;
        [self addSubview:self.mapView];
        self.mapView.myLocationEnabled = YES;
//        self.mapView.settings.myLocationButton = YES;
//        self.mapView.settings.compassButton = YES;
        CGFloat bottomHeight = 44;
        CGFloat bottomInset = 0;
        CGFloat logoLeftInset = 30;
        CGFloat logoTopInset = 10;
        CGFloat logoWidth = 100;
        CGFloat logoHeight = 30;
        
        //The bottom background
        CGRect bottomFrame = CGRectMake(bottomInset, screenFrame.size.height - bottomHeight, screenFrame.size.width, bottomHeight);
        self.bottomView = [[UIView alloc] initWithFrame:bottomFrame];
        self.bottomView.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.7];
        [self addSubview:self.bottomView];
        
        //CitySpade Logo
        CGRect logoFrame = CGRectMake(bottomInset+logoLeftInset, screenFrame.size.height-bottomHeight+logoTopInset, logoWidth, logoHeight);
        UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:logoFrame];
        logoImageView.image = [UIImage imageNamed:@"cityspade.png"];
        logoImageView.alpha = 1.0f;
        logoImageView.contentMode = UIViewContentModeScaleAspectFill;
//        [self addSubview:logoImageView];
        //toList Button
        CGRect buttonFrame = CGRectMake(200, 400, 60, 20);
        self.listButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.listButton.frame = buttonFrame;
        self.listButton.backgroundColor = [UIColor redColor];
        self.listButton.titleLabel.text = @"List";
        self.listButton.titleLabel.textColor = [UIColor blackColor];
//        [self addSubview:self.listButton];
        
        //SearchBar
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
//        [searchBar addSubview:searchBarIconImageView];
        //SearchBar textfield
        CGFloat textFieldLeftToSearchIcon = 5;
        CGFloat textFieldTopToBorder = 5;
        CGFloat textFieldWidth = screenFrame.size.width * 0.8;
        CGRect searchBarTextFieldFrame = CGRectMake(searchIconLeftInset + searchIconWidth + textFieldLeftToSearchIcon, textFieldTopToBorder, textFieldWidth, searchBarHeight-2*textFieldTopToBorder);
        UITextField *textField = [[UITextField alloc] initWithFrame:searchBarTextFieldFrame];
        textField.placeholder = @"e.g. New York, Timesquare";
        textField.enabled = YES;
//        [searchBar addSubview:textField];
//        [self addSubview:searchBar];
        [self setupBottomBar];
    }
    return self;
}

- (void)setupBottomBar
{
    CGRect saveButtonFrame;
    CGRect currentLocationButtonFrame;
    CGRect listButtonFrame;
    CGRect localButtonFrame;
    CGFloat topInset = 5.0f;
    CGFloat buttonSize = 30.0f;
    
    saveButtonFrame = CGRectMake(5.0f, topInset, buttonSize, buttonSize);
    currentLocationButtonFrame = CGRectMake(40.0f, topInset, buttonSize, buttonSize);
    listButtonFrame = CGRectMake(75.0f, topInset, buttonSize, buttonSize);
    localButtonFrame = CGRectMake(110.0f, topInset, buttonSize, buttonSize);
    
    self.saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.saveButton.frame = saveButtonFrame;
    self.saveButton.backgroundColor = [UIColor whiteColor];
    [self.saveButton setImage:[UIImage imageNamed:@"Add-Number"] forState:UIControlStateNormal];
    [self.saveButton setImage:[UIImage imageNamed:@"Checked"] forState:UIControlStateHighlighted];
    [self.bottomView addSubview:self.saveButton];
    
    self.currentLocationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.currentLocationButton.frame = currentLocationButtonFrame;
    self.currentLocationButton.backgroundColor = [UIColor whiteColor];
    [self.currentLocationButton setImage:[UIImage imageNamed:@"Delete-Entered"] forState:UIControlStateNormal];
    [self.currentLocationButton setImage:[UIImage imageNamed:@"Checked"] forState:UIControlStateHighlighted];
    [self.bottomView addSubview:self.currentLocationButton];
    
    self.listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.listButton.frame = listButtonFrame;
    self.listButton.backgroundColor = [UIColor whiteColor];
    [self.listButton setImage:[UIImage imageNamed:@"Delete"] forState:UIControlStateNormal];
    [self.listButton setImage:[UIImage imageNamed:@"Checked"] forState:UIControlStateHighlighted];
    [self.bottomView addSubview:self.listButton];
    
    self.localButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.localButton.frame = localButtonFrame;
    self.localButton.backgroundColor = [UIColor whiteColor];
    [self.localButton setImage:[UIImage imageNamed:@"Delete-Entered"] forState:UIControlStateNormal];
    [self.localButton setImage:[UIImage imageNamed:@"Checked"] forState:UIControlStateHighlighted];
    [self.bottomView addSubview:self.localButton];
}

@end
