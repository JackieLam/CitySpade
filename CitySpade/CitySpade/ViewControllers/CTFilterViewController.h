//
//  CTFilterViewController.h
//  CitySpade
//
//  Created by Cho-Yeung Lam on 22/1/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ANPopoverView;
@class NMRangeSlider;
@class BedSegment;

@interface CTFilterViewController : UIViewController

@property (nonatomic, strong) NMRangeSlider *rangeSlider;
@property (nonatomic, strong) ANPopoverView *popoverView; 
@property (nonatomic, strong) UIButton *applyButton;
@property (nonatomic, strong) BedSegment *bedSegmentControl;
@property (nonatomic, strong) BedSegment *bathSegmentControl; 

@end
