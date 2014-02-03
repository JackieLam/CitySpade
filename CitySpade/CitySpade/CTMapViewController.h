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

@interface CTMapViewController : UIViewController<MKMapViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) REVClusterMapView *ctmapView;
@property (nonatomic, strong) CTListView *ctlistView;

@end
