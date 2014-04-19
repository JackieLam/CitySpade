//
//  HottestSpots.m
//
//  Created by 新强 朱 on 14-4-13
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "HottestSpots.h"


NSString *const kHottestSpotsLng = @"lng";
NSString *const kHottestSpotsLat = @"lat";
NSString *const kHottestSpotsName = @"name";
NSString *const kHottestSpotsTime = @"time";
NSString *const kHottestSpotsTranstTypeIcon = @"transt_type_icon";


@interface HottestSpots ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation HottestSpots

@synthesize lng = _lng;
@synthesize lat = _lat;
@synthesize name = _name;
@synthesize time = _time;
@synthesize transtTypeIcon = _transtTypeIcon;


+ (HottestSpots *)modelObjectWithDictionary:(NSDictionary *)dict
{
    HottestSpots *instance = [[HottestSpots alloc] initWithDictionary:dict];
    return instance;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.lng = [[self objectOrNilForKey:kHottestSpotsLng fromDictionary:dict] doubleValue];
            self.lat = [[self objectOrNilForKey:kHottestSpotsLat fromDictionary:dict] doubleValue];
            self.name = [self objectOrNilForKey:kHottestSpotsName fromDictionary:dict];
            self.time = [self objectOrNilForKey:kHottestSpotsTime fromDictionary:dict];
            self.transtTypeIcon = [self objectOrNilForKey:kHottestSpotsTranstTypeIcon fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.lng] forKey:kHottestSpotsLng];
    [mutableDict setValue:[NSNumber numberWithDouble:self.lat] forKey:kHottestSpotsLat];
    [mutableDict setValue:self.name forKey:kHottestSpotsName];
    [mutableDict setValue:self.time forKey:kHottestSpotsTime];
    [mutableDict setValue:self.transtTypeIcon forKey:kHottestSpotsTranstTypeIcon];

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

    self.lng = [aDecoder decodeDoubleForKey:kHottestSpotsLng];
    self.lat = [aDecoder decodeDoubleForKey:kHottestSpotsLat];
    self.name = [aDecoder decodeObjectForKey:kHottestSpotsName];
    self.time = [aDecoder decodeObjectForKey:kHottestSpotsTime];
    self.transtTypeIcon = [aDecoder decodeObjectForKey:kHottestSpotsTranstTypeIcon];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_lng forKey:kHottestSpotsLng];
    [aCoder encodeDouble:_lat forKey:kHottestSpotsLat];
    [aCoder encodeObject:_name forKey:kHottestSpotsName];
    [aCoder encodeObject:_time forKey:kHottestSpotsTime];
    [aCoder encodeObject:_transtTypeIcon forKey:kHottestSpotsTranstTypeIcon];
}


@end
