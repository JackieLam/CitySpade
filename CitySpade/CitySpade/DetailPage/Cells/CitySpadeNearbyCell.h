//
//  CitySpadeNearbyCell.h
//  CitySpadeDemo
//
//  Created by izhuxin on 14-3-19.
//  Copyright (c) 2014年 Jeason. All rights reserved.
//

#import "CitySpadeCell.h"

@interface CitySpadeNearbyCell : CitySpadeCell

@property (nonatomic, weak) NSDictionary *locationDictionary;

- (void)setLocationDictionary:(NSDictionary *)locationDictionary;

@end
