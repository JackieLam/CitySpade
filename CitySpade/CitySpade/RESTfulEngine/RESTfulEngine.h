//
//  RESTfulEngine.h
//  CitySpade
//
//  Created by Cho-Yeung Lam on 19/2/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^VoidBlock)(void);
typedef void (^ArrayBlock)(NSMutableArray* resultArray);
typedef void (^ErrorBlock)(NSError* engineError);

@interface RESTfulEngine : NSObject {
    NSString *_accessToken;
}

@property (nonatomic) NSString *accessToken;

//+ (void)loginWithName:(NSString*) loginName
//          password:(NSString*) password
//       onSucceeded:(VoidBlock) succeededBlock
//           onError:(ErrorBlock) errorBlock;
//
//+ (void)logoutOnSucceeded:(VoidBlock)succeededBlock
//               onError:(ErrorBlock)errorBlock;

+ (void)loadListingsWithQuery:(NSDictionary *)queryParam onSucceeded:(ArrayBlock)succededBlock onError:(ErrorBlock)errorBlock;

@end
