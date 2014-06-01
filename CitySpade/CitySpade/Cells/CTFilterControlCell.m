//
//  CTFilterControlCell.m
//  CitySpade
//
//  Created by Alaysh on 4/29/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import "CTFilterControlCell.h"
#import "NMRangeSlider.h"
#import "BedSegment.h"
#import "BTPickerView.h"
#import "ANPopoverView.h"

#define thisBackgroundColor [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1.0f]
#define titleFont [UIFont fontWithName:@"Avenir-Roman" size:15.0f]
#define titleTextColor [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0f]
#define CTFilterCellPriceHeight 194.0/2
#define CTFilterCellBargainHeight 126.0f/2
#define CTFilterCellTransportationHeight 126.0f/2
#define CTFilterCellBedroomHeight 164.0f/2
#define CTFilterCellBathroomHeight 164.0f/2
#define BackGroundViewX 20.0f/2
#define BackGroundViewY 64.0f/2
#define BackGroundViewWidth 500.0f/2
#define BackGroundViewFrame CGRectMake(20.0f/2,65.0f/2,500.0f/2,0)
#define greenColor [UIColor colorWithRed:41.0/255.0 green:188.0/255.0 blue:184.0/255.0 alpha:1.0f]
#define MerGedRect CGRectMake(0, 0, 320, 63.0f)
#define ExpendedRect CGRectMake(0, 0, 320, 175.5f)
#define saleMaxValue 12000000
#define rentMaxValue 12000
#define BedSegmentRect CGRectMake(15, 41, 240, 36)
#define PickerViewRect CGRectMake(10, 30, 249, 240)
#define CellWidth 320.0f
#define Changedheight 112.0f
#define popoverViewCenter CGPointMake(92.75, 43.0)

@implementation CTFilterControlCell

