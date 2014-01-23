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

//Bottom Bar
@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) UIButton *saveButton;
@property (strong, nonatomic) UIButton *currentLocationButton;
@property (strong, nonatomic) UIButton *listButton;
@property (strong, nonatomic) UIButton *localButton;

@end
