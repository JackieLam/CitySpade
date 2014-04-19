//
//  CitySpadeListsModel.h
//  CitySpadeDemo
//
//  Created by izhuxin on 14-4-7.
//  Copyright (c) 2014年 Jeason. All rights reserved.
//

@import Foundation;
@class BaseClass;

@interface CitySpadeModelManager : NSObject

+(instancetype)sharedManager;

- (void)beginFetchList: (NSString *)listAPI WithCompletionHandler:(void (^)(BaseClass *))completionHandler;

- (void)fetchImageForURL:(NSString *)urlString WithCompletionHandler:(void (^)(void))completionHandler;

- (NSURL *)imagePathForImageURL: (NSString *)imageURLString;

@end