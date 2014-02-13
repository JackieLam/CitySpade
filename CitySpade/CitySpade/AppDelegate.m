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
    MFSideMenuContainerViewController *container = [MFSideMenuContainerViewController
                                                    containerWithCenterViewController:navController
                                                    leftMenuViewController:leftSideMenu
                                                    rightMenuViewController:rightSideMenu];
    container.panMode = MFSideMenuPanModeNone;
    container.shadow.enabled = NO;
//    [container toggleRightSideMenuCompletion:^{
//        //TODO: 右边视图push出来以后,给地图加黑
//    }];
    
// Set appearance
    [AppearanceSetter setBarButtonAppearance];
    self.window.rootViewController = container;
    [self.window makeKeyAndVisible];

    return YES;
}

@end
