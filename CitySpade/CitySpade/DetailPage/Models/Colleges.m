//
//  Colleges.m
//
//  Created by 新强 朱 on 14-4-13
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "Colleges.h"

NSString *const kCollegesLng = @"lng";
NSString *const kCollegesLat = @"lat";
NSString *const kCollegesName = @"name";
NSString *const kCollegesTime = @"time";
NSString *const kCollegesTranstTypeIcon = @"transt_type_icon";


@interface Colleges ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation Colleges

@synthesize lng = _lng;
@synthesize lat = _lat;
@synthesize name = _name;
@synthesize time = _time;
@synthesize transtTypeIcon = _transtTypeIcon;


+ (Colleges *)modelObjectWithDictionary:(NSDictionary *)dict
{
    Colleges *instance = [[Colleges alloc] initWithDictionary:dict];
    return instance;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.lng = [[self objectOrNilForKey:kCollegesLng fromDictionary:dict] doubleValue];
            self.lat = [[self objectOrNilForKey:kCollegesLat fromDictionary:dict] doubleValue];
            self.name = [self objectOrNilForKey:kCollegesName fromDictionary:dict];
            self.time = [self objectOrNilForKey:kCollegesTime fromDictionary:dict];
            self.transtTypeIcon = [self objectOrNilForKey:kCollegesTranstTypeIcon fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.lng] forKey:kCollegesLng];
    [mutableDict setValue:[NSNumber numberWithDouble:self.lat] forKey:kCollegesLat];
    [mutableDict setValue:self.name forKey:kCollegesName];
    [mutableDict setValue:self.time forKey:kCollegesTime];
    [mutableDict setValue:self.transtTypeIcon forKey:kCollegesTranstTypeIcon];

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

    self.lng = [aDecoder decodeDoubleForKey:kCollegesLng];
    self.lat = [aDecoder decodeDoubleForKey:kCollegesLat];
    self.name = [aDecoder decodeObjectForKey:kCollegesName];
    self.time = [aDecoder decodeObjectForKey:kCollegesTime];
    self.transtTypeIcon = [aDecoder decodeObjectForKey:kCollegesTranstTypeIcon];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_lng forKey:kCollegesLng];
    [aCoder encodeDouble:_lat forKey:kCollegesLat];
    [aCoder encodeObject:_name forKey:kCollegesName];
    [aCoder encodeObject:_time forKey:kCollegesTime];
    [aCoder encodeObject:_transtTypeIcon forKey:kCollegesTranstTypeIcon];
}


@end
