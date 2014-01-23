//
//  CTMapViewController.h
//  CitySpade
//
//  Created by Cho-Yeung Lam on 20/1/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CTMapView;
@class CTListView;

@interface CTMapViewController : UIViewController
@property (nonatomic, strong) CTMapView *ctmapView;
@property (nonatomic, strong) CTListView *ctlistView;

@end
