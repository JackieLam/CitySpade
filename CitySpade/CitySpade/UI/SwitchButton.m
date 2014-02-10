//
//  SwitchButton.m
//  CitySpade
//
//  Created by Cho-Yeung Lam on 10/2/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import "SwitchButton.h"

@implementation SwitchButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.mapButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGRect mapButtonFrame = frame;
        mapButtonFrame.size.width = frame.size.width * 0.5;
        self.mapButton.frame = mapButtonFrame;
        
        self.listButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGRect listButtonFrame = frame;
        listButtonFrame.size.width = frame.size.width * 0.5;
        listButtonFrame.origin.x = mapButtonFrame.size.width;
        self.listButton.frame = listButtonFrame;
        
    }
    return self;
}

@end
