//
//  AppDelegate.m
//  CitySpade
//
//  Created by Cho-Yeung Lam on 20/1/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import "AppDelegate.h"
#import "CTMapViewController.h"
#import "CTLeftSideMenuViewController.h"
#import "CTDetailViewController.h"
#import "CTFilterViewController.h"
#import <MFSideMenu.h>
#import "REVClusterMapView.h"
#import "AppearanceSetter.h"
#import "CTLoginViewController.h"
#import "Constants.h"

//static NSString *const kAPIKey = @"AIzaSyBscWl3wXUk_Lyfqo1kz8Nljjf2K0-7eCY";

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    [GMSServices provideAPIKey:kAPIKey];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];

    CTLeftSideMenuViewController *leftSideMenu = [[CTLeftSideMenuViewController alloc] init];
    CTFilterViewController *rightSideMenu = [[CTFilterViewController alloc] init];
    CTMapViewController *mapViewController = [[CTMapViewController alloc] init];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:mapViewController];
    navController.navigationBar.opaque = YES;
    navController.navigationBar.translucent = NO;
    [navController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar_shadow"] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [navController.navigationBar setShadowImage:[UIImage new]];
    
    MFSideMenuContainerViewController *container = [MFSideMenuContainerViewController
                                                    containerWithCenterViewController:navController
                                                    leftMenuViewController:leftSideMenu
                                                    rightMenuViewController:rightSideMenu];
    container.panMode = MFSideMenuPanModeNone;
    container.shadow.enabled = NO;

//    CTDetailViewController *tempVC = [[CTDetailViewController alloc] init];
//    UINavigationController *tempNav = [[UINavigationController alloc] initWithRootViewController:tempVC];
//    tempNav.navigationBar.opaque = YES;
//    tempNav.navigationBar.translucent = NO;
    CTLoginViewController *loginVC = [[CTLoginViewController alloc] initWithNibName:@"CTLoginViewController" bundle:nil];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:loginVC];
    navi.navigationBar.opaque = YES;
    navi.navigationBar.translucent = NO;
    [navi.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar_shadow"] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [navi.navigationBar setShadowImage:[UIImage new]];
    
// Set appearance
    [AppearanceSetter setBarButtonAppearance];
    [AppearanceSetter setSearchBarAppearance];
    self.window.rootViewController = navi;
//    self.window.rootViewController = container;
    [self.window makeKeyAndVisible];

    return YES;
}

// This method will handle ALL the session state changes in the app
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    // If the session was opened successfully
    if (!error && state == FBSessionStateOpen){
        NSLog(@"Session opened");
        // Show the user the logged-in UI
        [self userLoggedIn];
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        // If the session is closed
        NSLog(@"Session closed");
        // Show the user the logged-out UI
        [self userLoggedOut];
    }
    
    // Handle errors
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

// Show the user the logged-out UI
- (void)userLoggedOut
{
    DLog(@"- (void)userLoggedOut");
    [self showMessage:@"You're now logged out" withTitle:@""];
}

// Show the user the logged-in UI
- (void)userLoggedIn
{
    DLog(@"- (void)userLoggedIn");
    [self showMessage:@"You're now logged in" withTitle:@"Welcome!"];
}

// Show an alert message
- (void)showMessage:(NSString *)text withTitle:(NSString *)title
{
    [[[UIAlertView alloc] initWithTitle:title
                                message:text
                               delegate:self
                      cancelButtonTitle:@"OK!"
                      otherButtonTitles:nil] show];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [FBSession.activeSession handleOpenURL:url];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [FBAppCall handleDidBecomeActive];
}

@end