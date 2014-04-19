//
//  CitySpadeListsModel.m
//  CitySpadeDemo
//
//  Created by izhuxin on 14-4-7.
//  Copyright (c) 2014年 Jeason. All rights reserved.
//

#import "CitySpadeModelManager.h"
#import "DataModels.h"
#import "CitySpadeRequestHandler.h"
#import "constant.h"

@interface CitySpadeModelManager()
@property (nonatomic, strong) CitySpadeRequestHandler *requestHandler;
@property (atomic, strong) NSMutableDictionary *imagePathMap;
@end

@implementation CitySpadeModelManager

+(instancetype)sharedManager {
    static id _sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;

}

- (instancetype)init {
    self = [super init];
    if ( self ) {
        self.requestHandler = [[CitySpadeRequestHandler alloc] init];
        self.imagePathMap = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)beginFetchList: (NSString *)listAPI WithCompletionHandler:(void (^)(BaseClass *baseList))completionHandler {
    NSURL *listURL = [NSURL URLWithString:listAPI];
    [_requestHandler fetchListingForURL:listURL WithCompletionHandler:^(NSDictionary *listDictionary) {
//        NSLog(@"%@", listDictionary);
        completionHandler( [BaseClass modelObjectWithDictionary:listDictionary] );
    }];
}

- (void)fetchImageForURL:(NSString *)urlString WithCompletionHandler:(void (^)(void))completionHandler {
    NSURL *imageURL = [[NSURL alloc] initWithString:urlString];
    [_requestHandler downloadImagesForURL:imageURL WithCompletionHandler:^(NSDictionary *imagePathsDictionary) {
        [self.imagePathMap addEntriesFromDictionary:imagePathsDictionary];
        completionHandler();
    }
    ];
}

- (NSURL *)imagePathForImageURL:(NSString *)imageURLString {
    return _imagePathMap[imageURLString];
}

@end
