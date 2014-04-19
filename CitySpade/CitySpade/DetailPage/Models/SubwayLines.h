//
//  SubwayLines.h
//
//  Created by 新强 朱 on 14-4-17
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface SubwayLines : NSObject <NSCoding>

@property (nonatomic, strong) NSString *distanceText;
@property (nonatomic, strong) NSString *durationText;
@property (nonatomic, strong) NSString *lineName;
@property (nonatomic, strong) NSString *iconUrl;
@property (nonatomic, assign) double lat;
@property (nonatomic, strong) NSString *stationName;
@property (nonatomic, assign) double lng;

+ (SubwayLines *)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
