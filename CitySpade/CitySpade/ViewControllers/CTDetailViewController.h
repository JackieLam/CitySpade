//
//  CTDetailViewController.h
//  CitySpade
//
//  Created by Cho-Yeung Lam on 23/1/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CTDetailView;

@interface CTDetailViewController : UIViewController

@property (nonatomic, strong) UIImage *houseImage;
@property (nonatomic) NSDictionary *house;
@property (nonatomic, strong) CTDetailView *ctdetailView;

@end