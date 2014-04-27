//
//  BlockStates.h
//  CitySpade
//
//  Created by Cho-Yeung Lam on 27/4/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BlockStates : NSObject

#pragma mark - Requesting Blocks
+ (BOOL)addRequestingBlock:(NSDictionary *)block;
+ (BOOL)removeRequestingBlock:(NSDictionary *)block;
+ (void)clearRequestingBlocks;
+ (BOOL)blockIsRequesting:(NSDictionary *)block;

#pragma mark - OnMap Blocks
+ (BOOL)addOnMapBlock:(NSDictionary *)block;
+ (BOOL)removeOnMapBlock:(NSDictionary *)block;
+ (void)clearOnMapBlocks;
+ (BOOL)blockIsOnMap:(NSDictionary *)block; 

@end
