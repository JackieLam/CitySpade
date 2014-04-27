//
//  BlockStates.m
//  CitySpade
//
//  Created by Cho-Yeung Lam on 27/4/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import "BlockStates.h"

@implementation BlockStates

static NSMutableSet *requestingBlocks;
static NSMutableSet *onMapBlocks;

+(void)initialize
{
    requestingBlocks = [NSMutableSet set];
    onMapBlocks = [NSMutableSet set];
}

#pragma mark - Requesting Block Method

+ (BOOL)addRequestingBlock:(NSDictionary *)block
{
    if ([requestingBlocks containsObject:block])
        return NO;
    else {
        [requestingBlocks addObject:block];
        return YES;
    }
}

+ (BOOL)removeRequestingBlock:(NSDictionary *)block
{
    if (![requestingBlocks containsObject:block])
        return NO;
    else {
        [requestingBlocks removeObject:block];
        return YES;
    }
}

+ (void)clearRequestingBlocks
{
    [requestingBlocks removeAllObjects];
}

+ (BOOL)blockIsRequesting:(NSDictionary *)block
{
    if ([requestingBlocks containsObject:block])
        return YES;
    else
        return NO;
}

#pragma mark - OnMap Block Method

+ (BOOL)addOnMapBlock:(NSDictionary *)block
{
    if ([onMapBlocks containsObject:block])
        return NO;
    else {
        [onMapBlocks addObject:block];
        return YES;
    }
}

+ (BOOL)removeOnMapBlock:(NSDictionary *)block
{
    if (![onMapBlocks containsObject:block])
        return NO;
    else {
        [onMapBlocks addObject:block];
        return YES;
    }
}

+ (void)clearOnMapBlocks
{
    [onMapBlocks removeAllObjects];
}

+ (BOOL)blockIsOnMap:(NSDictionary *)block
{
    if ([onMapBlocks containsObject:block])
        return YES;
    else
        return NO;
}

@end
