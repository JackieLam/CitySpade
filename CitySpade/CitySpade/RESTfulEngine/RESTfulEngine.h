//
//  RESTfulEngine.h
//  CitySpade
//
//  Created by Cho-Yeung Lam on 19/2/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Listing.h"

#define LOGIN_URL @"/auth/login.json"
#define LOGOUT_URL @"/auth/logout.json"
#define LISTINGS_URL @"/listings.json"

typedef void (^VoidBlock)(void);
typedef void (^ListingBlock)(Listing* aModelBaseObject);//生成的JSON不同在于，JSON Accelerator没有一个根的JSONModel
typedef void (^ArrayBlock)(NSMutableArray* listOfModelBaseObjects);
typedef void (^ErrorBlock)(NSError* engineError);

@interface RESTfulEngine : NSObject {
    NSString *_accessToken;
}

@property (nonatomic) NSString *accessToken;

-(id)loginWithName:(NSString*) loginName
          password:(NSString*) password
       onSucceeded:(VoidBlock) succeededBlock
           onError:(ErrorBlock) errorBlock;

-(id)logoutOnSucceeded:(VoidBlock)succeededBlock
               onError:(ErrorBlock)errorBlock;

@end
