//
//  MapBottomBar.m
//  CitySpade
//
//  Created by Cho-Yeung Lam on 3/2/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import "MapBottomBar.h"

@implementation MapBottomBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:40.0/255.0 green:175.0/255.0 blue:169.0/255.0 alpha:0.9];
        [self setupBottomBar];
    }
    return self;
}

- (void)setupBottomBar
{
    CGRect saveButtonRect = CGRectMake(27, 16, 34, 23);
    CGRect drawButtonRect = CGRectMake(255, 16, 45, 23);
    CGRect tempImageViewRect = CGRectMake(126, 8, 72, 38);
    
    self.saveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.saveButton.frame = saveButtonRect;
    self.saveButton.backgroundColor = [UIColor clearColor];
    [self.saveButton setTitle:@"Save" forState:UIControlStateNormal];
    [self.saveButton.titleLabel setFont:[UIFont fontWithName:@"Avenir-Roman" size:15.0f]];
    [self.saveButton setTitleColor:[UIColor colorWithRed:172.0/255.0 green:255.0/255.0 blue:250.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self addSubview:self.saveButton];
    
    self.drawButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.drawButton.frame = drawButtonRect;
    self.drawButton.backgroundColor = [UIColor clearColor];
    self.drawButton.titleLabel.font = [UIFont fontWithName:@"Avenir-Roman" size:15.0f];
    [self.drawButton setTitle:@"Draw" forState:UIControlStateNormal];
    [self.drawButton setTitleColor:[UIColor colorWithRed:172.0/255.0 green:255.0/255.0 blue:250.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self addSubview:self.drawButton];
    
    self.tempImageView = [[UIImageView alloc] initWithFrame:tempImageViewRect];
    self.tempImageView.image = [UIImage imageNamed:@"swtich"];
    [self addSubview:self.tempImageView];
}

@end
