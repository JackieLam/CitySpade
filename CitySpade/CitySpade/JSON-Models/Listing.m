//
//  Listing.m
//
//  Created by Lam Cho-Yeung on 19/2/14
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "Listing.h"
#import "Images.h"


NSString *const kListingImages = @"images";
NSString *const kListingId = @"id";
NSString *const kListingBeds = @"beds";
NSString *const kListingTitle = @"title";
NSString *const kListingPrice = @"price";
NSString *const kListingZipcode = @"zipcode";
NSString *const kListingBaths = @"baths";
NSString *const kListingLat = @"lat";
NSString *const kListingLng = @"lng";
NSString *const kListingBargain = @"bargain";
NSString *const kListingTransportation = @"transportation";


@interface Listing ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation Listing

@synthesize images = _images;
@synthesize internalBaseClassIdentifier = _internalBaseClassIdentifier;
@synthesize beds = _beds;
@synthesize title = _title;
@synthesize price = _price;
@synthesize zipcode = _zipcode;
@synthesize baths = _baths;
@synthesize lat = _lat;
@synthesize lng = _lng;
@synthesize bargain = _bargain;
@synthesize transportation = _transportation;


+ (Listing *)modelObjectWithDictionary:(NSDictionary *)dict
{
    Listing *instance = [[Listing alloc] initWithDictionary:dict];
    return instance;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
    NSObject *receivedImages = [dict objectForKey:kListingImages];
    NSMutableArray *parsedImages = [NSMutableArray array];
    if ([receivedImages isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedImages) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedImages addObject:[Images modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedImages isKindOfClass:[NSDictionary class]]) {
       [parsedImages addObject:[Images modelObjectWithDictionary:(NSDictionary *)receivedImages]];
    }

    self.images = [NSArray arrayWithArray:parsedImages];
            self.internalBaseClassIdentifier = [[self objectOrNilForKey:kListingId fromDictionary:dict] doubleValue];
            self.beds = [[self objectOrNilForKey:kListingBeds fromDictionary:dict] doubleValue];
            self.title = [self objectOrNilForKey:kListingTitle fromDictionary:dict];
            self.price = [[self objectOrNilForKey:kListingPrice fromDictionary:dict] doubleValue];
            self.zipcode = [self objectOrNilForKey:kListingZipcode fromDictionary:dict];
            self.baths = [[self objectOrNilForKey:kListingBaths fromDictionary:dict] doubleValue];
            self.lat = [[self objectOrNilForKey:kListingLat fromDictionary:dict] doubleValue];
            self.lng = [[self objectOrNilForKey:kListingLng fromDictionary:dict] doubleValue];
            self.bargain = [self objectOrNilForKey:kListingBargain fromDictionary:dict];
            self.transportation = [self objectOrNilForKey:kListingTransportation fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
NSMutableArray *tempArrayForImages = [NSMutableArray array];
    for (NSObject *subArrayObject in self.images) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForImages addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForImages addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForImages] forKey:@"kListingImages"];
    [mutableDict setValue:[NSNumber numberWithDouble:self.internalBaseClassIdentifier] forKey:kListingId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.beds] forKey:kListingBeds];
    [mutableDict setValue:self.title forKey:kListingTitle];
    [mutableDict setValue:[NSNumber numberWithDouble:self.price] forKey:kListingPrice];
    [mutableDict setValue:self.zipcode forKey:kListingZipcode];
    [mutableDict setValue:[NSNumber numberWithDouble:self.baths] forKey:kListingBaths];
    [mutableDict setValue:[NSNumber numberWithDouble:self.lat] forKey:kListingLat];
    [mutableDict setValue:[NSNumber numberWithDouble:self.lng] forKey:kListingLng];
    [mutableDict setValue:self.bargain forKey:kListingBargain];
    [mutableDict setValue:self.transportation forKey:kListingTransportation];

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

    self.images = [aDecoder decodeObjectForKey:kListingImages];
    self.internalBaseClassIdentifier = [aDecoder decodeDoubleForKey:kListingId];
    self.beds = [aDecoder decodeDoubleForKey:kListingBeds];
    self.title = [aDecoder decodeObjectForKey:kListingTitle];
    self.price = [aDecoder decodeDoubleForKey:kListingPrice];
    self.zipcode = [aDecoder decodeObjectForKey:kListingZipcode];
    self.baths = [aDecoder decodeDoubleForKey:kListingBaths];
    self.lat = [aDecoder decodeDoubleForKey:kListingLat];
    self.lng = [aDecoder decodeDoubleForKey:kListingLng];
    self.bargain = [aDecoder decodeObjectForKey:kListingBargain];
    self.transportation = [aDecoder decodeObjectForKey:kListingTransportation];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_images forKey:kListingImages];
    [aCoder encodeDouble:_internalBaseClassIdentifier forKey:kListingId];
    [aCoder encodeDouble:_beds forKey:kListingBeds];
    [aCoder encodeObject:_title forKey:kListingTitle];
    [aCoder encodeDouble:_price forKey:kListingPrice];
    [aCoder encodeObject:_zipcode forKey:kListingZipcode];
    [aCoder encodeDouble:_baths forKey:kListingBaths];
    [aCoder encodeDouble:_lat forKey:kListingLat];
    [aCoder encodeDouble:_lng forKey:kListingLng];
    [aCoder encodeObject:_bargain forKey:kListingBargain];
    [aCoder encodeObject:_transportation forKey:kListingTransportation];
}

@end
