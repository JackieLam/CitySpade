//
//  CityPopoverView.h
//  CitySpade
//
//  Created by Alaysh on 7/4/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^CitySelectedBlock)(NSInteger index);
@interface CityPopoverView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *cityTableView;
@property (nonatomic, strong) NSArray *cityArray;
@property (nonatomic, strong) UIButton *touchView;
@property (nonatomic, strong) CitySelectedBlock citySelectedBlock;
- (id)initWithFrame:(CGRect)frame withCitys:(NSArray*)cityArray withBlock:(CitySelectedBlock)aCitySelectedBlock;
- (void)reloadWithCities:(NSArray *)cities;
- (void)pushInCityTableView;
- (void)pushOutCityTableView;
@end
