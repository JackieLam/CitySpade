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
#import "BedSegment.h"
#import "Constants.h"
#import <MFSideMenu.h>
#import <QuartzCore/QuartzCore.h>

#define thisBackgroundColor [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0f]
#define titleFont [UIFont fontWithName:@"Avenir-Roman" size:15.0f]
#define titleTextColor [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0f]
#define greenColor [UIColor colorWithRed:41.0/255.0 green:188.0/255.0 blue:184.0/255.0 alpha:1.0f]

#define saleMaxValue 120000000
#define rentMaxValue 120000

@interface CTFilterViewController()

@end

@implementation CTFilterViewController

- (void)viewDidLoad
{
    self.view.backgroundColor = thisBackgroundColor;
    self.navigationController.navigationBar.opaque = YES;
    self.navigationController.navigationBar.translucent = NO;
    self.view.userInteractionEnabled = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetSliderValueRange:) name:kNotificationToLoadAllListings object:nil];
    [self setTitleAttribute];
    [self setSearchBar];
    [self setApplyButton];
    [self setSections];
    [self setSliderWithMaxValue:120000 minValue:0];
    [self setSegments];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateRangeLabel:self.rangeSlider];
}

- (void)setTitleAttribute
{
    UIView *white = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-50.0f, 66)];
    white.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:white.bounds];
    titleLabel.frame = CGRectOffset(titleLabel.frame, 0, 10);
    titleLabel.font = [UIFont fontWithName:@"Avenir-Black" size:15.0f];
    titleLabel.textColor = [UIColor colorWithRed:91.0/255.0 green:91.0/255.0 blue:91.0/255.0 alpha:1.0f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"Search Refine";
    
    [white addSubview:titleLabel];
    [self.view addSubview:white];
}

- (void)setSearchBar
{
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 66.0f, 195.0f, 43.0f)];
    searchBar.backgroundColor = [UIColor clearColor];
    searchBar.placeholder = @" New York NY             ";
    searchBar.userInteractionEnabled = NO;
    
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
    [self.applyButton setTitle:@"Apply" forState:UIControlStateHighlighted];
    [self.applyButton setTitle:@"Apply" forState:UIControlStateSelected];
    [self.applyButton addTarget:self action:@selector(didApplyFiltering) forControlEvents:UIControlEventTouchUpInside];
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

- (void)setSliderWithMaxValue:(float)maxValue minValue:(float)minValue
{
    if (!self.popoverView) {
        self.popoverView = [[ANPopoverView alloc] initWithFrame:CGRectZero];
        self.popoverView.backgroundColor = [UIColor clearColor];
    }
    
    if (!self.rangeSlider)
        self.rangeSlider = [[NMRangeSlider alloc] initWithFrame:CGRectMake(32, 175, 200, 20)];
    UIImage* image = nil;
    
    image = [UIImage imageNamed:@"slider_bg"];
//    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)];
    self.rangeSlider.trackBackgroundImage = image;
    
    image = [UIImage imageNamed:@"slider_highlight_bg"];
//    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 7.0, 0.0, 7.0)];
    self.rangeSlider.trackImage = image;
    
    image = [UIImage imageNamed:@"slider_handle"];
    self.rangeSlider.lowerHandleImageNormal = image;
    self.rangeSlider.upperHandleImageNormal = image;
    
    image = [UIImage imageNamed:@"slider_handle"];
    self.rangeSlider.lowerHandleImageHighlighted = image;
    self.rangeSlider.upperHandleImageHighlighted = image;
    
    self.rangeSlider.minimumValue = minValue;
    self.rangeSlider.maximumValue = maxValue;
    
    self.rangeSlider.lowerValue = self.rangeSlider.minimumValue;
    self.rangeSlider.upperValue = self.rangeSlider.maximumValue;
    
    
//    self.rangeSlider.minimumRange = 1000;
    [self.rangeSlider addTarget:self action:@selector(updateRangeLabel:) forControlEvents:UIControlEventValueChanged];
    [self updateRangeLabel:self.rangeSlider];
    
    if (![self.view.subviews containsObject:self.popoverView])
        [self.view addSubview:self.popoverView];
    if (![self.view.subviews containsObject:self.rangeSlider])
        [self.view addSubview:self.rangeSlider];
}

