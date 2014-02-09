//
//  CTCollectionCell.h
//  CitySpade
//
//  Created by Cho-Yeung Lam on 7/2/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTCollectionCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *thumbImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *bargainLabel;
@property (nonatomic, strong) UILabel *transportLabel;
@property (nonatomic, strong) UILabel *bedLabel;
@property (nonatomic, strong) UILabel *bathLabel;

- (void)setupCellWithJSON:(NSDictionary *)json;

@end
