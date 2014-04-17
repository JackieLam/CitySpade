//
//  CitySpadeListsModel.h
//  CitySpadeDemo
//
//  Created by izhuxin on 14-4-7.
//  Copyright (c) 2014年 Jeason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CitySpadeListsModel : NSObject

@property (atomic, strong) NSDictionary *infoDictionary;

@property (readonly, getter = isFetchListCompleted) BOOL fetchListCompleted;

- (instancetype)initWithAPI: (NSString *)listAPI;

- (void)beginFetchListWithCompletionHandler:(void (^)(NSDictionary *resultDictionary))completionHandler;

- (void)fetchImageForURL:(NSString *) urlString WithCompletionHandler:(void (^)(NSDictionary *resultDictionary))completionHandler;

@end