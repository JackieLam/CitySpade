//
//  BTPickerView.m
//  CitySpade
//
//  Created by Alaysh on 4/29/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import "BTPickerView.h"

@implementation BTPickerView
@synthesize arrRecords;


- (id)initWithFrame:(CGRect)frame withState:(BTPickerViewState)state{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.arrRecords = [NSArray arrayWithObjects:@"Any",@"0+",@"1+",@"2+",@"3+",@"4+",@"5+",@"6+",@"7+",
                           @"8+",@"9+", nil];
        if (state == BTPickerViewStateMerged) {
            isPickerViewShowed = NO;
        }
        else{
            isPickerViewShowed = YES;
        }
        [self showPicker];
    }
    return self;
    
}
-(void)showPicker{
    self.backgroundColor = [UIColor clearColor];
    pickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
    
    pickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    pickerView.frame = CGRectMake(0.0, 0, self.frame.size.width, 100);
    
    pickerView.showsSelectionIndicator = YES;
    pickerView.delegate = self;
    pickerView.dataSource = self;
    [pickerView selectRow:self.arrRecords.count/2 inComponent:0 animated:YES];
    self.headerButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, self.frame.size.width, 20)];
    [self.headerButton setTitle:@"Any" forState:UIControlStateNormal];
    [self.headerButton setFont:[UIFont fontWithName:@"Avenir-Roman" size:12.0f]];
    [self.headerButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -22, 0, 0)];
    [self.headerButton setImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
    [self.headerButton setImageEdgeInsets:UIEdgeInsetsMake(0, 40, 0, 0)];
    [self.headerButton setTitleColor:[UIColor colorWithRed:85.0/255.0 green:85.0/255.0 blue:85.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.headerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.headerButton addTarget:self action:@selector(clickButton) forControlEvents:UIControlEventTouchUpInside];
    
    if (isPickerViewShowed) {
        [self addSubview:pickerView];
    }
    [self addSubview:self.headerButton];
    
}

- (void)clickButton
{
    isPickerViewShowed = !isPickerViewShowed;
    CGRect rect = [self frame];
    if (isPickerViewShowed) {
        rect.size.height += pickerView.frame.size.height;
        rect.size.height -= 10;
        if (![pickerView superview]) {
            [self addSubview:pickerView];
            [self.headerButton removeFromSuperview];
            [self addSubview:self.headerButton];
        }
        [self setFrame:rect];
    }
    else{
        rect.size.height -= pickerView.frame.size.height;
        rect.size.height += 10;
        if ([pickerView superview]) {
            [pickerView removeFromSuperview];
        }
        [self setFrame:rect];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.arrRecords.count;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    [self.headerButton setTitle:[self.arrRecords objectAtIndex:row] forState:UIControlStateNormal];
    //    [self.headerButton setTitle:[self.arrRecords objectAtIndex:row] forState:UIControlStateSelected];
    //    [self.headerButton setTitle:[self.arrRecords objectAtIndex:row] forState:UIControlStateReserved];
    //    [self.headerButton setTitle:[self.arrRecords objectAtIndex:row] forState:UIControlStateApplication];
    //    [self.headerButton setTitle:[self.arrRecords objectAtIndex:row] forState:UIControlStateDisabled];
    //    [self.headerButton setTitle:[self.arrRecords objectAtIndex:row] forState:UIControlStateHighlighted];
    //    [self.headerButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    //    [self.headerButton setImageEdgeInsets:UIEdgeInsetsMake(0, 54, 0, 0)];
    NSLog(@"title:%@",[self.arrRecords objectAtIndex:row]);
    NSLog(@"%d",self.headerButton.state);
}
- (UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 15)];
    label.textAlignment = UITextAlignmentCenter;
    label.text = [self.arrRecords objectAtIndex:row];
    label.font = [UIFont fontWithName:@"Avenir-Roman" size:12.0f];
    label.textColor = [UIColor colorWithRed:85.0/255.0 green:85.0/255.0 blue:85.0/255.0 alpha:1.0];
    return label;
}
- (float)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 15;
}
@end
