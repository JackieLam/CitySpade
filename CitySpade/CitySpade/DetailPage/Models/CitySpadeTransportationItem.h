//
//  CitySpadeTransportationItem.h
//  CitySpadeDemo
//
//  Created by Jeason on 14-4-17.
//  Copyright (c) 2014年 Jeason. All rights reserved.
//

//abstract class for HottestSpots and Colleages

#import <Foundation/Foundation.h>

@interface CitySpadeTransportationItem : NSObject<NSCoding>
@property (nonatomic, assign) double lng;
@property (nonatomic, assign) double lat;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *transtTypeIcon;

+ (CitySpadeTransportationItem *)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
