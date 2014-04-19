//
//  CitySpadeCell.h
//  CitySpadeDemo
//
//  Created by izhuxin on 14-3-19.
//  Copyright (c) 2014年 Jeason. All rights reserved.
//

@import UIKit;
@class BaseClass;

typedef NS_ENUM(NSUInteger, InfoTitles) {
    Basic_Facts,
    Transportation_Info,
    Broker_Info,
    Nearby,
    Subway_Lines,
    Bus_lines,
    Hottest_Spots,
    Colleages,
};

@interface CitySpadeCell : UITableViewCell

@property(nonatomic, weak)BaseClass *list;

//abstract basic class for CitySpadeCell Cluster, you should never get an instance expect calling the menthod below
+ (instancetype)TabelCellWithInfoTitle: (InfoTitles)title;

//overidded this method for those classs inherit from CitySpadeCell
- (void)ConfigureCellWithItem: (BaseClass *)list;

@end
