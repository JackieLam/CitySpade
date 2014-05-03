//
//  CitySpadeNearbyCell.m
//  CitySpadeDemo
//
//  Created by izhuxin on 14-3-19.
//  Copyright (c) 2014年 Jeason. All rights reserved.
//

#import "CitySpadeNearbyCell.h"
#import "REVClusterMap.h"
#import <MapKit/MapKit.h>

@interface CitySpadeNearbyCell ()<MKMapViewDelegate>

@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic) CGFloat latitude;
@property (nonatomic) CGFloat longtitude;
@property (nonatomic) CGFloat zoom;

@end

@implementation CitySpadeNearbyCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        if ( !self.locationDictionary ) {
            self.latitude = 23.063949;
            self.longtitude = 113.391223;
        }
        self.longtitude = [self.locationDictionary[@"lng"] floatValue];
        self.latitude = [self.locationDictionary[@"lat"] floatValue];
        self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 300, 130)];
        //触发viewForAnnotation
        CLLocationCoordinate2D location = CLLocationCoordinate2DMake(_latitude, _longtitude);
        CGFloat zoom = 0.01;
        MKCoordinateSpan span = MKCoordinateSpanMake(zoom, zoom);
        [_mapView setRegion:MKCoordinateRegionMake(location, span)];
        _mapView.scrollEnabled = _mapView.pitchEnabled = _mapView.zoomEnabled = NO;
        REVClusterPin *pin = [[REVClusterPin alloc] init];
        pin.coordinate = location;
        [_mapView addAnnotation:pin];
        _mapView.delegate = self;
        [self addSubview:_mapView];
    }
    return self;
}

- (void) setFrame:(CGRect)frame{
    frame.origin.x += 10;
    frame.size.width -= 20;
    [super setFrame:frame];
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
    annView.image = [UIImage imageNamed:@"pin"];
    return annView;
}

- (void)setLocationDictionary:(NSDictionary *)locationDictionary
{
    if (!_locationDictionary)
        _locationDictionary = [NSDictionary dictionary];
    _locationDictionary = locationDictionary;
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake([_locationDictionary[@"lat"] floatValue], [_locationDictionary[@"lng"] floatValue]);
    [_mapView setRegion:MKCoordinateRegionMakeWithDistance(location, 500, 500)];
    REVClusterPin *pin = [[REVClusterPin alloc] init];
    pin.coordinate = location;
    [_mapView addAnnotation:pin];
}
@end