- (id)initWithStyle:(CTFilterCellStyle)style withTableViewBlock:(VoidBlock)aTableViewBlock
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.contentView.backgroundColor = thisBackgroundColor;
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 20.0f/2, 100.0f, 17.0f)];
        [titleLabel setTextColor:titleTextColor];
        [titleLabel setFont:titleFont];
        CGRect rect = BackGroundViewFrame;
        self.backGroundView = [[UIImageView alloc] initWithFrame:BackGroundViewFrame];
        self.backGroundView.userInteractionEnabled = NO;
        [self.contentView addSubview:self.backGroundView];
        switch (style) {
            case CTFilterCellStylePrice:
                [titleLabel setText:@"Price Range"];
                rect.size.height = CTFilterCellPriceHeight - BackGroundViewY;
                self.backGroundView.image = [UIImage imageNamed:@"1white_bg"];
                [self.backGroundView setFrame:rect];
                [self setSliderWithMaxValue:rentMaxValue minValue:0];
                self.popoverView.center = popoverViewCenter;
                break;
            case CTFilterCellStyleBargain:{
                [titleLabel setText:@"Cost-Efficiency"];
                rect.size.height = CTFilterCellBargainHeight - BackGroundViewY;
                self.backGroundView.image = [UIImage imageNamed:@"2white_bg"];
                [self.backGroundView setFrame:rect];
                NSArray *pickerViewData = [NSArray arrayWithObjects:@"Any",@"1+",@"2+",@"3+",@"4+",@"5+",@"6+",@"7+",
                                           @"8+",@"9+", nil];
                
                self.bargainPickerView = [[BTPickerView alloc] initWithFrame:PickerViewRect withState:BTPickerViewStateMerged withPickerViewData:pickerViewData withTableViewBlock:aTableViewBlock withCellBlock:^{
                    [self changeViewHeight];
                }];
                [self.bargainPickerView.headerButton addTarget:self action:@selector(changeViewHeight) forControlEvents:UIControlEventTouchUpInside];
                [self.contentView addSubview:self.bargainPickerView];
                isMerged = YES;
            }
                break;
            case CTFilterCellStyleTransportation:{
                [titleLabel setText:@"Transportation"];
                rect.size.height = CTFilterCellTransportationHeight - BackGroundViewY;
                self.backGroundView.image = [UIImage imageNamed:@"2white_bg"];
                [self.backGroundView setFrame:rect];
                NSArray *pickerViewData = [NSArray arrayWithObjects:@"Any",@"1+",@"2+",@"3+",@"4+",@"5+",@"6+",@"7+",
                                           @"8+",@"9+", nil];
                self.transportationPickerView = [[BTPickerView alloc] initWithFrame:PickerViewRect withState:BTPickerViewStateMerged withPickerViewData:pickerViewData withTableViewBlock:aTableViewBlock withCellBlock:^{
                    [self changeViewHeight];
                }];
                [self.transportationPickerView.headerButton addTarget:self action:@selector(changeViewHeight) forControlEvents:UIControlEventTouchUpInside];
                [self.contentView addSubview:self.transportationPickerView];
                isMerged = YES;
            }
                break;
            case CTFilterCellStyleBedroom:{
                [titleLabel setText:@"Bedrooms"];
                rect.size.height = CTFilterCellBedroomHeight - BackGroundViewY;
                self.backGroundView.image = [UIImage imageNamed:@"2white_bg"];
                [self.backGroundView setFrame:rect];
                self.bedSegmentControl = [[BedSegment alloc] initWithItems:@[@"Any", @"1", @"2", @"3", @"4+"]];
                self.bedSegmentControl.frame = CGRectMake(15, 41, 240, 36);
                NSDictionary *attributes1 = @{NSFontAttributeName: [UIFont fontWithName:@"Avenir-Roman" size:12.0f], NSForegroundColorAttributeName: greenColor};
                NSDictionary *attributes2 = @{NSFontAttributeName: [UIFont fontWithName:@"Avenir-Roman" size:12.0f], NSForegroundColorAttributeName: [UIColor whiteColor]};
                [self.bedSegmentControl setTitleTextAttributes:attributes1 forState:UIControlStateNormal];
                [self.bedSegmentControl setTitleTextAttributes:attributes2 forState:UIControlStateSelected];
                [self.bedSegmentControl setSelectedSegmentIndex:0];
                [self.contentView addSubview:self.bedSegmentControl];
            }
                break;
            case CTFilterCellStyleBathroom:
                [titleLabel setText:@"Bathrooms"];{
                    rect.size.height = CTFilterCellBathroomHeight - BackGroundViewY;
                    self.backGroundView.image = [UIImage imageNamed:@"2white_bg"];
                    [self.backGroundView setFrame:rect];
                    
                    self.bathSegmentControl = [[BedSegment alloc] initWithItems:@[@"Any", @"1", @"2", @"3", @"4+"]];
                    self.bathSegmentControl.frame = CGRectMake(15, 41, 240, 36);
                    NSDictionary *attributes1 = @{NSFontAttributeName: [UIFont fontWithName:@"Avenir-Roman" size:12.0f], NSForegroundColorAttributeName: greenColor};
                    NSDictionary *attributes2 = @{NSFontAttributeName: [UIFont fontWithName:@"Avenir-Roman" size:12.0f], NSForegroundColorAttributeName: [UIColor whiteColor]};
                    [self.bathSegmentControl setTitleTextAttributes:attributes1 forState:UIControlStateNormal];
                    [self.bathSegmentControl setTitleTextAttributes:attributes2 forState:UIControlStateSelected];
                    [self.bathSegmentControl setSelectedSegmentIndex:0];
                    [self.contentView addSubview:self.bathSegmentControl];
                }
                break;
            case CTFilterCellStyleSegment:{
                rect.size.height = 10.0f;
                UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 270+10, 35)];
                self.rentSegmentControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"For Sale", @"For Rent", nil]];
                self.rentSegmentControl.backgroundColor = [UIColor whiteColor];
                [self.rentSegmentControl setFrame:CGRectMake(-3, 3, 270 + 6, 30)];
                [self.rentSegmentControl setSelectedSegmentIndex:0];
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"AvenirNext-DemiBold"size:12.5],NSFontAttributeName ,[UIColor colorWithRed:41/255.0 green:188/255.0 blue:184/255.0 alpha:1.0],NSForegroundColorAttributeName, nil];
                [self.rentSegmentControl setTitleTextAttributes:dic forState:UIControlStateNormal];
                [self.rentSegmentControl setContentOffset:CGSizeMake(2, 2) forSegmentAtIndex:0];
                [self.rentSegmentControl setContentOffset:CGSizeMake(-2, 2) forSegmentAtIndex:1];
                //segmentControl backFroundView
                UISegmentedControl *bcg = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@" ", @" ", nil]];
                [self.rentSegmentControl setTintColor:[UIColor colorWithRed:41/255.0 green:188/255.0 blue:184/255.0 alpha:1.0]];
                [bcg setFrame:CGRectMake(-3, 3, 270 + 6, 30)];
                [bcg setTintColor:[UIColor colorWithRed:0.9294 green:0.9294 blue:0.9294 alpha:1.0]];
                [bcg setUserInteractionEnabled:NO];
                [bcg setImage:nil forSegmentAtIndex:0];
                [header addSubview:self.rentSegmentControl];
                [header addSubview:bcg];
