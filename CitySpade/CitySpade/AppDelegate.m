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
#import <MFSideMenu.h>
#import <GoogleMaps/GoogleMaps.h>

static NSString *const kAPIKey = @"AIzaSyBscWl3wXUk_Lyfqo1kz8Nljjf2K0-7eCY";

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [GMSServices provideAPIKey:kAPIKey];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    CTLeftSideMenuViewController *leftSideMenu = [[CTLeftSideMenuViewController alloc] init];
    CTLeftSideMenuViewController *rightSideMenu = [[CTLeftSideMenuViewController alloc] init];
    CTMapViewController *mapViewController = [[CTMapViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:mapViewController];
    MFSideMenuContainerViewController *container = [MFSideMenuContainerViewController
                                                    containerWithCenterViewController:navController
                                                    leftMenuViewController:leftSideMenu
                                                    rightMenuViewController:rightSideMenu];

    self.window.rootViewController = container;
    [self.window makeKeyAndVisible];

    return YES;

}

@end
