//
//  Listing.h
//
//  Created by Lam Cho-Yeung on 19/2/14
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Listing : NSObject <NSCoding>

@property (nonatomic, strong) NSArray *images;
@property (nonatomic, assign) double internalBaseClassIdentifier;
@property (nonatomic, assign) double beds;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) double price;
@property (nonatomic, strong) NSString *zipcode;
@property (nonatomic, assign) double baths;
@property (nonatomic, assign) double lat;
@property (nonatomic, assign) double lng;
@property (nonatomic, strong) NSString *bargain;
@property (nonatomic, strong) NSString *transportation;

+ (Listing *)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
