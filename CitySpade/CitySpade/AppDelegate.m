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
#import <FacebookSDK/FacebookSDK.h>
#import "CTSavingsViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [NSThread sleepForTimeInterval:1.0f];
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    CTSavingsViewController *savingVC = [[CTSavingsViewController alloc] init];
    CTLeftSideMenuViewController *leftSideMenu = [[CTLeftSideMenuViewController alloc] init];
    CTFilterViewController *rightSideMenu = [[CTFilterViewController alloc] init];
    CTMapViewController *mapViewController = [[CTMapViewController alloc] init];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:mapViewController];
//    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:savingVC];
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
    
// Set appearance
    [AppearanceSetter setBarButtonAppearance];
    [AppearanceSetter setSearchBarAppearance];
    
// test
//    self.window.rootViewController = navController;
    self.window.rootViewController = container;
    [self.window makeKeyAndVisible];

    return YES;
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