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
#define CTFilterCellTransportationHeight 356.0f/2
#define CTFilterCellBedroomHeight 164.0f/2
#define CTFilterCellBathroomHeight 164.0f/2
#define BackGroundViewX 20.0f/2
#define BackGroundViewY 64.0f/2
#define BackGroundViewWidth 500.0f/2
#define BackGroundViewFrame CGRectMake(20.0f/2,65.0f/2,500.0f/2,0)
#define greenColor [UIColor colorWithRed:41.0/255.0 green:188.0/255.0 blue:184.0/255.0 alpha:1.0f]
#define MerGedRect CGRectMake(0, 0, 320, 63.0f)
#define ExpendedRect CGRectMake(0, 0, 320, 175.5f)
#define saleMaxValue 120000000
#define rentMaxValue 120000


@implementation CTFilterControlCell

- (id)initWithStyle:(CTFilterCellStyle)style
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.contentView.backgroundColor = thisBackgroundColor;
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 20.0f/2, 100.0f, 17.0f)];
        [titleLabel setTextColor:titleTextColor];
        [titleLabel setFont:titleFont];
        CGRect rect = BackGroundViewFrame;
        //        self.backGroundView = [[UIImageView alloc] initWithFrame:BackGroundViewFrame];
        //        self.backGroundView.backgroundColor = [UIColor clearColor];
        //        self.backGroundView.image = [UIImage imageNamed:@"2white_bg"];
        self.backGroundView = [[UIImageView alloc] initWithFrame:BackGroundViewFrame];
//        self.backGroundView.backgroundColor = [UIColor whiteColor];
        self.backGroundView.userInteractionEnabled = NO;
        [self.contentView addSubview:self.backGroundView];
        switch (style) {
            case CTFilterCellStylePrice:
                [titleLabel setText:@"Price Range"];
                rect.size.height = CTFilterCellPriceHeight - BackGroundViewY;
                self.backGroundView.image = [UIImage imageNamed:@"1white_bg"];
                [self.backGroundView setFrame:rect];
                [self setSliderWithMaxValue:120000 minValue:0];
                break;
            case CTFilterCellStyleBargain:{
                [titleLabel setText:@"Bargain(Price)"];
                rect.size.height = CTFilterCellBargainHeight - BackGroundViewY;
                self.backGroundView.image = [UIImage imageNamed:@"2white_bg"];
                [self.backGroundView setFrame:rect];
                self.bargainPickerView = [[BTPickerView alloc] initWithFrame:CGRectMake(15, 30, 240, 240) withState:BTPickerViewStateMerged];
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
                self.transportationPickerView = [[BTPickerView alloc] initWithFrame:CGRectMake(15, 30, 240, 240) withState:BTPickerViewStateExpended];
                [self.transportationPickerView.headerButton addTarget:self action:@selector(changeViewHeight) forControlEvents:UIControlEventTouchUpInside];
                [self.contentView addSubview:self.transportationPickerView];
                isMerged = NO;
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
            default:
                break;
        }
        [self.contentView addSubview:titleLabel];
        
        CGRect cellRect = CGRectMake(0, 0, 320, rect.size.height+BackGroundViewY);
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
        rect.size.height -= 112;
        bRect.size.height -= 112;
    }
    else{
        rect.size.height += 112;
        bRect.size.height += 112;
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
//    NSLog(@"slider.lowerCenter -- %f upperCenter -- %f", slider.lowerCenter.x, slider.upperCenter.x);
    lowerCenter.y = slider.center.y - 30.0f;
    CGPoint upperCenter;
    upperCenter.x = slider.upperCenter.x;
    upperCenter.y = slider.center.y - 30.0f;
    CGPoint middleCenter;
    middleCenter.x = (lowerCenter.x + upperCenter.x) * 0.5;
    middleCenter.y = lowerCenter.y;
    self.popoverView.center = middleCenter;
    
    if (slider.upperValue > rentMaxValue) {
        // It is in the for sale status
        self.popoverView.textLabel.text = [NSString stringWithFormat:@"$%dM - %dM", (int)slider.lowerValue/1000000, (int)slider.upperValue/1000000];
    }
    else {
        // It is in the for rent status
        self.popoverView.textLabel.text = [NSString stringWithFormat:@"$%d - %d", (int)slider.lowerValue, (int)slider.upperValue];
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
    else{
        return [self.bathSegmentControl titleForSegmentAtIndex:self.bathSegmentControl.selectedSegmentIndex];
    }
}

- (void)resetControl
{
    if (self.rangeSlider) {
        if (self.rangeSlider.upperValue > rentMaxValue) {
            [self setSliderWithMaxValue:saleMaxValue minValue:0];
        }
        else
            [self setSliderWithMaxValue:rentMaxValue minValue:0];
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
}
@end
