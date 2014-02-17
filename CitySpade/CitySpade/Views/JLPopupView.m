//
//  JLPopupView.m
//  CitySpade
//
//  Created by Cho-Yeung Lam on 22/1/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import "JLPopupView.h"

@implementation JLPopupView {
    UILabel *textLabel;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *popupImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sliderlabel.png"]];
        [self addSubview:popupImageView];
        
        textLabel = [[UILabel alloc] init];
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.textColor = [UIColor blackColor];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.frame = CGRectMake(0, -2.0f, popupImageView.frame.size.width, popupImageView.frame.size.height);
        [self addSubview:textLabel];
    }
    return self;
}

-(void)setValue:(float)aValue {
    _value = aValue;
    self.text = [NSString stringWithFormat:@"%4.2f", _value];
    textLabel.text = self.text;
    [self setNeedsDisplay];
}

@end