- (void)updateRangeLabel:(NMRangeSlider *)slider
{
    CGPoint lowerCenter;
    lowerCenter.x = slider.lowerCenter.x;
//    NSLog(@"slider.lowerCenter -- %f upperCenter -- %f", slider.lowerCenter.x, slider.upperCenter.x);
    lowerCenter.y = slider.center.y - 30.0f;
    CGPoint upperCenter;
    upperCenter.x = slider.upperCenter.x;
    upperCenter.y = slider.center.y - 30.0f;
    CGPoint middleCenter;
    middleCenter.x = (lowerCenter.x + upperCenter.x) * 0.5;
    middleCenter.y = lowerCenter.y;
    self.popoverView.center = middleCenter;
    
    if (slider.upperValue > rentMaxValue) {
        // It is in the for sale status
        self.popoverView.textLabel.text = [NSString stringWithFormat:@"$%dM - %dM", (int)slider.lowerValue/1000000, (int)slider.upperValue/1000000];
    }
    else {
        // It is in the for rent status
        self.popoverView.textLabel.text = [NSString stringWithFormat:@"$%d - %d", (int)slider.lowerValue, (int)slider.upperValue];
    }
}

- (void)setSegments
{
    self.bedSegmentControl = [[BedSegment alloc] initWithItems:@[@"Any", @"1", @"2", @"3", @"4+"]];
    self.bedSegmentControl.frame = CGRectMake(18, 246, 240, 36);
    NSDictionary *attributes1 = @{NSFontAttributeName: [UIFont fontWithName:@"Avenir-Roman" size:12.0f], NSForegroundColorAttributeName: greenColor};
    NSDictionary *attributes2 = @{NSFontAttributeName: [UIFont fontWithName:@"Avenir-Roman" size:12.0f], NSForegroundColorAttributeName: [UIColor whiteColor]};
    [self.bedSegmentControl setTitleTextAttributes:attributes1 forState:UIControlStateNormal];
    [self.bedSegmentControl setTitleTextAttributes:attributes2 forState:UIControlStateSelected];
    [self.bedSegmentControl setSelectedSegmentIndex:0];
    [self.view addSubview:self.bedSegmentControl];
    
    self.bathSegmentControl = [[BedSegment alloc] initWithItems:@[@"Any", @"1", @"2", @"3", @"4+"]];
    self.bathSegmentControl.frame = CGRectMake(18, 330, 240, 36);
    [self.bathSegmentControl setTitleTextAttributes:attributes1 forState:UIControlStateNormal];
    [self.bathSegmentControl setTitleTextAttributes:attributes2 forState:UIControlStateSelected];
    [self.bathSegmentControl setSelectedSegmentIndex:0];
    [self.view addSubview:self.bathSegmentControl];
}

#pragma mark - 
#pragma mark - Handle Events

- (void)didApplyFiltering
{
    NSMutableDictionary *filterData = [NSMutableDictionary dictionary];
    filterData[@"lowerBound"] = [NSString stringWithFormat:@"%d", (int)self.rangeSlider.lowerValue];
    filterData[@"higherBound"] = [NSString stringWithFormat:@"%d", (int)self.rangeSlider.upperValue];
    filterData[@"beds"] = [self.bedSegmentControl titleForSegmentAtIndex:[self.bedSegmentControl selectedSegmentIndex]];
    filterData[@"baths"] = [self.bathSegmentControl titleForSegmentAtIndex:[self.bathSegmentControl selectedSegmentIndex]];
    
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationDidRightFilter object:filterData];
}


#pragma mark - 
#pragma mark - Reset the slider's value range
- (void)resetSliderValueRange:(NSNotification *)aNotification
{
    NSDictionary *param = [aNotification object];
    BOOL forRent = [param[@"rent"] boolValue];
    if (forRent)
        [self setSliderWithMaxValue:rentMaxValue minValue:0];
    else
        [self setSliderWithMaxValue:saleMaxValue minValue:0];
}

@end