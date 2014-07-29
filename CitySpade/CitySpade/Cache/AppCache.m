//
//  AppCache.m
//  CitySpade
//
//  Created by Cho-Yeung Lam on 13/3/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import "AppCache.h"
#import "Constants.h"

#define kMenuStaleSeconds 10

@implementation AppCache

static NSMutableDictionary *memoryCache;
static NSMutableArray *recentlyAccessedKeys;
static int kCacheMemoryLimit;

+ (void)initialize
{
    NSString *cacheDirectory = [AppCache cacheDirectory];
    if (![[NSFileManager defaultManager] fileExistsAtPath:cacheDirectory]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:cacheDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    double lastSavedCacheVersion = [[NSUserDefaults standardUserDefaults] doubleForKey:kAppVersion];
    double currentAppVersion = [[AppCache appVersion] doubleValue];
    if  (lastSavedCacheVersion == 0.0f || lastSavedCacheVersion < currentAppVersion)
    {
        //assign the current version to the preference
        [AppCache clearCache];
        [[NSUserDefaults standardUserDefaults] setDouble:currentAppVersion forKey:kAppVersion];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    memoryCache = [[NSMutableDictionary alloc] init];
    recentlyAccessedKeys = [[NSMutableArray alloc] init];
    kCacheMemoryLimit = 10;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveMemoryCacheToDisk:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveMemoryCacheToDisk:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveMemoryCacheToDisk:) name:UIApplicationWillTerminateNotification object:nil];
}

+ (void)dealloc
{
    memoryCache = nil;
    recentlyAccessedKeys = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillTerminateNotification object:nil];
}

//Save the data in memory to the disk
+(void) saveMemoryCacheToDisk:(NSNotification *)notification
{
    for (NSString *filename in [memoryCache allKeys]) {
        NSString *archivePath = [[AppCache cacheDirectory] stringByAppendingPathComponent:filename];
        NSData *cacheData = [memoryCache objectForKey:filename];
        [cacheData writeToFile:archivePath atomically:YES];
    }
    [memoryCache removeAllObjects];
}

+(void) clearCache
{
    NSArray *cachedItems = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[AppCache cacheDirectory] error:nil];
    for (NSString *path in cachedItems)
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    [memoryCache removeAllObjects];
}

#pragma mark - Helper Method
+(NSString*) appVersion
{
    CFStringRef versStr = (CFStringRef)CFBundleGetValueForInfoDictionaryKey(CFBundleGetMainBundle(), kCFBundleVersionKey);
    NSString *version = [NSString stringWithUTF8String:CFStringGetCStringPtr(versStr, kCFStringEncodingMacRoman)];
    return version;
}

+(NSString*) cacheDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
	return [cachesDirectory stringByAppendingPathComponent:@"AppCache"];
}

#pragma mark - Custom Helper Methods
#pragma mark - Memory Cache

+(void) cacheData:(NSData*) data toFile:(NSString*) fileName
{
    [memoryCache setObject:data forKey:fileName];
    if ([recentlyAccessedKeys containsObject:fileName]) {
        [recentlyAccessedKeys removeObject:fileName];
    }
    
    [recentlyAccessedKeys insertObject:fileName atIndex:0];
    
    if ([recentlyAccessedKeys count] > kCacheMemoryLimit) {
        NSString *leastRecentlyUsedDataFilename = [recentlyAccessedKeys lastObject];
        NSData *leastRecentlyUsedCacheData = [memoryCache objectForKey:leastRecentlyUsedDataFilename];
        NSString *archivePath = [[AppCache cacheDirectory] stringByAppendingPathComponent:fileName];
        [leastRecentlyUsedCacheData writeToFile:archivePath atomically:YES];
        [recentlyAccessedKeys removeLastObject];
        [memoryCache removeObjectForKey:leastRecentlyUsedDataFilename];
    }
}

+(NSData*) dataForFile:(NSString*) fileName
{
    NSData *data = [memoryCache objectForKey:fileName];
    if (data) return data;
    
    NSString *archivePath = [[AppCache cacheDirectory] stringByAppendingPathComponent:fileName];;
    data = [NSData dataWithContentsOfFile:archivePath];
    if (data)
        [self cacheData:data toFile:fileName];
    
    return data;
}

#pragma mark - API Exposure

+ (void)cacheListingItems:(NSArray *)listingItems
{
    [self cacheData:[NSKeyedArchiver archivedDataWithRootObject:listingItems] toFile:kListingsArchive];
}

+ (NSMutableArray *)getCachedListingItems
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:[self dataForFile:kListingsArchive]];
}

+ (BOOL)isListingItemsStale
{
    // if it is in memory cache, it is not stale
    if([recentlyAccessedKeys containsObject:kListingsArchive])
        return NO;
    
	NSString *archivePath = [[AppCache cacheDirectory] stringByAppendingPathComponent:kListingsArchive];
    
    NSTimeInterval stalenessLevel = [[[[NSFileManager defaultManager] attributesOfItemAtPath:archivePath error:nil] fileModificationDate] timeIntervalSinceNow];
    
    return stalenessLevel > kMenuStaleSeconds;
}

+ (void)cacheSaveList:(NSArray *)saveListing
{
    [self cacheData:[NSKeyedArchiver archivedDataWithRootObject:saveListing] toFile:[self getSavingListPath]];
}

+ (NSMutableArray *)getCachedSaveList
{
    NSData *data = [self dataForFile:[self getSavingListPath]];
    if (data != nil)
        return [NSKeyedUnarchiver unarchiveObjectWithData:data];
    else
        return [NSMutableArray array];
}

+ (BOOL)isSaveListStale
{
    // if it is in memory cache, it is not stale
    if([recentlyAccessedKeys containsObject:[self getSavingListPath]])
        return NO;
    
	NSString *archivePath = [[AppCache cacheDirectory] stringByAppendingPathComponent:[self getSavingListPath]];
    
    NSTimeInterval stalenessLevel = [[[[NSFileManager defaultManager] attributesOfItemAtPath:archivePath error:nil] fileModificationDate] timeIntervalSinceNow];
    
    return stalenessLevel > kMenuStaleSeconds;
}

+ (NSString *)getSavingListPath
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *saveListingPath = [NSString stringWithFormat:@"%@%@",[defaults objectForKey:@"USER_NAME"],kSaveListArchive];
    return saveListingPath;
}

+ (void)cacheCities:(NSArray *)cities
{
    NSString *path = [[AppCache cacheDirectory] stringByAppendingPathComponent:@"cities"];
    [[NSKeyedArchiver archivedDataWithRootObject:cities] writeToFile:path atomically:true];
}

+ (NSArray *)getCachedCities
{
    NSString *path = [[AppCache cacheDirectory] stringByAppendingPathComponent:@"cities"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSArray *cities = nil;
    if (data) {
        cities = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    
    return cities;
}
@end
