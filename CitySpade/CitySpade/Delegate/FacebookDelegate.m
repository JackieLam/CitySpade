//
//  FacebookDelegate.m
//  CitySpade
//
//  Created by Cho-Yeung Lam on 25/2/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import "FacebookDelegate.h"
#import "Constants.h"
#import "RESTfulEngine.h"

@implementation FacebookDelegate

+ (FacebookDelegate *)sharedInstance
{
    static FacebookDelegate *sharedDelegate = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedDelegate = [[self alloc] init];
    });
    return sharedDelegate;
}

#pragma mark -
#pragma mark - Notify the session change

- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    if (!error && state == FBSessionStateOpen){
        NSLog(@"Session opened");
        [self userLoggedIn];
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        NSLog(@"Session closed");
        [self userLoggedOut];
    }
    
    if (error){
        NSLog(@"Error");
        NSString *alertText;
        NSString *alertTitle;
        // If the error requires people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
            [self showMessage:alertText withTitle:alertTitle];
        } else {
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                NSLog(@"User cancelled login");
                
                // Handle session closures that happen outside of the app
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
                [self showMessage:alertText withTitle:alertTitle];
                
                // For simplicity, here we just show a generic message for all other errors
                // You can learn how to handle other errors using our guide: https://developers.facebook.com/docs/ios/errors
            } else {
                //Get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // Show the user an error message
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
                [self showMessage:alertText withTitle:alertTitle];
            }
        }
        // Clear this token
        [FBSession.activeSession closeAndClearTokenInformation];
        // Show the user the logged-out UI
        [self userLoggedOut];
    }
}

- (void)userLoggedOut
{
    DLog(@"- (void)userLoggedOut");
}

- (void)userLoggedIn
{
    [self requestUserInfo];
}

- (void)requestUserInfo
{
    if (FBSession.activeSession.isOpen) {
        NSString *token = [FBSession activeSession].accessTokenData.accessToken;
        [RESTfulEngine getFacebookInfoWithAccessToken:token onSucceeded:^(NSDictionary *resultDictionary) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationDidGetFacebookUserInfo object:resultDictionary userInfo:nil];
        } onError:^(NSError *engineError) {
            
            DLog(@"Engine Error : %@", engineError);
        }];
    }
}

#pragma mark - 
#pragma mark - Setup trust for the Facebook Graph API

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler{
    if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]){
        if([challenge.protectionSpace.host isEqualToString:@"graph.facebook.com"]){
            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential,credential);
        }
    }
}

#pragma mark - 
#pragma mark - UIAlertView Helper Method

- (void)showMessage:(NSString *)text withTitle:(NSString *)title
{
    [[[UIAlertView alloc] initWithTitle:@""
                                message:@"You're now logged out"
                               delegate:self
                      cancelButtonTitle:@"OK!"
                      otherButtonTitles:nil] show];
}

@end
