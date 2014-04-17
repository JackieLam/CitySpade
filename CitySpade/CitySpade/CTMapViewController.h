//
//  CTMapViewController.h
//  CitySpade
//
//  Created by Cho-Yeung Lam on 20/1/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class REVClusterMapView;
@class CTListView;
@class MapBottomBar;

@interface CTMapViewController : UIViewController

@property (nonatomic, strong) REVClusterMapView *ctmapView;
@property (nonatomic, strong) MapBottomBar *mapBottomBar;
@property (nonatomic, strong) CTListView *ctlistView;
@property (nonatomic, strong) UICollectionView *collectionView;

@end
