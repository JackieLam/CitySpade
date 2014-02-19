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

//static NSString *const kAPIKey = @"AIzaSyBscWl3wXUk_Lyfqo1kz8Nljjf2K0-7eCY";

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    [GMSServices provideAPIKey:kAPIKey];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

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
    
// Set appearance
    [AppearanceSetter setBarButtonAppearance];
    [AppearanceSetter setSearchBarAppearance];
    self.window.rootViewController = container;
    [self.window makeKeyAndVisible];

    return YES;
}

@end