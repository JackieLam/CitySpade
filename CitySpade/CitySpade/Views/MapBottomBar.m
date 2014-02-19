//
//  MapBottomBar.m
//  CitySpade
//
//  Created by Cho-Yeung Lam on 3/2/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import "MapBottomBar.h"
//#import "KeyValueObserver.h"
#import <QuartzCore/QuartzCore.h>

@interface MapBottomBar()

@end

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
    CGRect saveButtonRect = CGRectMake(27, 16, 50, 23);
    CGRect drawButtonRect = CGRectMake(255, 16, 50, 23);
    CGRect tempImageViewRect = CGRectMake(126, 8, 72, 38);
//SaveButton
    self.saveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.saveButton.frame = saveButtonRect;
    self.saveButton.backgroundColor = [UIColor clearColor];
    [self.saveButton setTitle:@"Save" forState:UIControlStateNormal];
    [self.saveButton.titleLabel setFont:[UIFont fontWithName:@"Avenir-Roman" size:15.0f]];
    [self.saveButton setTitleColor:[UIColor colorWithRed:172.0/255.0 green:255.0/255.0 blue:250.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self addSubview:self.saveButton];
//DrawButton
    self.drawButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.drawButton.frame = drawButtonRect;
    self.drawButton.backgroundColor = [UIColor clearColor];
    self.drawButton.titleLabel.font = [UIFont fontWithName:@"Avenir-Roman" size:15.0f];
    [self.drawButton setTitle:@"Draw" forState:UIControlStateNormal];
    [self.drawButton setTitleColor:[UIColor colorWithRed:172.0/255.0 green:255.0/255.0 blue:250.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self addSubview:self.drawButton];
//SegmentControl
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
//CancelButton
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.cancelButton.frame = saveButtonRect;
    self.cancelButton.backgroundColor = [UIColor clearColor];
    [self.cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [self.cancelButton.titleLabel setFont:[UIFont fontWithName:@"Avenir-Roman" size:15.0f]];
    [self.cancelButton setTitleColor:[UIColor colorWithRed:172.0/255.0 green:255.0/255.0 blue:250.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    self.cancelButton.hidden = YES;
    [self addSubview:self.cancelButton];
//ClearButton
    self.clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.clearButton.frame = drawButtonRect;
    self.clearButton.backgroundColor = [UIColor clearColor];
    self.clearButton.titleLabel.font = [UIFont fontWithName:@"Avenir-Roman" size:15.0f];
    [self.clearButton setTitle:@"Clear" forState:UIControlStateNormal];
    [self.clearButton setTitleColor:[UIColor colorWithRed:172.0/255.0 green:255.0/255.0 blue:250.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    self.clearButton.hidden = YES;
    [self addSubview:self.clearButton];
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

- (void)resetBarState:(BarState)newState
{
    self.barState = newState;
    switch (self.barState) {
        case BarStateMapDefault:
        {
            self.saveButton.hidden = NO;
            self.drawButton.hidden = NO;
            self.cancelButton.hidden = YES;
            self.clearButton.hidden = YES;
            self.sortButton.hidden = YES;
        }
            break;
        case BarStateMapDraw:
        {
            self.saveButton.hidden = YES;
            self.drawButton.hidden = YES;
            self.cancelButton.hidden = NO;
            self.clearButton.hidden = NO;
            self.sortButton.hidden = YES;
        }
            break;
        case BarStateList:
        {
            self.saveButton.hidden = YES;
            self.drawButton.hidden = YES;
            self.cancelButton.hidden = YES;
            self.clearButton.hidden = YES;
            self.sortButton.hidden = NO;
        }
            break;
        
        default:
            break;
    }
}

#pragma mark - Automatic Property Notifications

//+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key
//{
//    NSSet *keys = [NSSet setWithObjects:@"segmentControl", @"saveButton", @"drawButton", @"clearButton", @"cancelButton", @"sortButton", nil];
//    if ([keys containsObject:key])
//        return [NSSet setWithObject:@"barState"];
//    else
//        return nil;
//}

@end
