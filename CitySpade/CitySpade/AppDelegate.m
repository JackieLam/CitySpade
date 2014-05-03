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
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    CTLeftSideMenuViewController *leftSideMenu = [[CTLeftSideMenuViewController alloc] init];
    CTFilterViewController *rightSideMenu = [[CTFilterViewController alloc] init];
    CTMapViewController *mapViewController = [[CTMapViewController alloc] init];
    UINavigationController *filterNavController = [[UINavigationController alloc] initWithRootViewController:rightSideMenu];
    filterNavController.navigationBar.opaque = YES;
    filterNavController.navigationBar.translucent = NO;
    [filterNavController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar_shadow"] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [filterNavController.navigationBar setShadowImage:[UIImage new]];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:mapViewController];
    navController.navigationBar.opaque = YES;
    navController.navigationBar.translucent = NO;
    [navController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar_shadow"] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [navController.navigationBar setShadowImage:[UIImage new]];
    
    MFSideMenuContainerViewController *container = [MFSideMenuContainerViewController
                                                    containerWithCenterViewController:navController
                                                    leftMenuViewController:leftSideMenu
                                                    rightMenuViewController:filterNavController];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(menuStateEventOccurred:)
                                                 name:MFSideMenuStateNotificationEvent
                                               object:nil];
    
    container.panMode = MFSideMenuPanModeNone;
    container.shadow.enabled = NO;
    
// Set appearance
    [AppearanceSetter setBarButtonAppearance];
    [AppearanceSetter setSearchBarAppearance];
    
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

#pragma mark - MFSideMenu Event
- (void)menuStateEventOccurred:(NSNotification *)notification {
    MFSideMenuContainerViewController *containerViewController = notification.object;
    if (containerViewController.menuState == MFSideMenuStateLeftMenuOpen) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    else if (containerViewController.menuState == MFSideMenuStateClosed) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
}

@end