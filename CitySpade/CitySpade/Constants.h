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

#pragma mark - Debug Log

#ifdef DEBUG
#   define DLog(fmt, ...) {NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);}
#   define ELog(err) {if(err) DLog(@"%@", err)}
#else
#   define DLog(...)
#   define ELog(err)
#endif

#endif