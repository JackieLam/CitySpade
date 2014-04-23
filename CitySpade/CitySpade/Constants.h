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
//In the main view(map)
#define kCollectionViewShouldShowUp @"CollectionViewShouldShowUp"
#define kPathOverLayShouldBeAdded @"PathOverLayShouldBeAdded"
#define kShouldPushDetailViewController @"ShouldPushDetailViewController"
//In the mysave view
#define kNotificationAddSaveListing  @"addSaveListing"
#define kNotificationDeleteSaveListing  @"deleteSaveListing"
#define kNotificationDidModifySaveListing  @"didModifySaveListing"

#pragma mark - Other Constants

#define statusBarHeight 22.0f
#define navigationBarHeight 44.0f

#pragma mark - AppCache

#define kAppVersion @"APP_VERSION"
#define kListingsArchive @"LISTINGS_ARCHIVE.archives"

#pragma mark - DetailView

#define DEVICEVERSION [[[UIDevice currentDevice]systemVersion]floatValue]
#define CitySpadeDownloadImageFinished @"CitySpadeDownloadImageFinished"

static const CGFloat sessionHeaderFontSize = 15.0f;
static const NSUInteger memoryCacheCapacity = 20 * 4 * 10 * 1024;
static const NSUInteger diskCacheCapacity = 5 * 1024 * 1024;
static const NSInteger numberOfInfo = 4;
static const CGFloat headerHegiht = 33.0f;
static const CGFloat listLineHeight = 18.0f;
static const CGFloat nameFrameSizeHeight = 26.0f;
static const CGFloat linesLeading = 5.0f;
static const CGFloat edgeLeading = 7.0f;
static const CGFloat featureImageCellHeight = 170.0f;
static const CGFloat basicFactsCellHeight = 60.0f;
static const CGFloat brokerInfoCellHeight = 75.0f;
static const CGFloat nearbyCellHeight = 130.0f;
static const NSUInteger numberOfBusInOneLine = 8;
static const CGFloat heightForOneBusesLine = 36.0f;
static const NSUInteger inset = 10;
static const CGFloat transportIconSize = 18.0f;

#endif