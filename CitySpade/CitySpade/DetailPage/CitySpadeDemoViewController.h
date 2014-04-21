//
//  CitySpadeDemoViewController.h
//  CitySpadeDemo
//
//  Created by izhuxin on 14-3-19.
//  Copyright (c) 2014年 Jeason. All rights reserved.
//

//////////////////////////////////////////////////
//preViewInfo should be look like:        //
//[                                             //
//  {                                           //
//      "bargain" : (NSNumber *) @(8.6),        //
//      "transportation":(NSNumber *) @(7.5),   //
//      "totalPrice": (NSNumber *) @"37500",    //
//      "numberOfBed": (NSNumber *) @"1",       //
//      "numberOfBath": (NSNumber *) @"1"       //
//   },                                         //
//  {                                           //
//      "lng": (NSNumber *) @"23.063949",       //
//      "lat": (NSNumber *) @"113.391223"       //
//                                              //
//  }                                           //
//]                                             //
//////////////////////////////////////////////////

#import <UIKit/UIKit.h>

@interface CitySpadeDemoViewController : UIViewController

//Assigned by the pre-ViewController
@property (nonatomic, copy) UIImage *featureImage;
@property (nonatomic, copy) NSArray *preViewInfo;
@property (nonatomic, copy) NSString *VCtitle;
@property (nonatomic, copy) NSString *listID;

@end
