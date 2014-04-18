//
//  Images.m
//
//  Created by Lam Cho-Yeung on 19/2/14
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "Images.h"


NSString *const kImagesSizes = @"sizes";
NSString *const kImagesUrl = @"url";


@interface Images ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation Images

@synthesize sizes = _sizes;
@synthesize url = _url;


+ (Images *)modelObjectWithDictionary:(NSDictionary *)dict
{
    Images *instance = [[Images alloc] initWithDictionary:dict];
    return instance;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.sizes = [self objectOrNilForKey:kImagesSizes fromDictionary:dict];
            self.url = [self objectOrNilForKey:kImagesUrl fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
NSMutableArray *tempArrayForSizes = [NSMutableArray array];
    for (NSObject *subArrayObject in self.sizes) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForSizes addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForSizes addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForSizes] forKey:@"kImagesSizes"];
    [mutableDict setValue:self.url forKey:kImagesUrl];

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

    self.sizes = [aDecoder decodeObjectForKey:kImagesSizes];
    self.url = [aDecoder decodeObjectForKey:kImagesUrl];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_sizes forKey:kImagesSizes];
    [aCoder encodeObject:_url forKey:kImagesUrl];
}


@end
