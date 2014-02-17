//
//  ANPopoverView.m
//  CustomSlider
//
//  Created by Gabriel  on 30/1/13.
//  Copyright (c) 2013 App Ninja. All rights reserved.
//

#import "ANPopoverView.h"

@implementation ANPopoverView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.font = [UIFont boldSystemFontOfSize:15.0f];
        
        UIImageView *popoverView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"slider_label"]];
        [self addSubview:popoverView];
        
        self.textLabel = [[UILabel alloc] init];
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.font = [UIFont fontWithName:@"Avenir-Black" size:11.0f];
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.text = self.text;
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.frame = CGRectMake(0, -2.0f, popoverView.frame.size.width, popoverView.frame.size.height);
        [self addSubview:self.textLabel];
        
    }
    return self;
}

-(void)setValue:(float)aValue {
    _value = aValue;
    self.text = [NSString stringWithFormat:@"%4.2f", _value];
    self.textLabel.text = self.text;
    [self setNeedsDisplay];
}

@end
