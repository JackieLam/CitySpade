//
//  CTCollectionCell.m
//  CitySpade
//
//  Created by Cho-Yeung Lam on 7/2/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import "CTCollectionCell.h"

@implementation CTCollectionCell

- (id)init
{
    self = [super init];
    if (self) {
        [self setupCell];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //further initialization
        [self setupCell];
    }
    return self;
}

- (void)setupCell
{
    self.backgroundColor = [UIColor clearColor];
    self.thumbImageview = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 40, 40)];
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, 50, 20)];
    self.subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 25, 50, 20)];
    [self addSubview:self.thumbImageview];
    [self addSubview:self.titleLabel];
    [self addSubview:self.subtitleLabel];
}

@end
