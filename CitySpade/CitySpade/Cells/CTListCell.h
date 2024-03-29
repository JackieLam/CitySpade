//
//  CTListCell.h
//  CitySpade
//
//  Created by Cho-Yeung Lam on 23/1/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class Listing;
@class REVClusterPin;
@class AsynImageView;

typedef NS_ENUM(NSInteger, CTListCellStyle) {
    CTListCellStyleDefault,
    CTListCellStyleSaved
};

@interface CTListCell : UITableViewCell
{
    BOOL isEditing;
}

@property (nonatomic, strong) AsynImageView *thumbImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *bargainLabel;
@property (nonatomic, strong) UILabel *transportLabel;
@property (nonatomic, strong) UILabel *bedLabel;
@property (nonatomic, strong) UILabel *bathLabel;
@property (nonatomic, strong) UIView *rightView;
@property (nonatomic) double identiferNumber;
@property (nonatomic, strong) REVClusterPin *pin;
@property (nonatomic, assign) BOOL isSaved;
@property (nonatomic, strong) UIButton *favorBtn;
@property (nonatomic) CLLocationCoordinate2D coordinate;

- (id)initWithCTListCellStyle:(CTListCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
- (void)configureCellWithClusterPin:(REVClusterPin *)pin;
- (void)configureCellWithListing:(Listing *)listing;
- (void)setNormalState;
- (void)setFavorState;
- (void)changeState;
@end
