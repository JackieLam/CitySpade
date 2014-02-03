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
        [self setupBottomBar];
    }
    return self;
}

- (void)setupBottomBar
{
    CGRect saveButtonFrame;
    CGRect currentLocationButtonFrame;
    CGRect listButtonFrame;
    CGFloat topInset = 5.0f;
    CGFloat buttonSize = 30.0f;
    
    saveButtonFrame = CGRectMake(5.0f, topInset, buttonSize, buttonSize);
    currentLocationButtonFrame = CGRectMake(40.0f, topInset, buttonSize, buttonSize);
    listButtonFrame = CGRectMake(75.0f, topInset, buttonSize, buttonSize);
    
    self.saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.saveButton.frame = saveButtonFrame;
    self.saveButton.backgroundColor = [UIColor whiteColor];
    [self.saveButton setImage:[UIImage imageNamed:@"Add-Number"] forState:UIControlStateNormal];
    [self.saveButton setImage:[UIImage imageNamed:@"Checked"] forState:UIControlStateHighlighted];
    [self addSubview:self.saveButton];
    
    self.currentLocationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.currentLocationButton.frame = currentLocationButtonFrame;
    self.currentLocationButton.backgroundColor = [UIColor whiteColor];
    [self.currentLocationButton setImage:[UIImage imageNamed:@"Delete-Entered"] forState:UIControlStateNormal];
    [self.currentLocationButton setImage:[UIImage imageNamed:@"Checked"] forState:UIControlStateHighlighted];
    [self addSubview:self.currentLocationButton];
    
    self.listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.listButton.frame = listButtonFrame;
    self.listButton.backgroundColor = [UIColor whiteColor];
    [self.listButton setImage:[UIImage imageNamed:@"Delete"] forState:UIControlStateNormal];
    [self.listButton setImage:[UIImage imageNamed:@"Checked"] forState:UIControlStateHighlighted];
    [self addSubview:self.listButton];
}

@end