//                header.backgroundColor = [UIColor whiteColor];
                [self.contentView addSubview:header];
            }
                break;
            default:
                break;
        }
        [self.contentView addSubview:titleLabel];
        
        CGRect cellRect = CGRectMake(0, 0, CellWidth, rect.size.height+BackGroundViewY);
        [self setFrame:cellRect];
    }
    return self;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)changeViewHeight
{
    isMerged = !isMerged;
    CGRect rect = self.frame;
    CGRect bRect = self.backGroundView.frame;
    if (isMerged) {
        rect.size.height -= Changedheight;
        bRect.size.height -= Changedheight;
    }
    else{
        rect.size.height += Changedheight;
        bRect.size.height += Changedheight;
    }
    [self.backGroundView setFrame:bRect];
    [self setFrame:rect];
}

- (void)setSliderWithMaxValue:(float)maxValue minValue:(float)minValue
{
    if (!self.popoverView) {
        self.popoverView = [[ANPopoverView alloc] initWithFrame:CGRectZero];
        self.popoverView.backgroundColor = [UIColor clearColor];
    }
    if (!self.rangeSlider) {
        self.rangeSlider = [[NMRangeSlider alloc] initWithFrame:CGRectMake(28, 63, 200, 20)];
        UIImage* image = nil;
        
        image = [UIImage imageNamed:@"slider_bg"];
        //    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)];
        self.rangeSlider.trackBackgroundImage = image;
        
        image = [UIImage imageNamed:@"slider_highlight_bg"];
        //    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 7.0, 0.0, 7.0)];
        self.rangeSlider.trackImage = image;
        
        image = [UIImage imageNamed:@"slider_handle"];
        self.rangeSlider.lowerHandleImageNormal = image;
        self.rangeSlider.upperHandleImageNormal = image;
        
        image = [UIImage imageNamed:@"slider_handle"];
        self.rangeSlider.lowerHandleImageHighlighted = image;
        self.rangeSlider.upperHandleImageHighlighted = image;
        [self.rangeSlider addTarget:self action:@selector(updateRangeLabel:) forControlEvents:UIControlEventValueChanged];
    }
    
    
    self.rangeSlider.minimumValue = minValue;
    self.rangeSlider.maximumValue = maxValue;
    
    self.rangeSlider.lowerValue = self.rangeSlider.minimumValue;
    self.rangeSlider.upperValue = self.rangeSlider.maximumValue;
    
    
    //    self.rangeSlider.minimumRange = 1000;
    
    [self updateRangeLabel:self.rangeSlider];
    if (![self.popoverView superview]) {
        [self.contentView addSubview:self.popoverView];
    }
    if (![self.rangeSlider superview]) {
        [self.contentView addSubview:self.rangeSlider];
    }
    
}

