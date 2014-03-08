//
//  MapBottomBar.h
//  CitySpade
//
//  Created by Cho-Yeung Lam on 3/2/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    BarStateMapDefault = 0,
    BarStateMapDraw,
    BarStateList,
} BarState;

@interface MapBottomBar : UIView

@property (nonatomic) BarState barState;

//BarStateMapDefault & BarStateList
@property (strong, nonatomic) UISegmentedControl *segmentControl;

//BarStateMapDefault
@property (strong, nonatomic) UIButton *saveButton;
@property (strong, nonatomic) UIButton *drawButton;

//BarStateMapDraw
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIButton *clearButton;

//BarStateList
@property (strong, nonatomic) UIButton *sortButton;

- (void)resetBarState:(BarState)newState;

@end
