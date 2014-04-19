//
//  SubwayLines.m
//
//  Created by 新强 朱 on 14-4-17
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "SubwayLines.h"


NSString *const kSubwayLinesDistanceText = @"distance_text";
NSString *const kSubwayLinesDurationText = @"duration_text";
NSString *const kSubwayLinesLineName = @"line_name";
NSString *const kSubwayLinesIconUrl = @"icon_url";
NSString *const kSubwayLinesLat = @"lat";
NSString *const kSubwayLinesStationName = @"station_name";
NSString *const kSubwayLinesLng = @"lng";


@interface SubwayLines ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation SubwayLines

@synthesize distanceText = _distanceText;
@synthesize durationText = _durationText;
@synthesize lineName = _lineName;
@synthesize iconUrl = _iconUrl;
@synthesize lat = _lat;
@synthesize stationName = _stationName;
@synthesize lng = _lng;


+ (SubwayLines *)modelObjectWithDictionary:(NSDictionary *)dict
{
    SubwayLines *instance = [[SubwayLines alloc] initWithDictionary:dict];
    return instance;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.distanceText = [self objectOrNilForKey:kSubwayLinesDistanceText fromDictionary:dict];
            self.durationText = [self objectOrNilForKey:kSubwayLinesDurationText fromDictionary:dict];
            self.lineName = [self objectOrNilForKey:kSubwayLinesLineName fromDictionary:dict];
            self.iconUrl = [self objectOrNilForKey:kSubwayLinesIconUrl fromDictionary:dict];
            self.lat = [[self objectOrNilForKey:kSubwayLinesLat fromDictionary:dict] doubleValue];
            self.stationName = [self objectOrNilForKey:kSubwayLinesStationName fromDictionary:dict];
            self.lng = [[self objectOrNilForKey:kSubwayLinesLng fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.distanceText forKey:kSubwayLinesDistanceText];
    [mutableDict setValue:self.durationText forKey:kSubwayLinesDurationText];
    [mutableDict setValue:self.lineName forKey:kSubwayLinesLineName];
    [mutableDict setValue:self.iconUrl forKey:kSubwayLinesIconUrl];
    [mutableDict setValue:[NSNumber numberWithDouble:self.lat] forKey:kSubwayLinesLat];
    [mutableDict setValue:self.stationName forKey:kSubwayLinesStationName];
    [mutableDict setValue:[NSNumber numberWithDouble:self.lng] forKey:kSubwayLinesLng];

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

    self.distanceText = [aDecoder decodeObjectForKey:kSubwayLinesDistanceText];
    self.durationText = [aDecoder decodeObjectForKey:kSubwayLinesDurationText];
    self.lineName = [aDecoder decodeObjectForKey:kSubwayLinesLineName];
    self.iconUrl = [aDecoder decodeObjectForKey:kSubwayLinesIconUrl];
    self.lat = [aDecoder decodeDoubleForKey:kSubwayLinesLat];
    self.stationName = [aDecoder decodeObjectForKey:kSubwayLinesStationName];
    self.lng = [aDecoder decodeDoubleForKey:kSubwayLinesLng];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_distanceText forKey:kSubwayLinesDistanceText];
    [aCoder encodeObject:_durationText forKey:kSubwayLinesDurationText];
    [aCoder encodeObject:_lineName forKey:kSubwayLinesLineName];
    [aCoder encodeObject:_iconUrl forKey:kSubwayLinesIconUrl];
    [aCoder encodeDouble:_lat forKey:kSubwayLinesLat];
    [aCoder encodeObject:_stationName forKey:kSubwayLinesStationName];
    [aCoder encodeDouble:_lng forKey:kSubwayLinesLng];
}


@end
