//
//  CTListView.h
//  CitySpade
//
//  Created by Cho-Yeung Lam on 23/1/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import <UIKit/UIKit.h>

//FIXME: change it to inherit from UIView
@interface CTListView : UITableView

@property (nonatomic, strong) NSArray *places;
@property (nonatomic, strong) UILabel *totalCountLabel;

- (void)loadPlacesToListAndReloadData:(NSArray *)places;

@end
