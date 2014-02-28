//
//  FacebookDelegate.h
//  CitySpade
//
//  Created by Cho-Yeung Lam on 25/2/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

@interface FacebookDelegate : NSObject<NSURLSessionDelegate>

+ (FacebookDelegate *)sharedInstance;

- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error;
- (void)userLoggedIn;
- (void)userLoggedOut;

@end
