//
//  CTMapView.h
//  CitySpade
//
//  Created by Cho-Yeung Lam on 22/1/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GMSMapView;

@interface CTMapView : UIView

@property (strong, nonatomic) GMSMapView *mapView;
@property (strong, nonatomic) UIButton *listButton; 

@end
