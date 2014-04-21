//
//  constant.h
//  CitySpadeDemo
//
//  Created by izhuxin on 14-4-7.
//  Copyright (c) 2014年 Jeason. All rights reserved.
//

#ifndef CitySpadeDemo_constant_h
#define CitySpadeDemo_constant_h

#define DEVICEVERSION [[[UIDevice currentDevice]systemVersion]floatValue]


static const CGFloat sessionHeaderFontSize = 15.0f;
static const NSUInteger memoryCacheCapacity = 20 * 4 * 10 * 1024;
static const NSUInteger diskCacheCapacity = 5 * 1024 * 1024;
static const NSInteger numberOfInfo = 4;
static const CGFloat headerHegiht = 35.0f;
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
static NSString const *listAPIRootURL = @"http://cityspade.com/api/v1/listings/";
#endif
