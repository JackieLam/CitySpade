//
//  MapCollectionCell.m
//  CitySpade
//
//  Created by Cho-Yeung Lam on 28/2/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import "MapCollectionCell.h"
#import "REVClusterPin.h"

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
    }
    return self;
}

- (void)configureCellWithClusterPin:(REVClusterPin *)pin
{
    self.imageView.image = [UIImage imageNamed:@"imgplaceholder_long"];
    self.titleLabel.text = pin.title;
    self.bargainLabel.text = pin.bargain;
    self.transportationLabel.text = pin.transportation;
    self.priceLabel.text = pin.subtitle;
    self.bedLabel.text = pin.beds;
    self.bathLabel.text = pin.baths;
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.frame = self.imageView.frame;
    [self addSubview:activityIndicator];
    [activityIndicator startAnimating];
    NSString *urlString = pin.thumbImageLink;
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        [activityIndicator stopAnimating];
        [activityIndicator removeFromSuperview];
        UIImage *image = [UIImage imageWithData:data];
        [self.imageView setImage:image];
        
    }] resume];
}

@end
