//
//  SwitchSegment.h
//  CitySpade
//
//  Created by Alaysh on 4/19/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SwitchSegment: UISegmentedControl

/**
 
 * Font for the segments with title
 
 * Default is sysyem bold 18points
 
 */

@property (nonatomic, strong) UIFont  *font;

/**
 
 * Color of the item in the selected segment
 
 * Applied to text and images
 
 */

@property (nonatomic, strong) UIColor *selectedItemColor;

/**
 
 * Color of the items not in the selected segment
 
 * Applied to text and images
 
 */

@property (nonatomic, strong) UIColor *unselectedItemColor;

/**
 
 * Default is black with .2 alpha
 
 */

@property (nonatomic, strong) UIColor *selectedItemShadowColor;

/**
 
 * Default is white
 
 */

@property (nonatomic, strong) UIColor *unselectedItemShadowColor;


@property (nonatomic, assign) CGFloat cornerRadius;


/**
 
 * Contains the 2 gradient components for the non-selected items
 
 * Default is white and gray 200/255.0
 
 */

@property (nonatomic, strong) NSArray *unSelectedItemBackgroundGradientColors;

@end



