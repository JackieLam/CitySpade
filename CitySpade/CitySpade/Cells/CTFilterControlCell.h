//
//  CTFilterControlCell.h
//  CitySpade
//
//  Created by Alaysh on 4/29/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ANPopoverView;
@class NMRangeSlider;
@class BTPickerView;
@class BedSegment;
typedef NS_ENUM(NSInteger, CTFilterCellStyle) {
    CTFilterCellStylePrice,
    CTFilterCellStyleBargain,
    CTFilterCellStyleTransportation,
    CTFilterCellStyleBedroom,
    CTFilterCellStyleBathroom,
    CTFilterCellStyleSegment
};
typedef void(^VoidBlock)(void);

@interface CTFilterControlCell : UITableViewCell
{
    BOOL isMerged;
}
@property (nonatomic, strong) UIImageView *backGroundView;
@property (nonatomic, strong) ANPopoverView *popoverView;
@property (nonatomic, strong) NMRangeSlider *rangeSlider;
@property (nonatomic, strong) BTPickerView *bargainPickerView;
@property (nonatomic, strong) BTPickerView *transportationPickerView;
@property (nonatomic, strong) BedSegment *bedSegmentControl;
@property (nonatomic, strong) BedSegment *bathSegmentControl;
@property (nonatomic, strong) UISegmentedControl *rentSegmentControl;
- (id)initWithStyle:(CTFilterCellStyle)style withTableViewBlock:(VoidBlock)aTableViewBlock;
- (NSString*)selectedItem;
- (NSDictionary*)getSliderRangeValue;
- (void)setSliderWithMaxValue:(float)maxValue minValue:(float)minValue;
- (void)resetControl;
@end
