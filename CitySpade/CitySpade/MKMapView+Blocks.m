//
//  MKMapView+size.m
//  CitySpade
//
//  Created by Cho-Yeung Lam on 21/4/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import "MKMapView+Blocks.h"

#define tileWidthiPhone 11036.124
#define tileHeightiPhone4 14346.9609
#define tileHeightiPhone5 17381.8945
#define maxBlockThersold 40 // 表示放大到一定程度后，不产生网络请求

@implementation MKMapView (Blocks)

- (NSArray *)blocksParamWithSize:(int)size
{
    NSMutableArray *resultArray = [NSMutableArray array];
    double tileX = self.visibleMapRect.origin.x;
    double tileY = self.visibleMapRect.origin.y;
    double tileWidth = tileWidthiPhone;
    double tileHeight;
    
    double deviceHeight = [UIScreen mainScreen].bounds.size.height;
    if (deviceHeight == 568)
        tileHeight = tileHeightiPhone5;
    else
        tileHeight = tileHeightiPhone4;
    
    double tileStartX = floorf(tileX/tileWidth)*tileWidth;
    //startX坐标点
    double tileStartY = floorf(tileY/tileHeight)*tileHeight + tileHeight;
    
    
    int numberOfTileWidth = ceil(self.visibleMapRect.size.width/tileWidth)+1;
    int numberOfTileHeight = ceil(self.visibleMapRect.size.height/tileHeight)+1;
    
    for (int i = 0; i < numberOfTileHeight; i++) {
        MKMapPoint swMapPoint = MKMapPointMake(tileStartX, tileStartY + tileHeight * i);
        NSMutableDictionary *tmp = [self paramDictWithSWMapPoint:swMapPoint tileWidth:tileWidth tileHeight:tileHeight];
        [resultArray addObject:tmp];
        // 重新计算每行的起始点
        for (int cnt = 1; cnt < numberOfTileWidth; cnt++) {
            swMapPoint.x += tileWidth;
            [resultArray addObject:[self paramDictWithSWMapPoint:swMapPoint tileWidth:tileWidth tileHeight:tileHeight]];
            if ([resultArray count] > maxBlockThersold) {
                [resultArray removeAllObjects];
                return resultArray;
            }
        }
    }
    
    return resultArray;
}

- (NSMutableDictionary *)paramDictWithSWMapPoint:(MKMapPoint)swMapPoint tileWidth:(double)tileWidth tileHeight:(double)tileHeight
{
    NSString *swLatKey = @"southwestlat";
    NSString *swLngKey = @"southwestlng";
    NSString *neLatKey = @"northeastlat";
    NSString *neLngKey = @"northeastlng";
    
    MKMapPoint neMapPoint;
    neMapPoint.x = swMapPoint.x + tileWidth;
    neMapPoint.y = swMapPoint.y - tileHeight;
    
    CLLocationCoordinate2D swCoor = MKCoordinateForMapPoint(swMapPoint);
    CLLocationCoordinate2D neCoor = MKCoordinateForMapPoint(neMapPoint);
    NSString *swLatString = [NSString stringWithFormat:@"%lf", swCoor.latitude];
    NSString *swLngString = [NSString stringWithFormat:@"%lf", swCoor.longitude];
    NSString *neLatString = [NSString stringWithFormat:@"%lf", neCoor.latitude];
    NSString *neLngString = [NSString stringWithFormat:@"%lf", neCoor.longitude];
    
    NSMutableDictionary *resultDict = [NSMutableDictionary dictionaryWithDictionary:@{swLatKey: swLatString, swLngKey: swLngString, neLatKey: neLatString, neLngKey: neLngString}];
    return resultDict;
}

@end
