//
//  CTListCell.m
//  CitySpade
//
//  Created by Cho-Yeung Lam on 23/1/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import "CTListCell.h"

@implementation CTListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupLabelsAndImages];
    }
    return self;
}

- (void)setupLabelsAndImages
{
    CGRect cellFrame = self.bounds;
//thumbImageView
    CGFloat imageLeftInset = 10;
    CGFloat imageTopInset = 10;
    
    CGRect imageViewFrame = CGRectMake(imageLeftInset, imageTopInset, 120, 100-2*imageTopInset);
    self.thumbImageView = [[UIImageView alloc] initWithFrame:imageViewFrame];
    self.thumbImageView.backgroundColor = [UIColor redColor];
//    self.thumbImageView.frame = imageViewFrame;
    [self addSubview:self.thumbImageView];
//titleLabel
    CGRect titleLabelFrame = CGRectMake(200, imageTopInset, 120, 20);
    self.titleLabel = [[UILabel alloc] initWithFrame:titleLabelFrame];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textColor = [UIColor blackColor];
    [self addSubview:self.titleLabel];
}

@end
