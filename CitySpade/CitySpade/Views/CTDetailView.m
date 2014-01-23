//
//  CTDetailView.m
//  CitySpade
//
//  Created by Cho-Yeung Lam on 23/1/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import "CTDetailView.h"

@implementation CTDetailView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupInterface];
    }
    return self;
}

- (void)setupInterface
{
    CGRect screenFrame = [UIScreen mainScreen].bounds;
    CGRect imageFrame = CGRectMake(0, 0, screenFrame.size.width, screenFrame.size.width*0.5);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageFrame];
    
}

@end
