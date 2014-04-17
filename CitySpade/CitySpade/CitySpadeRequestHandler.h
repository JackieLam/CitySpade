//
//  CitySpadeRequestHandler.h
//  CitySpadeDemo
//
//  Created by izhuxin on 14-3-20.
//  Copyright (c) 2014年 Jeason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CitySpadeRequestHandler : NSObject

- (void)fetchListingForURL: (NSURL *)url WithCompletionHandler:(void (^)(NSDictionary *listDictionary))completionHandler;

//- (void)downloadImagesWithURLs: (NSArray *)urlArray;

- (void)downloadImagesForURL: (NSURL *)url WithCompletionHandler:(void (^)(NSDictionary *imagePathsDictionary)) completionHandler;

@end
