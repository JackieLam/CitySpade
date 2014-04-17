//
//  UISegmentedControl+Project.m
//  CitySpade
//
//  Created by Cho-Yeung Lam on 14/3/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import "UISegmentedControl+Project.h"

@implementation UISegmentedControl (Project)

+ (UISegmentedControl *)createSavingSegmentWithItems:(NSArray *)items
{
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:items];
    segment.selectedSegmentIndex = 0;
    // Set divider images
    [segment setDividerImage:[UIImage imageNamed:@"savings_segment_divider_greenwhite"]
                           forLeftSegmentState:UIControlStateSelected
                             rightSegmentState:UIControlStateNormal
                                    barMetrics:UIBarMetricsDefault];
    [segment setDividerImage:[UIImage imageNamed:@"savings_segment_divider_whitegreen"]
                           forLeftSegmentState:UIControlStateNormal
                             rightSegmentState:UIControlStateSelected
                                    barMetrics:UIBarMetricsDefault];
    [segment setDividerImage:[UIImage imageNamed:@"savings_segment_divider_greenwhite"]
                           forLeftSegmentState:UIControlStateHighlighted
                             rightSegmentState:UIControlStateNormal
                                    barMetrics:UIBarMetricsDefault];
    [segment setDividerImage:[UIImage imageNamed:@"savings_segment_divider_whitegreen"]
                           forLeftSegmentState:UIControlStateNormal
                             rightSegmentState:UIControlStateHighlighted
                                    barMetrics:UIBarMetricsDefault];
    [segment setDividerImage:[UIImage imageNamed:@"savings_segment_divider_greenwhite"] forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    [segment setDividerImage:[UIImage imageNamed:@"savings_segment_divider_whitegreen"] forLeftSegmentState:UIControlStateHighlighted rightSegmentState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    // Set background images
    UIImage *normalBackgroundImage = [UIImage imageNamed:@"savings_segment_notselected"];
    [segment setBackgroundImage:normalBackgroundImage
                                         forState:UIControlStateNormal
                                       barMetrics:UIBarMetricsDefault];
    UIImage *selectedBackgroundImage = [UIImage imageNamed:@"savings_segment_selected"];
    [segment setBackgroundImage:selectedBackgroundImage
                                         forState:UIControlStateSelected
                                       barMetrics:UIBarMetricsDefault];
    [segment setBackgroundImage:normalBackgroundImage
                                         forState:UIControlStateHighlighted
                                       barMetrics:UIBarMetricsDefault];
    NSMutableDictionary *textAttributes = [NSMutableDictionary dictionaryWithCapacity:1];
    textAttributes[NSFontAttributeName] = [UIFont fontWithName:@"AvenirNext-DemiBold" size:12.5];
    textAttributes[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [segment setTitleTextAttributes:textAttributes forState:UIControlStateSelected];
    textAttributes[NSForegroundColorAttributeName] = [UIColor colorWithRed:41.0/255.0 green:188.0/255.0 blue:184.0/255.0 alpha:1.0f];
    [segment setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    [segment setTitleTextAttributes:textAttributes forState:UIControlStateHighlighted];
    return segment;
}

@end
