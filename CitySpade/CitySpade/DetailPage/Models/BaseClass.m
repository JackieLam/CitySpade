//
//  BaseClass.m
//
//  Created by 新强 朱 on 14-4-13
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "BaseClass.h"
#import "Colleges.h"
#import "HottestSpots.h"
#import "constant.h"
#import "SubwayLines.h"
#import "BusLines.h"
NSString *const kBaseClassBusLines = @"bus_lines";
NSString *const kBaseClassColleges = @"colleges";
NSString *const kBaseClassContactTel = @"contact_tel";
NSString *const kBaseClassHottestSpots = @"hottest_spots";
NSString *const kBaseClassSubwayLines = @"subway_lines";
NSString *const kBaseClassOriginalUrl = @"original_url";
NSString *const kBaseClassOriginalIconUrl = @"original_icon_url";
NSString *const kBaseClassContactName = @"contact_name";


@interface BaseClass ()

@property (atomic, strong) NSMutableDictionary *imagePathDict;

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation BaseClass

@synthesize busLines = _busLines;
@synthesize colleges = _colleges;
@synthesize contactTel = _contactTel;
@synthesize hottestSpots = _hottestSpots;
@synthesize subwayLines = _subwayLines;
@synthesize originalUrl = _originalUrl;
@synthesize originalIconUrl = _originalIconUrl;
@synthesize contactName = _contactName;


+ (BaseClass *)modelObjectWithDictionary:(NSDictionary *)dict
{
    BaseClass *instance = [[BaseClass alloc] initWithDictionary:dict];
    return instance;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
        self.imagePathDict = [[NSMutableDictionary alloc] init];
        //busline
        NSObject *receivedBusLines = [dict objectForKey:kBaseClassBusLines];
        NSMutableArray *parsedBusLines = [NSMutableArray array];
        if ([receivedBusLines isKindOfClass:[NSArray class]]) {
            for (NSDictionary *item in (NSArray *)receivedBusLines) {
                if ([item isKindOfClass:[NSDictionary class]]) {
                    [parsedBusLines addObject:[BusLines modelObjectWithDictionary:item]];
                }
            }
        } else if ([receivedBusLines isKindOfClass:[NSDictionary class]]) {
            [parsedBusLines addObject:[BusLines modelObjectWithDictionary:(NSDictionary *)receivedBusLines]];
        }
        
        self.busLines = [NSArray arrayWithArray:parsedBusLines];
        self.buslineCellHeight = 0;
        if ( [_busLines count] != 0 ) {
            _buslineCellHeight = ([_busLines count]/ numberOfBusInOneLine + 1) * heightForOneBusesLine;
        }
        
        //colleage
        NSObject *receivedColleges = [dict objectForKey:kBaseClassColleges];
        NSMutableArray *parsedColleges = [NSMutableArray array];
        if ([receivedColleges isKindOfClass:[NSArray class]]) {
            for (NSDictionary *item in (NSArray *)receivedColleges) {
                if ([item isKindOfClass:[NSDictionary class]]) {
                    [parsedColleges addObject:[Colleges modelObjectWithDictionary:item]];
                }
            }
        } else if ([receivedColleges isKindOfClass:[NSDictionary class]]) {
            [parsedColleges addObject:[Colleges modelObjectWithDictionary:(NSDictionary *)receivedColleges]];
        }
        self.colleges = [NSArray arrayWithArray:parsedColleges];
        self.colleagesCellHeight = 0;
        if ( [_colleges count] != 0 ) {
            _colleagesCellHeight = nameFrameSizeHeight + listLineHeight*[_colleges count] + linesLeading*([_colleges count]-1) + edgeLeading*2;
        }

        self.contactTel = [self objectOrNilForKey:kBaseClassContactTel fromDictionary:dict];
       
        //hottestSpots
        NSObject *receivedHottestSpots = [dict objectForKey:kBaseClassHottestSpots];
        NSMutableArray *parsedHottestSpots = [NSMutableArray array];
        if ([receivedHottestSpots isKindOfClass:[NSArray class]]) {
            for (NSDictionary *item in (NSArray *)receivedHottestSpots) {
                if ([item isKindOfClass:[NSDictionary class]]) {
                    [parsedHottestSpots addObject:[HottestSpots modelObjectWithDictionary:item]];
                }
            }
        } else if ([receivedHottestSpots isKindOfClass:[NSDictionary class]]) {
            [parsedHottestSpots addObject:[HottestSpots modelObjectWithDictionary:(NSDictionary *)receivedHottestSpots]];
        }
        self.hottestSpots = [NSArray arrayWithArray:parsedHottestSpots];
        self.hottestSpotCellHeight = 0;
        if ( [_hottestSpots count] != 0 ) {
            _hottestSpotCellHeight = nameFrameSizeHeight + listLineHeight * [_hottestSpots count] + linesLeading * ([_hottestSpots count]-1) + edgeLeading * 2;
        }

        //subways
        NSObject *receivedSubwayLines = [dict objectForKey:kBaseClassSubwayLines];
        NSMutableArray *parsedSubwayLines = [NSMutableArray array];
        if ([receivedSubwayLines isKindOfClass:[NSArray class]]) {
            for (NSDictionary *item in (NSArray *)receivedSubwayLines) {
                if ([item isKindOfClass:[NSDictionary class]]) {
                    [parsedSubwayLines addObject:[SubwayLines modelObjectWithDictionary:item]];
                }
            }
        } else if ([receivedSubwayLines isKindOfClass:[NSDictionary class]]) {
            [parsedSubwayLines addObject:[SubwayLines modelObjectWithDictionary:(NSDictionary *)receivedSubwayLines]];
        }
        self.subwayLines = [self configureSubwaysArray:parsedSubwayLines];
        self.subwayCellHeight = 0;
        if ( [_subwayLines count] != 0 ) {
            _subwayCellHeight = nameFrameSizeHeight + listLineHeight * [_subwayLines count] + linesLeading * ( [_subwayLines count] - 1 ) + edgeLeading * 2;
        }
        
        self.originalUrl = [self objectOrNilForKey:kBaseClassOriginalUrl fromDictionary:dict];
        self.originalIconUrl = [self objectOrNilForKey:kBaseClassOriginalIconUrl fromDictionary:dict];
        self.contactName = [self objectOrNilForKey:kBaseClassContactName fromDictionary:dict];
        
        //all have down
        self.transportationCellHeight = _subwayCellHeight + _buslineCellHeight + _hottestSpotCellHeight + _colleagesCellHeight;
    }
    
    return self;
}

