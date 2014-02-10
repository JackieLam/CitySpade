//
//  MapBottomBar.m
//  CitySpade
//
//  Created by Cho-Yeung Lam on 3/2/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import "MapBottomBar.h"
#import <QuartzCore/QuartzCore.h>

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
    
    self.segmentControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:[UIImage imageNamed:@"map_selected"], [UIImage imageNamed:@"list_unselected"], nil]];
    self.segmentControl.tintColor = [UIColor redColor];
    self.segmentControl.frame = tempImageViewRect;
    self.segmentControl.selectedSegmentIndex = 0;
    self.segmentControl.layer.cornerRadius = 20.0f;
    self.segmentControl.contentMode = UIViewContentModeScaleAspectFit;
    [self.segmentControl setBackgroundImage:[UIImage imageNamed:@"segment_unselected_bg"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.segmentControl setBackgroundImage:[UIImage imageNamed:@"segment_selected_bg"] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    [self.segmentControl setBackgroundImage:[UIImage imageNamed:@"segment_selected_bg"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    [self.segmentControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.segmentControl];
}

-(void)segmentAction:(UISegmentedControl*)sender
{
    if (sender.selectedSegmentIndex == 0) {
        [sender setImage:[UIImage imageNamed:@"map_selected"] forSegmentAtIndex:0];
        [sender setImage:[UIImage imageNamed:@"list_unselected"] forSegmentAtIndex:1];
    }
    else {
        [sender setImage:[UIImage imageNamed:@"map_unselected"] forSegmentAtIndex:0];
        [sender setImage:[UIImage imageNamed:@"list_selected"] forSegmentAtIndex:1];
    }
}

@end
