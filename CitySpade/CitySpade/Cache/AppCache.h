//
//  AppCache.h
//  CitySpade
//
//  Created by Cho-Yeung Lam on 13/3/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppCache : NSObject

+ (void)clearCache;
+ (void)cacheListingItems:(NSArray *)listingItems;
+ (NSMutableArray *)getCachedListingItems;
+ (BOOL)isListingItemsStale;

@end