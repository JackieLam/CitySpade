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

//Part One
NSString * const HOST_URL = @"http://cityspade.com/api/v1";
NSString * const LISTINGS_PATH = @"/listings.json?";

//Part Two
NSString * const LOGIN_PATH = @"/auth/login.json";
NSString * const LOGOUT_PATH = @"/auth/logout.json";
NSString * const REGISTER_PATH = @"/auth/register.json";

//Part Three
NSString * const SAVED_LISTING_PATH = @"/account/savinglists.json";
//POST a listing to saved list is not a const string
//DELETE a listing from saved list is not a const string

@interface RESTfulEngine()

@property (nonatomic, strong) NSString *uniqueID;

@end

@implementation RESTfulEngine

#pragma mark - 
#pragma mark - Part One: Load Listings Data

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
                
                dispatch_async(dispatch_get_main_queue(), ^{
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
                        succededBlock(models);
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

+ (void)loadListingDetailWithID:(int)idNumber
{
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
                
            }
        }
        else {
            DLog(@"Error : %@", error);
        }
    }];
    
    [deleteDataTask resume];
}

+ (void)registerWithUsername:(NSString *)userName password:(NSString *)password firstName:(NSString *)firstName lastName:(NSString *)lastName onSucceeded:(VoidBlock)succeedBlock onError:(ErrorBlock)errorBlock
{
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
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
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

+ (void)loadUserSaveList
{
    
}

+ (void)addAListingToSaveListWithId:(double)idNumber
{

}

+ (void)deleteAListingFromSaveListWithId:(double)idNumber
{

}


@end