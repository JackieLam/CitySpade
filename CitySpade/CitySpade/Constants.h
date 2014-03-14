//
//  Constants.h
//  GoGoPiao
//
//  Created by Cho-Yeung Lam on 7/10/13.
//  Copyright (c) 2013 Cho-Yeung Lam. All rights reserved.
//

#ifndef CONSTANTS_h
#define CONSTANTS_h

#pragma mark - NSUserDefaults

#define kAccessToken @"ACCESS_TOKEN"
#define kUserName @"USER_NAME"

#pragma mark - Debug Log

#ifdef DEBUG
#   define DLog(fmt, ...) {NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);}
#   define ELog(err) {if(err) DLog(@"%@", err)}
#else
#   define DLog(...)
#   define ELog(err)
#endif

#pragma mark - Notification

#define kNotificationLoginSuccess @"didLoginSuccess"
#define kNotificationRegisterSuccess @"didRegisterSuccess"
#define kNotificationToLoadAllListings @"toLoadForRentListing"
#define kNotificationToLoadFilteredListing @"toLoadFilteredListing"
#define kNotificationDidRightFilter @"didRightFilter"
#define kNotificationDidGetFacebookUserInfo @"didGetFacebookUserInfo"

#pragma mark - Other Constants

#define statusBarHeight 22.0f
#define navigationBarHeight 44.0f

#pragma mark - AppCache

#define kAppVersion @"APP_VERSION"
#define kListingsArchive @"LISTINGS_ARCHIVE.archives"

#endif