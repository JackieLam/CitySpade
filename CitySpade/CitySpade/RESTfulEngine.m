//
//  RESTfulEngine.m
//  CitySpade
//
//  Created by Cho-Yeung Lam on 19/2/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import "RESTfulEngine.h"
#import "Listing.h"
#import "NSString+Encryption.h"
#import "Constants.h"
#import "FacebookDelegate.h"
#import "BlockCache.h"
#import "BlockStates.h"
#import <SystemConfiguration/SCNetworkReachability.h>

//Part One
NSString * const HOST_URL = @"http://www.cityspade.com/api/v1";
NSString * const LISTINGS_PATH = @"/listings.json?";

//Part Two
NSString * const LOGIN_PATH = @"/auth/login.json";
NSString * const LOGOUT_PATH = @"/auth/logout.json";
NSString * const REGISTER_PATH = @"/auth/register.json";
NSString * const CALLBACK_PATH = @"/auth/callback.json";

//Part Three
NSString * const SAVED_LISTING_PATH = @"/account/savinglists.json";
NSString * const POST_LISTING_PATH = @"/listings/:id/collect.json";
NSString * const DELETE_LISTING_PATH = @"/listings/:id/uncollect.json";

@interface RESTfulEngine()

@property (nonatomic, strong) NSString *uniqueID;

@end

@implementation RESTfulEngine

#pragma mark - 
#pragma mark - Part One: Load Listings Data

+ (void)loadListingsWithQuery:(NSDictionary *)queryParam onSucceeded:(ArrayBlock)succededBlock onError:(ErrorBlock)errorBlock
{
// 先检测是否应该从磁盘中获取内容
    if (![BlockCache shouldRequestWithBlock:queryParam]) {
        NSMutableArray *models = [BlockCache getCachedListingItemsWithBlock:queryParam];
        succededBlock(models);
        [BlockStates removeRequestingBlock:queryParam];
        if ([models count] != 0)
            [BlockStates addOnMapBlock:queryParam];
        return;
    }
    
// 若没有网络，应该直接告诉用户，然后终止API
    if (![self isConnectedToNetwork]) {
        [BlockStates removeRequestingBlock:queryParam];
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showImage:[UIImage imageNamed:@"erroricon"] status:@"No Internet connection"];
        });
        return;
    }

    
    NSMutableString *paramSubstring = [NSMutableString string];
    if (queryParam != nil) {
        NSString *key;
        int i = 0;
        for (i = 0; i < [queryParam.allKeys count]-1; i++) {
            key = queryParam.allKeys[i];
            [paramSubstring appendString:[NSString stringWithFormat:@"%@=%@&", key, queryParam[key]]];
        }
        key = queryParam.allKeys[i];
        [paramSubstring appendString:[NSString stringWithFormat:@"%@=%@", key, queryParam[key]]];
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
                    // 3 Call back
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [BlockStates removeRequestingBlock:queryParam];
                        if ([queryParam count] != 0) {
                            [BlockStates addOnMapBlock:queryParam];
                        }
                        succededBlock(models);
                    });
                }
            }
            else {
                [BlockStates removeRequestingBlock:queryParam];
                dispatch_async(dispatch_get_main_queue(), ^{
                    errorBlock(error);
                });
            }
        }
        else {
            [BlockStates removeRequestingBlock:queryParam];
            dispatch_async(dispatch_get_main_queue(), ^{
                errorBlock(error);
            });
        }
    }];
    [dataTask resume];
}

+ (void)loadListingDetailWithID:(int)idNumber
{
    if (![self isConnectedToNetwork]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showImage:[UIImage imageNamed:@"erroricon"] status:@"No Internet connection"];
        });
        return;
    }
    NSMutableString *urlString = [NSMutableString stringWithString:HOST_URL];
    [urlString appendString:@"/listings/"];
    [urlString appendString:[NSString stringWithFormat:@"%d.json", idNumber]];
    
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
                NSDictionary *detailJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
                DLog(@"DetailJSON - %@", detailJSON);
            }
        }
        else {
            DLog(@"Error : %@", error);
        }
    }];
    [dataTask resume];
}

