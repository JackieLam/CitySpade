//
//  BlockCache.h
//  CitySpade
//
//  Created by Cho-Yeung Lam on 22/4/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BlockCache : NSObject

//+ (void)markOnTheMapWithBlock:(NSDictionary *)paramDict; // 调用表示已经在地图上从Cache加载过了
//+ (void)unmarkOnTheMapWithBlock:(NSDictionary *)paramDict; // 调用表示取消在地图上的显示
//+ (void)unmarkAllBlocks; 
//+ (BOOL)alreadyLoadFromCacheWithBlock:(NSDictionary *)paramDict; // 用以判断是否应该从cache拿Block的数据
+ (BOOL)shouldRequestWithBlock:(NSDictionary *)paramDict;
+ (void)cacheListingItems:(NSArray *)listingItems block:(NSDictionary *)paramDict;
+ (NSMutableArray *)getCachedListingItemsWithBlock:(NSDictionary *)paramDict;

@end
