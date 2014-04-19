//
//  BusLines.m
//
//  Created by 新强 朱 on 14-4-17
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "BusLines.h"


NSString *const kBusLinesStationName = @"station_name";
NSString *const kBusLinesLng = @"lng";
NSString *const kBusLinesLat = @"lat";
NSString *const kBusLinesLineName = @"line_name";
NSString *const kBusLinesDurationText = @"duration_text";
NSString *const kBusLinesDistanceText = @"distance_text";


@interface BusLines ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation BusLines

@synthesize stationName = _stationName;
@synthesize lng = _lng;
@synthesize lat = _lat;
@synthesize lineName = _lineName;
@synthesize durationText = _durationText;
@synthesize distanceText = _distanceText;


+ (BusLines *)modelObjectWithDictionary:(NSDictionary *)dict
{
    BusLines *instance = [[BusLines alloc] initWithDictionary:dict];
    return instance;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.stationName = [self objectOrNilForKey:kBusLinesStationName fromDictionary:dict];
            self.lng = [[self objectOrNilForKey:kBusLinesLng fromDictionary:dict] doubleValue];
            self.lat = [[self objectOrNilForKey:kBusLinesLat fromDictionary:dict] doubleValue];
            self.lineName = [self objectOrNilForKey:kBusLinesLineName fromDictionary:dict];
            self.durationText = [self objectOrNilForKey:kBusLinesDurationText fromDictionary:dict];
            self.distanceText = [self objectOrNilForKey:kBusLinesDistanceText fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.stationName forKey:kBusLinesStationName];
    [mutableDict setValue:[NSNumber numberWithDouble:self.lng] forKey:kBusLinesLng];
    [mutableDict setValue:[NSNumber numberWithDouble:self.lat] forKey:kBusLinesLat];
    [mutableDict setValue:self.lineName forKey:kBusLinesLineName];
    [mutableDict setValue:self.durationText forKey:kBusLinesDurationText];
    [mutableDict setValue:self.distanceText forKey:kBusLinesDistanceText];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.stationName = [aDecoder decodeObjectForKey:kBusLinesStationName];
    self.lng = [aDecoder decodeDoubleForKey:kBusLinesLng];
    self.lat = [aDecoder decodeDoubleForKey:kBusLinesLat];
    self.lineName = [aDecoder decodeObjectForKey:kBusLinesLineName];
    self.durationText = [aDecoder decodeObjectForKey:kBusLinesDurationText];
    self.distanceText = [aDecoder decodeObjectForKey:kBusLinesDistanceText];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_stationName forKey:kBusLinesStationName];
    [aCoder encodeDouble:_lng forKey:kBusLinesLng];
    [aCoder encodeDouble:_lat forKey:kBusLinesLat];
    [aCoder encodeObject:_lineName forKey:kBusLinesLineName];
    [aCoder encodeObject:_durationText forKey:kBusLinesDurationText];
    [aCoder encodeObject:_distanceText forKey:kBusLinesDistanceText];
}


@end
