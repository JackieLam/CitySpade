//
//  CTDetailView.h
//  CitySpade
//
//  Created by Cho-Yeung Lam on 23/1/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTDetailView : UIView

//Basic Facts
@property (nonatomic, strong) UIImageView *houseImageView;
@property (nonatomic, strong) UILabel *bargainLabel;
@property (nonatomic, strong) UILabel *transportationLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *bedLabel;
@property (nonatomic, strong) UILabel *bathLabel;

//Transportation Info
@property (nonatomic, strong) UILabel *subwayLinesLabel;
@property (nonatomic, strong) UILabel *buslinesLabel;

- (void)setInfosWithJSON:(NSDictionary *)json;

@end