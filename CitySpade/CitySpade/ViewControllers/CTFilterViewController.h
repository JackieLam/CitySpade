//
//  CTFilterViewController.h
//  CitySpade
//
//  Created by Cho-Yeung Lam on 22/1/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RangeSlider;

@interface CTFilterViewController : UIViewController

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) RangeSlider *priceRangeSlider;

@end
