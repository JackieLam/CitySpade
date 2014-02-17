//
//  BedSegment.m
//  CitySpade
//
//  Created by Cho-Yeung Lam on 17/2/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import "BedSegment.h"

@implementation BedSegment

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        // Set divider images
        [self setDividerImage:[UIImage imageNamed:@"segment-divider-none-selected.png"]
          forLeftSegmentState:UIControlStateNormal
            rightSegmentState:UIControlStateNormal
                   barMetrics:UIBarMetricsDefault];
        
        [self setDividerImage:[UIImage imageNamed:@"segment-divider-left-selected.png"]
          forLeftSegmentState:UIControlStateSelected
            rightSegmentState:UIControlStateNormal
                   barMetrics:UIBarMetricsDefault];
        [self setDividerImage:[UIImage imageNamed:@"segment-divider-right-selected.png"]
          forLeftSegmentState:UIControlStateNormal
            rightSegmentState:UIControlStateSelected
                   barMetrics:UIBarMetricsDefault];
        [self setDividerImage:[UIImage imageNamed:@"segment-divider-none-selected.png"]
          forLeftSegmentState:UIControlStateHighlighted
            rightSegmentState:UIControlStateNormal
                   barMetrics:UIBarMetricsDefault];
        [self setDividerImage:[UIImage imageNamed:@"segment-divider-none-selected.png"]
          forLeftSegmentState:UIControlStateNormal
            rightSegmentState:UIControlStateHighlighted
                   barMetrics:UIBarMetricsDefault];
        [self setDividerImage:[UIImage imageNamed:@"segment-divider-left-selected.png"] forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
        [self setDividerImage:[UIImage imageNamed:@"segment-divider-right-selected.png"] forLeftSegmentState:UIControlStateHighlighted rightSegmentState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
        
        // Set background images
        UIImage *normalBackgroundImage = [UIImage imageNamed:@"segment-normal-bkgd.png"];
        [self setBackgroundImage:normalBackgroundImage
                        forState:UIControlStateNormal
                      barMetrics:UIBarMetricsDefault];
        UIImage *selectedBackgroundImage = [UIImage imageNamed:@"segment-selected-bkgd.png"];
        [self setBackgroundImage:selectedBackgroundImage
                        forState:UIControlStateSelected
                      barMetrics:UIBarMetricsDefault];
        [self setBackgroundImage:normalBackgroundImage
                        forState:UIControlStateHighlighted
                      barMetrics:UIBarMetricsDefault];
    }
    return self;
}

@end
