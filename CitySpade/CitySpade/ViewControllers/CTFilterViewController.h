//
//  CTFilterViewController.h
//  CitySpade
//
//  Created by Cho-Yeung Lam on 22/1/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTFilterViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    NSArray *cellArray;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *applyButton;
@end
