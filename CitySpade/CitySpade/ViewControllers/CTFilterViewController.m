//
//  CTFilterViewController.m
//  CitySpade
//
//  Created by Cho-Yeung Lam on 22/1/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import "CTFilterViewController.h"
#import "NMRangeSlider.h"
#import "ANPopoverView.h"
#import <QuartzCore/QuartzCore.h>

#define thisBackgroundColor [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0f]
#define titleFont [UIFont fontWithName:@"Avenir-Roman" size:15.0f]
#define titleTextColor [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0f]
#define greenColor [UIColor colorWithRed:41.0/255.0 green:188.0/255.0 blue:184.0/255.0 alpha:1.0f]

@interface CTFilterViewController()

@end

@implementation CTFilterViewController

- (void)viewDidLoad
{
    self.view.backgroundColor = thisBackgroundColor;
    self.navigationController.navigationBar.opaque = YES;
    self.navigationController.navigationBar.translucent = NO;
    self.view.userInteractionEnabled = YES;
    
    [self setTitleAttribute];
    [self setSearchBar];
    [self setApplyButton];
    [self setSections];
    [self setSlider];
}

- (void)setTitleAttribute
{
    
//    UIColor *color = [UIColor colorWithRed:73.0f/255.0f green:73.0f/255.0f blue:73.0f/255.0f alpha:1.0];
//    UIFont *font = [UIFont fontWithName:@"Avenir-Black" size:15.0f];
//    NSMutableDictionary *navBarTextAttributes = [NSMutableDictionary dictionaryWithCapacity:1];
//    [navBarTextAttributes setObject:font forKey:NSFontAttributeName];
//    [navBarTextAttributes setObject:color forKey:NSForegroundColorAttributeName];
//    
//    self.navigationController.navigationBar.titleTextAttributes = navBarTextAttributes;
//    self.title = @"Search Refine";
}

- (void)setSearchBar
{
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 66.0f, 195.0f, 43.0f)];
    searchBar.backgroundColor = [UIColor clearColor];
    searchBar.placeholder = @" New York NY             ";
    
//    searchBar.searchFieldBackgroundPositionAdjustment = UIOffsetMake(-10.0f, 10.0f);
//    searchBar.searchTextPositionAdjustment = UIOffsetMake(-40.0f, 0.0f);
//    [searchBar setPositionAdjustment:UIOffsetMake(-40.0f, 0.0f) forSearchBarIcon:UISearchBarIconSearch];
    
    [self.view addSubview:searchBar];
}

- (void)setApplyButton
{
    UIView *whiteBg = [[UIView alloc] initWithFrame:CGRectMake(195.0f, 66.0f, self.view.frame.size.width-195.0f-25.0f, 43.0f)];
    whiteBg.backgroundColor = [UIColor whiteColor];
    self.applyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.applyButton.frame = CGRectMake(6, 6, 61, 31);
    self.applyButton.layer.cornerRadius = 5.0f;
    self.applyButton.backgroundColor = greenColor;
    self.applyButton.titleLabel.textColor = [UIColor whiteColor];
    self.applyButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:12.5];
    [self.applyButton setTitle:@"Apply" forState:UIControlStateNormal];
    [self.applyButton setTitle:@"Apply1" forState:UIControlStateHighlighted];
    [self.applyButton setTitle:@"Apply2" forState:UIControlStateSelected];
//    self.applyButton
    [whiteBg addSubview:self.applyButton];
    [self.view addSubview:whiteBg];
}

- (void)setSections
{
    UILabel *title1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 55+66, 170, 17)];
    title1.font = titleFont;
    title1.textColor = titleTextColor;
    title1.text = @"Price Range";
    [self.view addSubview:title1];
    UILabel *title2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 153+66, 170, 17)];
    title2.font = titleFont;
    title2.textColor = titleTextColor;
    title2.text = @"Bedrooms";
    [self.view addSubview:title2];
    UILabel *title3 = [[UILabel alloc] initWithFrame:CGRectMake(10, 476*0.5+66, 170, 17)];
    title3.font = titleFont;
    title3.textColor = titleTextColor;
    title3.text = @"Bathrooms";
    [self.view addSubview:title3];
    
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 75+66, 254, 68)];
    imageView1.backgroundColor = [UIColor clearColor];
    imageView1.image = [UIImage imageNamed:@"1white_bg"];
    imageView1.userInteractionEnabled = NO;
    
    [self.view addSubview:imageView1];
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 172+66, 254, 54)];
    imageView2.backgroundColor = [UIColor clearColor];
    imageView2.image = [UIImage imageNamed:@"2white_bg"];
    imageView2.userInteractionEnabled = NO;
    [self.view addSubview:imageView2];
    UIImageView *imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 256+66, 254, 54)];
    imageView3.backgroundColor = [UIColor clearColor];
    imageView3.image = [UIImage imageNamed:@"2white_bg"];
    imageView3.userInteractionEnabled = NO;
    [self.view addSubview:imageView3];
    
}

- (void)setSlider
{
    self.rangeSlider = [[NMRangeSlider alloc] initWithFrame:CGRectMake(32, 175, 200, 20)];
    UIImage* image = nil;
    
    image = [UIImage imageNamed:@"slider_bg"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)];
    self.rangeSlider.trackBackgroundImage = image;
    
    image = [UIImage imageNamed:@"slider_highlight_bg"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 7.0, 0.0, 7.0)];
    self.rangeSlider.trackImage = image;
    
    image = [UIImage imageNamed:@"slider_handle"];
    self.rangeSlider.lowerHandleImageNormal = image;
    self.rangeSlider.upperHandleImageNormal = image;
    
    image = [UIImage imageNamed:@"slider_handle"];
    self.rangeSlider.lowerHandleImageHighlighted = image;
    self.rangeSlider.upperHandleImageHighlighted = image;
    
    self.rangeSlider.lowerValue = 20;
    self.rangeSlider.upperValue = 80;
    
    self.popoverView = [[ANPopoverView alloc] initWithFrame:CGRectZero];
    self.popoverView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.popoverView];
    [self updateRangeLabel:self.rangeSlider];
    
    [self.rangeSlider addTarget:self action:@selector(updateRangeLabel:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.rangeSlider];
}

- (void)updateRangeLabel:(NMRangeSlider *)slider
{
    NSLog(@"Slider Range: %f - %f", slider.lowerValue, slider.upperValue);
    CGPoint lowerCenter;
    lowerCenter.x = slider.lowerCenter.x + slider.frame.origin.x;
    lowerCenter.y = slider.center.y - 30.0f;
    CGPoint upperCenter;
    upperCenter.x = slider.upperCenter.x + slider.frame.origin.x;
    upperCenter.y = slider.center.y - 30.0f;
    CGPoint middleCenter;
    middleCenter.x = (lowerCenter.x + upperCenter.x) * 0.5;
    middleCenter.y = lowerCenter.y;
    self.popoverView.center = middleCenter;
    self.popoverView.value = slider.upperValue;
}

@end
