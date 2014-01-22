//
//  CTMapView.m
//  CitySpade
//
//  Created by Cho-Yeung Lam on 22/1/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import "CTMapView.h"
#import <GoogleMaps/GoogleMaps.h>

@implementation CTMapView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    
    if (self) {
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86 longitude:151.20 zoom:6];
        self.mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
        self.mapView.myLocationEnabled = YES;
        
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
        [self addSubview:bottomView];
        
        //CitySpade Logo
        CGRect logoFrame = CGRectMake(bottomInset+logoLeftInset, screenFrame.size.height-bottomHeight+logoTopInset, logoWidth, logoHeight);
        UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:logoFrame];
        logoImageView.image = [UIImage imageNamed:@"cityspade.png"];
        logoImageView.alpha = 1.0f;
        logoImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:logoImageView];
        //toList Button
        CGRect buttonFrame = CGRectMake(200, 400, 60, 20);
        self.listButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.listButton.frame = buttonFrame;
        self.listButton.backgroundColor = [UIColor redColor];
        self.listButton.titleLabel.text = @"List";
        self.listButton.titleLabel.textColor = [UIColor blackColor];
        [self addSubview:self.listButton];
        
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
        
        [self addSubview:searchBar];
        [self addSubview:self.mapView];
    }
    return self;
}

@end