- (NSArray *)configureSubwaysArray: (NSArray *)subways {
    
    //construct an array ordered by their distance
    NSMutableArray *tempMutableArray = [subways mutableCopy];
    if ( [tempMutableArray count] == 0 ) {
        return tempMutableArray;
    }
    [tempMutableArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        SubwayLines *subway1 = (SubwayLines *)obj1;
        SubwayLines *subway2 = (SubwayLines *)obj2;
        return [subway1.distanceText compare:subway2.distanceText
                                     options:NSNumericSearch];
    }];
    
    int count = 0;
    SubwayLines *firstSubway = tempMutableArray[0];
    NSString *lastDistance = firstSubway.distanceText;
    NSMutableArray *resultArray = [[NSMutableArray alloc] initWithObjects:[NSMutableArray arrayWithArray:@[lastDistance]], nil];
    
    for ( SubwayLines *subway in tempMutableArray ) {
        if ( [subway.distanceText isEqualToString:lastDistance] ) {
            [resultArray[count] addObject:subway];
        } else {
            lastDistance = subway.distanceText;
            [resultArray addObject:[NSMutableArray arrayWithArray:@[lastDistance, subway]]];
            count++;
        }
    }
    return resultArray;
}


- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    NSMutableArray *tempArrayForBusLines = [NSMutableArray array];
    for (NSObject *subArrayObject in self.busLines) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForBusLines addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForBusLines addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForBusLines] forKey:@"kBaseClassBusLines"];
NSMutableArray *tempArrayForColleges = [NSMutableArray array];
    for (NSObject *subArrayObject in self.colleges) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForColleges addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForColleges addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForColleges] forKey:@"kBaseClassColleges"];
    [mutableDict setValue:self.contactTel forKey:kBaseClassContactTel];
NSMutableArray *tempArrayForHottestSpots = [NSMutableArray array];
    for (NSObject *subArrayObject in self.hottestSpots) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForHottestSpots addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForHottestSpots addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForHottestSpots] forKey:@"kBaseClassHottestSpots"];
NSMutableArray *tempArrayForSubwayLines = [NSMutableArray array];
    for (NSObject *subArrayObject in self.subwayLines) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForSubwayLines addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForSubwayLines addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForSubwayLines] forKey:@"kBaseClassSubwayLines"];
    [mutableDict setValue:self.originalUrl forKey:kBaseClassOriginalUrl];
    [mutableDict setValue:self.originalIconUrl forKey:kBaseClassOriginalIconUrl];
    [mutableDict setValue:self.contactName forKey:kBaseClassContactName];

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

    self.busLines = [aDecoder decodeObjectForKey:kBaseClassBusLines];
    self.colleges = [aDecoder decodeObjectForKey:kBaseClassColleges];
    self.contactTel = [aDecoder decodeObjectForKey:kBaseClassContactTel];
    self.hottestSpots = [aDecoder decodeObjectForKey:kBaseClassHottestSpots];
    self.subwayLines = [aDecoder decodeObjectForKey:kBaseClassSubwayLines];
    self.originalUrl = [aDecoder decodeObjectForKey:kBaseClassOriginalUrl];
    self.originalIconUrl = [aDecoder decodeObjectForKey:kBaseClassOriginalIconUrl];
    self.contactName = [aDecoder decodeObjectForKey:kBaseClassContactName];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_busLines forKey:kBaseClassBusLines];
    [aCoder encodeObject:_colleges forKey:kBaseClassColleges];
    [aCoder encodeObject:_contactTel forKey:kBaseClassContactTel];
    [aCoder encodeObject:_hottestSpots forKey:kBaseClassHottestSpots];
    [aCoder encodeObject:_subwayLines forKey:kBaseClassSubwayLines];
    [aCoder encodeObject:_originalUrl forKey:kBaseClassOriginalUrl];
    [aCoder encodeObject:_originalIconUrl forKey:kBaseClassOriginalIconUrl];
    [aCoder encodeObject:_contactName forKey:kBaseClassContactName];
}


@end
