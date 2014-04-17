//
//  CTListCell.h
//  CitySpade
//
//  Created by Cho-Yeung Lam on 23/1/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import <UIKit/UIKit.h>

@class REVClusterPin;

@interface CTListCell : UITableViewCell

@property (nonatomic, strong) UIImageView *thumbImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *bargainLabel;
@property (nonatomic, strong) UILabel *transportLabel;
@property (nonatomic, strong) UILabel *bedLabel;
@property (nonatomic, strong) UILabel *bathLabel;
@property (nonatomic, strong) UIView *rightView;
@property (nonatomic) double identiferNumber;

- (void)configureCellWithClusterPin:(REVClusterPin *)pin;

@end
