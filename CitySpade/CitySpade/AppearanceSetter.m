//
//  AppearanceSetter.m
//  CitySpade
//
//  Created by Cho-Yeung Lam on 9/2/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import "AppearanceSetter.h"

@implementation AppearanceSetter

+ (void)setBarButtonAppearance
{
    [[UIBarButtonItem appearance] setTintColor:[UIColor colorWithRed:133.0/255.0 green:131.0/255.0 blue:132.0/255.0 alpha:1.0f]];
}

+ (void)setNavigationAppearance
{
//    [[UINavigationBar appearance] z:@{UITextAttributeTextColor: [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0], UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, -1)], UITextAttributeFont: [UIFont fontWithName:@"Arial-Bold" size:0.0],}];
}

+ (void)setSearchBarAppearance
{
    //UISearchBar -- Background
    [[UISearchBar appearance] setSearchFieldBackgroundImage:[UIImage imageNamed:@"searchBar_bg"] forState:UIControlStateNormal];
    [[UISearchBar appearance] setSearchFieldBackgroundImage:[UIImage imageNamed:@"searchBar_bg"] forState:UIControlStateDisabled];
    [[UISearchBar appearance] setBackgroundImage:[UIImage imageNamed:@"search_bg.png"]];
    
    //UISearchBar -- Mag Icon
//    [[UISearchBar appearance] setImage:[UIImage imageNamed:@"searchBar_icon"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
//    [[UISearchBar appearance] setImage:[UIImage imageNamed:@"searchBar_icon"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateSelected];
    
    //UISearchBar -- Font and Text Attribute
    [[UISearchBar appearance] setScopeBarButtonTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor redColor], NSForegroundColorAttributeName,[UIFont fontWithName:@"Avenir-Heavy" size:12.5f], NSFontAttributeName, nil] forState:UIControlStateNormal|UIControlStateSelected];
}

@end
