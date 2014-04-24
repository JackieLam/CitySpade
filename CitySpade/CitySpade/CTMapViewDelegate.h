//
//  CTMapViewDelegate.h
//  CitySpade
//
//  Created by Cho-Yeung Lam on 16/3/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CTMapViewDelegate : NSObject<MKMapViewDelegate,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic) BOOL forRent;
@property (nonatomic) double zoomLevel;
@property (nonatomic, strong) NSMutableSet *requestBlocks;

+ (CTMapViewDelegate *)sharedInstance;

@end