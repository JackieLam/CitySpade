//
//  BlockCache.m
//  CitySpade
//
//  Created by Cho-Yeung Lam on 22/4/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import "BlockCache.h"
#import "Listing.h"

@implementation BlockCache

static NSMutableSet *loadedBlockSet;    // 保存地图上已经从磁盘加载过的Block

#pragma mark - Helper Methods

+ (void)initialize
{
    loadedBlockSet = [NSMutableSet set];
}

+ (NSString *)fileNameWithBlock:(NSDictionary *)paramDict
{
    NSArray *path=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *docDir=[path objectAtIndex:0];
    NSDate *date = [NSDate date];
    NSString *dateStr = [NSString stringWithFormat:@"%@",date];
    NSString *tmpPath2 = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"BlockCache/%@",[dateStr substringToIndex:10]]];     //10的格式能精确到天数
    
    NSString *swLatKey = @"southwestlat";
    NSString *swLngKey = @"southwestlng";
    NSString *fileName = [NSString stringWithFormat:@"%@/%@&%@&%@", tmpPath2, paramDict[swLatKey], paramDict[swLngKey], paramDict[@"rent"]];
    return fileName;
}

#pragma mark - Public Methods

+ (void)markOnTheMapWithBlock:(NSDictionary *)paramDict
{
    [loadedBlockSet addObject:paramDict];
}

+ (void)unmarkOnTheMapWithBlock:(NSDictionary *)paramDict
{
    [loadedBlockSet removeObject:paramDict];
}

+ (void)unmarkAllBlocks
{
    [loadedBlockSet removeAllObjects];
}

+ (BOOL)alreadyLoadFromCacheWithBlock:(NSDictionary *)paramDict
{
    if ([loadedBlockSet containsObject:paramDict])
        return YES;
    else
        return NO;
}

// 若磁盘中不存在： Should
// 若磁盘中存在：Shouldn't
+ (BOOL)shouldRequestWithBlock:(NSDictionary *)paramDict
{
    NSArray *path=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *docDir=[path objectAtIndex:0];
    NSDate *date = [NSDate date];
    NSString *dateStr = [NSString stringWithFormat:@"%@",date];
    NSString *tmpPath = [docDir stringByAppendingPathComponent:@"BlockCache"];
    NSString *tmpPath2 = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"BlockCache/%@",[dateStr substringToIndex:10]]];     //10的格式能精确到天数
    NSFileManager *fm = [NSFileManager defaultManager];
    if(![fm fileExistsAtPath:tmpPath2])
    {
        [fm removeItemAtPath:tmpPath error:nil];
        [fm createDirectoryAtPath:tmpPath2 withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    // 判断是否有缓存
    NSString *fileName = [self fileNameWithBlock:paramDict];
    if(![[NSFileManager defaultManager] fileExistsAtPath:fileName])
        return YES;
    else
        return NO;
}

+ (void)cacheListingItems:(NSArray *)listingItems block:(NSDictionary *)paramDict
{
    NSString *fileName = [self fileNameWithBlock:paramDict];
    [[NSKeyedArchiver archivedDataWithRootObject:listingItems] writeToFile:fileName atomically:YES];
}

+ (NSMutableArray *)getCachedListingItemsWithBlock:(NSDictionary *)paramDict
{
    NSString *fileName = [self fileNameWithBlock:paramDict];
    NSData *data = [NSData dataWithContentsOfFile:fileName];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

@end
