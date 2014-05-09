//
//  CitySpadeRequestHandler.m
//  CitySpadeDemo
//
//  Created by izhuxin on 14-3-20.
//  Copyright (c) 2014年 Jeason. All rights reserved.
//

#import "CitySpadeRequestHandler.h"
#import "constant.h"
@interface CitySpadeRequestHandler ()

@property (nonatomic, strong) NSURLSession *session;
//memory cache
@property (nonatomic, strong) NSURLCache *cache;

@end

@implementation CitySpadeRequestHandler

- (instancetype)init {
    self = [super init];
    if ( self ) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.session = [NSURLSession sessionWithConfiguration:config];
        
        self.cache = [NSURLCache sharedURLCache];
        
    }
    
    return self;
}

- (NSURLRequest *)requestWithCacheCheckedForURL: (NSURL *)url {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0f];
    
    NSCachedURLResponse *response = [_cache cachedResponseForRequest:request];
    if ( response ) {
        //memory cache exist
        [request setCachePolicy:NSURLRequestReturnCacheDataDontLoad];
    }
    return request;
}

- (void)fetchListingForURL: (NSURL *)url WithCompletionHandler:(void (^)(NSDictionary *listDictionary))completionHandler
{
    NSURLRequest *request = [self requestWithCacheCheckedForURL:url];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSURLSessionDataTask *dataTask = [_session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if ( !error ) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if ( httpResponse.statusCode == 200 ) {
                NSError *jsonError;
                NSMutableDictionary *listJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
                
                if ( !jsonError ) {
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completionHandler(listJSON);
                    });
                    
                } else {
                    NSLog(@"json Error!");
                }
            } else {
                NSLog(@"bad response!");
            }
        } else {
            NSLog(@"dataTask error : %@", error);
        }
    }];
    
    [dataTask resume];
}

- (void)downloadImagesForURL: (NSURL *)url WithCompletionHandler:(void (^)(NSDictionary *imagePathsDictionary)) completionHandler {
    NSURLRequest *request = [self requestWithCacheCheckedForURL:url];
    // TODO: check the disk cache
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSURLSessionDownloadTask *downloadTask = [_session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        if ( !error ) {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSArray *urls = [fileManager URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask];
            NSURL *documentsDirectory = urls[0];
            NSURL *temp = [documentsDirectory URLByAppendingPathComponent:@"DetailView"];
            if (![fileManager fileExistsAtPath:[temp path]]) {
                [fileManager createDirectoryAtPath:[temp path] withIntermediateDirectories:YES attributes:nil error:nil];
            }
            NSURL *destinationPath = [temp URLByAppendingPathComponent:[location lastPathComponent]];
            NSError *copyError;
            
            [fileManager removeItemAtURL:destinationPath error: NULL];
            if ( [fileManager copyItemAtURL:location toURL:destinationPath error:&copyError] ) {
                //return the destinationPath to user
                NSDictionary *URLToPathMap = @{
                                               [url absoluteString]:destinationPath
                                               };
                
//                NSLog(@"download image success!");
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionHandler( URLToPathMap );
                });
            } else {
                NSLog(@"copy error: %@ exist!", copyError);
            }
            
        } else {
//            NSLog(@"download task error : %@", error);
        }
    }];
    
    [downloadTask resume];

}


@end
