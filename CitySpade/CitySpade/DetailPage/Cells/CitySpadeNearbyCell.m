//
//  CitySpadeNearbyCell.m
//  CitySpadeDemo
//
//  Created by izhuxin on 14-3-19.
//  Copyright (c) 2014年 Jeason. All rights reserved.
//

#import "CitySpadeNearbyCell.h"
#import <MapKit/MapKit.h>

@interface CitySpadeNearbyCell ()
@property (nonatomic, strong) MKMapView *mapView;
@end

@implementation CitySpadeNearbyCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        if ( !_latitude ) {
            self.latitude = 23.063949;
            self.longtitude = 113.391223;
            
        }
        self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 300, 130)];
        
        CLLocationCoordinate2D location = CLLocationCoordinate2DMake(_latitude, _longtitude);
        CGFloat zoom = 0.01;
        MKCoordinateSpan span = MKCoordinateSpanMake(zoom, zoom);
        [_mapView setRegion:MKCoordinateRegionMake(location, span)];
        _mapView.scrollEnabled = _mapView.pitchEnabled = _mapView.zoomEnabled = NO;
        [self addSubview:_mapView];
    }
    return self;
}

- (void) setFrame:(CGRect)frame{
    frame.origin.x += 10;
    frame.size.width -= 20;
    [super setFrame:frame];
}


@end
