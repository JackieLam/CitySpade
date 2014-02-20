//
//  RESTfulEngine.m
//  CitySpade
//
//  Created by Cho-Yeung Lam on 19/2/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import "RESTfulEngine.h"
#import "Listing.h"

NSString * const HOST_URL = @"http://cityspade.com/api/v1";
NSString * const LISTINGS_PATH = @"/listings.json?";


@interface RESTfulEngine()

@end

@implementation RESTfulEngine

+ (void)loadListingsWithQuery:(NSDictionary *)queryParam onSucceeded:(ArrayBlock)succededBlock onError:(ErrorBlock)errorBlock
{
    NSMutableString *paramSubstring = [NSMutableString string];
    if (queryParam != nil) {
        for (NSString *key in queryParam.allKeys) {
            [paramSubstring appendString:[NSString stringWithFormat:@"%@=%@", key, queryParam[key]]];
        }
    }
    
    NSMutableString *urlString = [NSMutableString stringWithString:HOST_URL];
    [urlString appendString:LISTINGS_PATH];
    if (paramSubstring) {
        [urlString appendString:paramSubstring];
    }
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession * session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            
            // 1 HTTP Response
            NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
            if (httpResp.statusCode == 200) {
                
                NSError *jsonError;
                
                // 2 Serialize json
                NSMutableArray *listingsJSON =
                [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
                NSMutableArray *models = [NSMutableArray array];
                for (id obj in listingsJSON) {
                    Listing *newlisting = [Listing modelObjectWithDictionary:obj];
                    [models addObject:newlisting];
                }
                if (!jsonError) {
                    // 3
                    succededBlock(models);
                }
            }
        }
        else {
            NSLog(@"error : %@", error);
        }
    }];
    [dataTask resume];
}

@end