#pragma mark -
#pragma mark - Part Two: Authentication

+ (void)loginWithName:(NSString*) loginName password:(NSString*) password onSucceeded:(VoidBlock)succeededBlock onError:(ErrorBlock)errorBlock
{
    if (![self isConnectedToNetwork]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showImage:[UIImage imageNamed:@"erroricon"] status:@"No Internet connection"];
        });
        errorBlock(nil);
        return;
    }
    // 1 Calculation
    NSString *uuidString = [NSString getCFUUID];
    NSDictionary *dict = @{@"username": loginName, @"password": password, @"client_uuid": uuidString, @"cityspade": @"CitySpade"};
    NSString *client_secret = [NSString sha1EncryptWithUnsortedStrings:dict];
    
    
    // 2 Construct the post param dictionary
    NSString *postHTTPBody = [NSString stringWithFormat:@"username=%@&password=%@&client_uuid=%@&client_secret=%@", loginName, password, uuidString, client_secret];
    
    // 3 Networking setup
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSMutableString *urlString = [NSMutableString stringWithString:HOST_URL];
    [urlString appendString:LOGIN_PATH];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[postHTTPBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    // 4 Networking operate
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (!error) {
            // 1 Serialize JSON
            NSError *jsonError;
            NSDictionary *loginFeedbackDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
            long statusCode = [loginFeedbackDict[@"status"] intValue];
            
            // 2 Get the status code
            if (statusCode == 200) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    // 3 Successfully login
                    NSString *token = loginFeedbackDict[@"token"];
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setObject:token forKey:kAccessToken];
                    [defaults synchronize];
                    [SVProgressHUD showSuccessWithStatus:@"Login Success!"];
                    
                    // 4 Callback
                    succeededBlock();
                });
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    DLog(@"Could not login - Status Code %ld", (long)httpResponse.statusCode);
                    NSString *errorInfo = loginFeedbackDict[@"error"];
                    [SVProgressHUD showErrorWithStatus:errorInfo];
                    errorBlock(nil);
                });
            }
        }
    }];
    
    [postDataTask resume];
}

+ (void)logoutOnSucceeded:(VoidBlock)succeededBlock onError:(ErrorBlock)errorBlock
{
    if (![self isConnectedToNetwork]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showImage:[UIImage imageNamed:@"erroricon"] status:@"No Internet connection"];
        });
        errorBlock(nil);
        return;
    }
    // 1 Get the token
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:kAccessToken];
    
    // 2 Set the body
    NSString *deleteBody = [NSString stringWithFormat:@"?token=%@", token];
    DLog(@"DELETE - %@", deleteBody);
    
    // 3 Networking setup
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSMutableString *urlString = [NSMutableString stringWithString:HOST_URL];
    [urlString appendString:LOGOUT_PATH];
    [urlString appendString:deleteBody];
    DLog(@"URLString - %@", urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"DELETE"];
    
    // 4 Networking Begin
    NSURLSessionDataTask *deleteDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (!error) {
            
            // 1 HTTP Response
            NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
            if (httpResp.statusCode == 200) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    // 3 Successfully logout
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults removeObjectForKey:kAccessToken];
                    [defaults synchronize];
                    [SVProgressHUD showSuccessWithStatus:@"Logout Success!"];
                    
                    // 4 Callback
                    succeededBlock();
                });
            }
            else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    errorBlock(nil);
                });
            }
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                errorBlock(nil);
            });
        }
    }];
    
    [deleteDataTask resume];
}

