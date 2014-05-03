//
//  MapBottomBar.m
//  CitySpade
//
//  Created by Cho-Yeung Lam on 3/2/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import "MapBottomBar.h"
#import "SwitchSegment.h"
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
#warning 暂时取消Save Button
    [self.saveButton setTitle:@" " forState:UIControlStateNormal];
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
    NSArray *items = @[@" ",@" "];
    self.segmentControl = [[SwitchSegment alloc] initWithItems:items];
    [self.segmentControl setFrame:tempImageViewRect];
    [self.segmentControl setImage:[UIImage imageNamed:@"map_selected"] forSegmentAtIndex:0];
    [self.segmentControl setImage:[UIImage imageNamed:@"list_unselected"] forSegmentAtIndex:1];
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
//SortButton
    self.sortButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sortButton.frame = drawButtonRect;
    self.sortButton.backgroundColor = [UIColor clearColor];
    self.sortButton.titleLabel.font = [UIFont fontWithName:@"Avenir-Roman" size:15.0f];
    [self.sortButton setTitle:@"Sort" forState:UIControlStateNormal];
    [self.sortButton setTitleColor:[UIColor colorWithRed:172.0/255.0 green:255.0/255.0 blue:250.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    self.sortButton.hidden = YES;
    [self addSubview:self.sortButton];
}

//-(void)segmentAction:(UISegmentedControl*)sender
//{
//    if (sender.selectedSegmentIndex == 0) {
//        [sender setImage:[UIImage imageNamed:@"map_selected"] forSegmentAtIndex:0];
//        [sender setImage:[UIImage imageNamed:@"list_unselected"] forSegmentAtIndex:1];
//    }
//    else {
//        [sender setImage:[UIImage imageNamed:@"map_unselected"] forSegmentAtIndex:0];
//        [sender setImage:[UIImage imageNamed:@"list_selected"] forSegmentAtIndex:1];
//    }
//}

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
            self.segmentControl.hidden = NO;
        }
            break;
        case BarStateMapDraw:
        {
            self.saveButton.hidden = YES;
            self.drawButton.hidden = YES;
            self.cancelButton.hidden = NO;
            self.clearButton.hidden = NO;
            self.sortButton.hidden = YES;
            self.segmentControl.hidden = YES;
        }
            break;
        case BarStateList:
        {
            self.saveButton.hidden = YES;
            self.drawButton.hidden = YES;
            self.cancelButton.hidden = YES;
            self.clearButton.hidden = YES;
            self.sortButton.hidden = NO;
            self.segmentControl.hidden = NO;
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
