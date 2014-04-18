//
//  SortTableView.h
//  CitySpade
//
//  Created by Cho-Yeung Lam on 18/4/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    PRICE_HIGH_LOW,
    PRICE_LOW_HIGH,
    BARGAIN_HIGH_LOW,
    BARGAIN_LOW_HIGH,
    TRANSPORT_HIGH_LOW,
    TRANSPORT_LOW_HIGH,
} SortOption;

@protocol SortTableViewDelegate <NSObject>

- (void)sortTableViewDidSelectOption:(SortOption)option;

@end

@interface SortTableView : UITableView

@property (nonatomic, weak) id<SortTableViewDelegate> sortDelegate;

- (id)initWithFrame:(CGRect)frame delegate:(id)delegate;

@end
