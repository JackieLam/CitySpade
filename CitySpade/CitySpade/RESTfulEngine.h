//
//  RESTfulEngine.h
//  CitySpade
//
//  Created by Cho-Yeung Lam on 19/2/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//
//  About posting a url
//  http://stackoverflow.com/questions/19099448/send-post-request-using-nsurlsession

#import <Foundation/Foundation.h>

typedef void (^VoidBlock)(void);
typedef void (^ArrayBlock)(NSMutableArray* resultArray);
typedef void (^DictionaryBlock)(NSDictionary *resultDictionary);
typedef void (^ErrorBlock)(NSError* engineError);

@interface RESTfulEngine : NSObject {
    NSString *_accessToken;
}

@property (nonatomic) NSString *accessToken;

////Shared Instance
//+(RESTfulEngine *)sharedInstance;

//Part One: Load the content of the list
+ (void)loadListingsWithQuery:(NSDictionary *)queryParam onSucceeded:(ArrayBlock)succededBlock onError:(ErrorBlock)errorBlock;

+ (void)loadListingDetailWithID:(int)idNumber;

//Part Two: Authentication
+ (void)loginWithName:(NSString*) loginName
          password:(NSString*) password
       onSucceeded:(VoidBlock) succeededBlock
           onError:(ErrorBlock) errorBlock;

+ (void)logoutOnSucceeded:(VoidBlock)succeededBlock
               onError:(ErrorBlock)errorBlock;

+ (void)registerWithUsername:(NSString *)userName
                    password:(NSString *)password
                   firstName:(NSString *)firstName
                    lastName:(NSString *)lastName
                 onSucceeded:(VoidBlock)succeedBlock
                     onError:(ErrorBlock)errorBlock;

//Part Three: Save Listings
+ (void)loadUserSaveList:(ArrayBlock)succededBlock onError:(ErrorBlock)errorBlock;
+ (void)addAListingToSaveListWithId:(NSString *)idNumber onSucceeded:(VoidBlock)succeedBlock onError:(ErrorBlock)errorBlock;
+ (void)deleteAListingFromSaveListWithId:(NSString *)idNumber onSucceeded:(VoidBlock)succeedBlock onError:(ErrorBlock)errorBlock;

//Part Four: Facebook Authentication
+ (void)getFacebookInfoWithAccessToken:(NSString *)accessToken onSucceeded:(DictionaryBlock)succeedBlock onError:(ErrorBlock)errorBlock;
+ (void)facebookCallbackWithEmail:(NSString *)email uid:(NSString *)uid onSucceeded:(VoidBlock)succeededBlock onError:(ErrorBlock)errorBlock;

//Part Five: 

@end