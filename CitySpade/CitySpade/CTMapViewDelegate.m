//
//  CTMapViewDelegate.m
//  CitySpade
//
//  Created by Cho-Yeung Lam on 16/3/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import "CTMapViewDelegate.h"
#import "REVClusterMap.h"
#import "Constants.h"
#import "MapCollectionCell.h"
#import "RESTfulEngine.h"
#import "MKMapView+Blocks.h"
#import "BlockCache.h"
#import "BlockStates.h"

#define cellHeight 231.0f //130.0f
#define cellWidth 320.0f //290.0f
#define cellGap 0.0f //20.0f
#define maxBlockThersold 40 // 表示放大到一定程度后，不产生网络请求

@interface CTMapViewDelegate()

@property (nonatomic, strong) NSArray *placesClicked;

@end

@implementation CTMapViewDelegate

+ (CTMapViewDelegate *)sharedInstance
{
    static CTMapViewDelegate *sharedDelegate = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedDelegate = [[self alloc] init];
    });
    return sharedDelegate;
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    NSArray *arr = [mapView blocksParamWithSize:4];
#warning 临时性代码 - 限定放大以后不产生网络请求
    if ([arr count] > maxBlockThersold) return;
    
    int cnt = 0;
    for (int i = 0; i < [arr count]; i++) {
        
        arr[i][@"rent"] = [NSNumber numberWithBool:self.forRent];
        
        if (![BlockStates blockIsOnMap:arr[i]] && ![BlockStates blockIsRequesting:arr[i]]) {
            [BlockStates addRequestingBlock:arr[i]];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationToLoadAllListings object:arr[i]];
            cnt++;
        }
    }
    
    NSLog(@"REPORT : Request number - %d", cnt);
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if([annotation class] == MKUserLocation.class) {
		return nil;
	}
    REVClusterPin *pin = (REVClusterPin *)annotation;
    
    MKAnnotationView *annView;
    annView = (REVClusterAnnotationView*)
    [mapView dequeueReusableAnnotationViewWithIdentifier:@"cluster"];
    if( !annView )
        annView = (REVClusterAnnotationView*)
        [[REVClusterAnnotationView alloc] initWithAnnotation:annotation
                                             reuseIdentifier:@"cluster"];
    [(REVClusterAnnotationView *)annView configureAnnotationView:[pin nodeCount]];
    return annView;
}

- (void)mapView:(MKMapView *)mapView
didSelectAnnotationView:(MKAnnotationView *)view
{
    REVClusterPin *annotation = (REVClusterPin *)view.annotation;
    if (annotation.nodes == nil) self.placesClicked = [NSArray arrayWithObject:annotation];
    else
        self.placesClicked = [NSArray arrayWithArray:annotation.nodes];
    //zoom in if click on a cluster less than 20
    if ([annotation.nodes count] > 20) {
        CLLocationCoordinate2D centerCoordinate = [annotation coordinate];
        MKCoordinateSpan newSpan = MKCoordinateSpanMake(mapView.region.span.latitudeDelta/2.0, mapView.region.span.longitudeDelta/2.0);
        [mapView setRegion:MKCoordinateRegionMake(centerCoordinate, newSpan)
                  animated:YES];
    }
    else {
        [[NSNotificationCenter defaultCenter] postNotificationName:kCollectionViewShouldShowUp object:nil userInfo:nil];
    }
    [mapView deselectAnnotation:view.annotation animated:YES];
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    //do nothing
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kPathOverLayShouldBeAdded object:views userInfo:nil];
}


#pragma mark - UICollectionView DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.placesClicked count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"mapCollectionCell";
    MapCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[MapCollectionCell alloc] initWithFrame:CGRectMake(0, 0, cellWidth+cellGap, cellHeight)];
    }
    int count = (int)[indexPath row];
    [cell configureCellWithClusterPin:self.placesClicked[count]];
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(cellWidth+cellGap, cellHeight);
}

@end