+ (void)registerWithUsername:(NSString *)userName password:(NSString *)password firstName:(NSString *)firstName lastName:(NSString *)lastName onSucceeded:(VoidBlock)succeedBlock onError:(ErrorBlock)errorBlock
{
    if (![self isConnectedToNetwork]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showImage:[UIImage imageNamed:@"erroricon"] status:@"No Internet connection"];
        });
        errorBlock(nil);
        return;
    }
    NSMutableString *postHTTPBody = [NSMutableString stringWithFormat:@"username=%@&password=%@", userName, password];
    if (firstName != nil)
        [postHTTPBody appendString:[NSString stringWithFormat:@"&firstname=%@", firstName]];
    if (lastName != nil)
        [postHTTPBody appendString:[NSString stringWithFormat:@"&lastname=%@", lastName]];
    
    // 3 Networking setup
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSMutableString *urlString = [NSMutableString stringWithString:HOST_URL];
    [urlString appendString:REGISTER_PATH];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[postHTTPBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    // 4 Networking operate
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
//        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (!error) {
            // 1 Serialize JSON
            NSError *jsonError;
            NSDictionary *registerFeedbackDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
            long statusCode = [registerFeedbackDict[@"status"] intValue];
            
            // 2 Get the status code
            if (statusCode == 200) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    // 3 Successfully login
                    NSString *token = registerFeedbackDict[@"token"];
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setObject:token forKey:kAccessToken];
                    [defaults synchronize];
                    [SVProgressHUD showSuccessWithStatus:@"Register Success"];
                    // 4 Callback
                    succeedBlock();
                });
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%ld", statusCode]];
                    errorBlock(nil);
                });
            }
        }
    }];
    
    [postDataTask resume];
}

#pragma mark -
#pragma mark - Part Three: Saving Lists

+ (void)loadUserSaveList:(ArrayBlock)succededBlock onError:(ErrorBlock)errorBlock;
{
    if (![self isConnectedToNetwork]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showImage:[UIImage imageNamed:@"erroricon"] status:@"No Internet connection"];
        });
        errorBlock(nil);
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:kAccessToken];
    NSString *paramSubstring = [NSString stringWithFormat:@"?token=%@",token];
    
    NSMutableString *urlString = [NSMutableString stringWithString:HOST_URL];
    [urlString appendString:SAVED_LISTING_PATH];
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
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSError *jsonError;
                    
                    // 2 Serialize json
                    NSMutableArray *listingsJSON =
                    [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
                    NSMutableArray *models = [NSMutableArray array];
                    for (id obj in listingsJSON) {
                        Listing *listing = [Listing modelObjectWithDictionary:obj];
                        [models addObject:listing];
                    }
                    if (!jsonError) {
                        // 3 Call back
                        
                        succededBlock(models);
                    }
                });
            }
            else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    errorBlock(error);
                });
            }
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                errorBlock(error);
            });
        }
    }];
    [dataTask resume];
}

+ (void)addAListingToSaveListWithId:(NSString *)idNumber onSucceeded:(VoidBlock)succeedBlock onError:(ErrorBlock)errorBlock
{
    if (![self isConnectedToNetwork]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showImage:[UIImage imageNamed:@"erroricon"] status:@"No Internet connection"];
        });
        errorBlock(nil);
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:kAccessToken];
    NSString *paramSubstring = [NSString stringWithFormat:@"?token=%@",token];
    
    NSString *tmpString = [NSString stringWithFormat:@"%@%@",HOST_URL,POST_LISTING_PATH];
    
    NSMutableString *urlString = (NSMutableString *)[tmpString stringByReplacingOccurrencesOfString:@":id" withString:idNumber];
    
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
                dispatch_async(dispatch_get_main_queue(), ^{
                succeedBlock();
                });
            }
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                errorBlock(error);
            });
        }
    }];
    [dataTask resume];
}

