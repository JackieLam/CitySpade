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

#define kPickerViewTextFont [UIFont fontWithName:@"Avenir-Roman" size:12.0f]
#define kPickerViewTextColor [UIColor colorWithRed:85.0/255.0 green:85.0/255.0 blue:85.0/255.0 alpha:1.0]
#define kHeadButtonTextInset UIEdgeInsetsMake(0, -16, 0, 0)
#define kHeadButtonImageInset UIEdgeInsetsMake(0, 48, 0, 0)
#define kHeadButtonHeight 20.0f
#define kPickViewHeight 15.0f

- (id)initWithFrame:(CGRect)frame withState:(BTPickerViewState)state withPickerViewData:(NSArray *)pickViewData withTableViewBlock:(VoidBlock)aTableViewBlock withCellBlock:(VoidBlock)aCellBlock
{
    self = [super initWithFrame:frame];
    if (self) {
        self.arrRecords = pickViewData;
        if (state == BTPickerViewStateMerged) {
            isPickerViewShowed = NO;
        }
        else{
            isPickerViewShowed = YES;
        }
        self.tableViewBlock = aTableViewBlock;
        self.cellBlock = aCellBlock;
        [self showPicker];
    }
    return self;
    
}
-(void)showPicker{
    self.backgroundColor = [UIColor clearColor];
    pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 100)];
    
    pickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//    pickerView.frame = CGRectMake(0.0, 0, self.frame.size.width, 100);
    
    pickerView.showsSelectionIndicator = YES;
    pickerView.delegate = self;
    pickerView.dataSource = self;
    [pickerView selectRow:self.arrRecords.count/2 inComponent:0 animated:YES];
    self.headerButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, self.frame.size.width, kHeadButtonHeight)];
    [self.headerButton setTitle:[self.arrRecords objectAtIndex:0] forState:UIControlStateNormal];
    self.headerButton.titleLabel.font = kPickerViewTextFont;
    [self.headerButton setTitleEdgeInsets:kHeadButtonTextInset];
    [self.headerButton setImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
    [self.headerButton setImageEdgeInsets:kHeadButtonImageInset];
    [self.headerButton setTitleColor:kPickerViewTextColor forState:UIControlStateNormal];
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
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.arrRecords.count;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self.headerButton setTitle:[self.arrRecords objectAtIndex:row] forState:UIControlStateNormal];
    [self clickButton];
    self.cellBlock();
    self.tableViewBlock();
}

- (UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, kPickViewHeight)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = [self.arrRecords objectAtIndex:row];
    label.font = kPickerViewTextFont;
    label.textColor = kPickerViewTextColor;
    return label;
}
- (float)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 15;
}
@end
