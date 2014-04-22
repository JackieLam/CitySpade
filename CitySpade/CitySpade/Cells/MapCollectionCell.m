//
//  MapCollectionCell.m
//  CitySpade
//
//  Created by Cho-Yeung Lam on 28/2/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import "MapCollectionCell.h"
#import "REVClusterPin.h"
#import "AsynImageView.h"

@implementation MapCollectionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"MapCollectionCell" owner:self options:nil];
        if ([arrayOfViews count] < 1) {
            return nil;
        }
        
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        self = [arrayOfViews objectAtIndex:0];
        self.imageView = [[AsynImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 170)];
        self.imageView.placeholderImage = [UIImage imageNamed:@"imgplaceholder_square"];
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

- (void)configureCellWithClusterPin:(REVClusterPin *)pin
{
    self.titleLabel.text = pin.title;
    self.bargainLabel.text = pin.bargain;
    self.transportationLabel.text = pin.transportation;
    self.priceLabel.text = pin.subtitle;
    self.bedLabel.text = pin.beds;
    self.bathLabel.text = pin.baths;
    self.imageView.imageURL = pin.thumbImageLink;
}

- (void)prepareForReuse
{
    [self.imageView cancelConnection];
}
@end