+ (void)deleteAListingFromSaveListWithId:(NSString *)idNumber onSucceeded:(VoidBlock)succeedBlock onError:(ErrorBlock)errorBlock
{
    if (![self isConnectedToNetwork]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showImage:[UIImage imageNamed:@"erroricon"] status:@"No Internet connection"];
        });
        errorBlock(nil);
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:kAccessToken];
    
    NSString *deleteBody = [NSString stringWithFormat:@"?token=%@", token];
    DLog(@"DELETE - %@", deleteBody);
    
    // 3 Networking setup
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSMutableString *tmpString = [NSMutableString stringWithString:HOST_URL];
    [tmpString appendString:DELETE_LISTING_PATH];
    NSMutableString *urlString = (NSMutableString *)[tmpString stringByReplacingOccurrencesOfString:@":id" withString:idNumber];
    
    [urlString appendString:deleteBody];
    DLog(@"URLString - %@", urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"DELETE"];
    
    // 4 Networking Begin
    NSURLSessionDataTask *deleteDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (!error) {
            
            // 1 HTTP Response
            NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
            if (httpResp.statusCode == 200) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    succeedBlock();
                });
            }
        }
        else {
                dispatch_async(dispatch_get_main_queue(), ^{
                errorBlock(error);
                DLog(@"Error : %@", error);
            });
            
        }
    }];
    
    [deleteDataTask resume];
}

#pragma mark - 
#pragma mark - Part Four: Facebook Authentication

+ (void)getFacebookInfoWithAccessToken:(NSString *)accessToken onSucceeded:(DictionaryBlock)succededBlock onError:(ErrorBlock)errorBlock
{
    if (![self isConnectedToNetwork]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showImage:[UIImage imageNamed:@"erroricon"] status:@"No Internet connection"];
        });
        errorBlock(nil);
        return;
    }
    NSMutableString *urlString = [NSMutableString stringWithString:@"https://graph.facebook.com/me?access_token="];
    [urlString appendString:accessToken];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession * session = [NSURLSession sessionWithConfiguration:config delegate:[FacebookDelegate sharedInstance] delegateQueue:nil];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            
            // 1 HTTP Response
            NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
            if (httpResp.statusCode == 200) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSError *jsonError;
                    
                    // 2 Serialize json
                    NSDictionary *userJSON =
                    [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
                    if (!jsonError) {
                        // 3 Call back
                        succededBlock(userJSON);
                    }
                });
            }
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                errorBlock(error);
            });
        }
    }];
    
    [dataTask resume];
}

+ (void)facebookCallbackWithEmail:(NSString *)email uid:(NSString *)uid onSucceeded:(VoidBlock)succeededBlock onError:(ErrorBlock)errorBlock
{
    if (![self isConnectedToNetwork]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showImage:[UIImage imageNamed:@"erroricon"] status:@"No Internet connection"];
        });
        errorBlock(nil);
        return;
    }
    // 1 Setup post body
    NSString *postHTTPBody = [NSString stringWithFormat:@"email=%@&uid=%@", email, uid];
    // 2 Networking setup
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSMutableString *urlString = [NSMutableString stringWithString:HOST_URL];
    [urlString appendString:CALLBACK_PATH];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[postHTTPBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    // 3 Networking operate
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (!error) {
            // 1 Serialize JSON
            NSError *jsonError;
            NSDictionary *loginFeedbackDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
            long statusCode = [loginFeedbackDict[@"status"] intValue];
            
            // 2 Get the status code
            if (statusCode == 200) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    // 3 Successfully login
                    NSString *token = loginFeedbackDict[@"token"];
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setObject:token forKey:kAccessToken];
                    [defaults synchronize];
                    [SVProgressHUD showSuccessWithStatus:@"Login success!"];
                    
                    // 4 Callback
                    succeededBlock();
                });
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    DLog(@"Could not login - Status Code %ld", (long)httpResponse.statusCode);
                    NSString *errorInfo = loginFeedbackDict[@"error"];
                    [SVProgressHUD showErrorWithStatus:errorInfo];
                    errorBlock(nil);
                });
                
                
            }
        }
    }];
    
    [postDataTask resume];
}

+ (BOOL)isConnectedToNetwork{
    
    //创建零地址，0.0.0.0的地址表示查询本机的网络连接状态
    
    struct sockaddr_storage zeroAddress;
    
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.ss_len = sizeof(zeroAddress);
    zeroAddress.ss_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    //获得连接的标志
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    //如果不能获取连接标志，则不能连接网络，直接返回
    if (!didRetrieveFlags)
    {
        return NO;
    }
    //根据获得的连接标志进行判断
    
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    return (isReachable&&!needsConnection) ? YES : NO;
}

@end