//
//  MapCollectionCell.h
//  CitySpade
//
//  Created by Cho-Yeung Lam on 28/2/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import <UIKit/UIKit.h>

@class REVClusterPin;
@class AsynImageView;

@interface MapCollectionCell : UICollectionViewCell
@property (strong, nonatomic) AsynImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *bargainLabel;
@property (strong, nonatomic) IBOutlet UILabel *transportationLabel;
@property (strong, nonatomic) IBOutlet UILabel *bedLabel;
@property (strong, nonatomic) IBOutlet UILabel *bathLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) UIButton *leftButton;
@property (strong, nonatomic) UIButton *rightButton;
- (void)configureCellWithClusterPin:(REVClusterPin *)pin;

@end
