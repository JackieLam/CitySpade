//
//  BTPickerView.h
//  CitySpade
//
//  Created by Alaysh on 4/29/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, BTPickerViewState) {
    BTPickerViewStateMerged,
    BTPickerViewStateExpended
};
typedef void(^VoidBlock)(void);
@interface BTPickerView : UIView<UIActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UISearchBarDelegate>{
    
    UIPickerView *pickerView;
    UIToolbar *picketToolbar;
    UISearchBar *txtSearch;
    NSArray *arrRecords;
    UIActionSheet *aac;
    NSMutableArray *copyListOfItems;
    BOOL searching;
	BOOL letUserSelectRow;
    
    BOOL isPickerViewShowed;
}


@property (nonatomic, retain) NSArray *arrRecords;
@property (nonatomic, strong) UIButton *headerButton;
@property (nonatomic, strong) VoidBlock tableViewBlock;
@property (nonatomic, strong) VoidBlock cellBlock;
- (id)initWithFrame:(CGRect)frame withState:(BTPickerViewState)state
                                  withPickerViewData:(NSArray*)pickViewData
                                  withTableViewBlock:(VoidBlock)aTableViewBlock
                                  withCellBlock:(VoidBlock)aCellBlock;
- (void)showPicker;

@end