- (void)updateRangeLabel:(NMRangeSlider *)slider
{
    CGPoint lowerCenter;
    lowerCenter.x = slider.lowerCenter.x;
    lowerCenter.y = slider.center.y - 30.0f;
    CGPoint upperCenter;
    upperCenter.x = slider.upperCenter.x;
    upperCenter.y = slider.center.y - 30.0f;
    CGPoint middleCenter;
    middleCenter.x = (lowerCenter.x + upperCenter.x) * 0.5;
    middleCenter.y = lowerCenter.y;
    self.popoverView.center = middleCenter;
    int type = 0;
    if (slider.upperValue > rentMaxValue) {
        type = 1;
    }
    int upperValue = [slider getChangedUpperValueWithType:type];
    int lowerValue = [slider getChangedLowerValueWithType:type];
    NSMutableString *upperValueString;
    NSMutableString *lowerValueString;
    if (type == 1) {
        if (upperValue / 1000000 > 0) {
            upperValueString = [NSMutableString stringWithFormat:@"%.2fM",upperValue/1000000.0f];
        }
        else{
            upperValueString = [NSMutableString stringWithFormat:@"%dK",upperValue/1000];
        }
        if (lowerValue / 1000000 > 0) {
            lowerValueString = [NSMutableString stringWithFormat:@"%.2fM",lowerValue/1000000.0f];
        }
        else{
            lowerValueString = [NSMutableString stringWithFormat:@"%dK",lowerValue/1000];
        }
    }
    else{
        upperValueString = [NSMutableString stringWithFormat:@"%d",upperValue];
        if (upperValue >= 1000 ) {
            [upperValueString insertString:@"," atIndex:upperValueString.length-3];
        }
        lowerValueString = [NSMutableString stringWithFormat:@"%d",lowerValue];
        if (lowerValue >= 1000) {
            [lowerValueString insertString:@"," atIndex:lowerValueString.length-3];
        }
    }
    if ((int)slider.lowerValue == 0) {
        if ((type == 0 && (int)slider.upperValue == rentMaxValue) || (type == 1 && (int)slider.upperValue == saleMaxValue)) {
            self.popoverView.textLabel.text = @"Any Price";
        }
        else{
            self.popoverView.textLabel.text = [NSString stringWithFormat:@"$%@ or less", upperValueString];
        }
    }
    else if((type == 0 && (int)slider.upperValue == rentMaxValue) || (type == 1 && (int)slider.upperValue == saleMaxValue)){
        self.popoverView.textLabel.text = [NSString stringWithFormat:@"$%@ or more", lowerValueString];
    }
    else{
        self.popoverView.textLabel.text = [NSString stringWithFormat:@"$%@ - $%@", lowerValueString,upperValueString];
    }
}

- (NSString*)selectedItem
{
    if (self.bargainPickerView) {
        return self.bargainPickerView.headerButton.titleLabel.text;
    }
    else if (self.transportationPickerView){
        return self.transportationPickerView.headerButton.titleLabel.text;
    }
    else if(self.bedSegmentControl){
        return [self.bedSegmentControl titleForSegmentAtIndex:self.bedSegmentControl.selectedSegmentIndex];
    }
    else if(self.bathSegmentControl){
        return [self.bathSegmentControl titleForSegmentAtIndex:self.bathSegmentControl.selectedSegmentIndex];
    }
    else{
        return [NSString stringWithFormat:@"%d",self.rentSegmentControl.selectedSegmentIndex];
    }
}

- (NSDictionary*)getSliderRangeValue
{
    if (self.rangeSlider) {
        NSString *lowerValueString;
        NSString *upperValueString;
        int type = 0;
        if (self.rangeSlider.maximumValue > rentMaxValue) {
            type = 1;
        }
        lowerValueString = [NSString stringWithFormat:@"%d",[self.rangeSlider getChangedLowerValueWithType:type]];
        if ((type == 0 && self.rangeSlider.upperValue == rentMaxValue) || (type == 1 && self.rangeSlider.upperValue == saleMaxValue)) {
            upperValueString = @"-1";
        }
        else{
            upperValueString = [NSString stringWithFormat:@"%d",[self.rangeSlider getChangedUpperValueWithType:type]];
        }
        NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[lowerValueString,upperValueString]  forKeys:@[@"lowerBound",@"higherBound"]];
        return dic;
    }
    return nil;
}

- (void)resetControl
{
    if (self.rangeSlider) {
        if (self.rangeSlider.maximumValue > rentMaxValue) {
            [self setSliderWithMaxValue:saleMaxValue minValue:0];
        }
        else
            [self setSliderWithMaxValue:rentMaxValue minValue:0];
        self.popoverView.center = popoverViewCenter;
    }
    if (self.bargainPickerView) {
        [self.bargainPickerView.headerButton setTitle:@"Any" forState:UIControlStateNormal];
    }
    if (self.transportationPickerView) {
        [self.transportationPickerView.headerButton setTitle:@"Any" forState:UIControlStateNormal];
    }
    if (self.bedSegmentControl) {
        [self.bedSegmentControl setSelectedSegmentIndex:0];
    }
    if (self.bathSegmentControl) {
        [self.bathSegmentControl setSelectedSegmentIndex:0];
    }
    if (self.rentSegmentControl) {
        [self.rentSegmentControl setSelectedSegmentIndex:0];
    }
}

@end
