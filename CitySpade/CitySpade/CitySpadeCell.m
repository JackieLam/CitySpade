//
//  CitySpadeCell.m
//  CitySpadeDemo
//
//  Created by izhuxin on 14-3-19.
//  Copyright (c) 2014年 Jeason. All rights reserved.
//

#import "CitySpadeCell.h"
#import "CitySpadeBasicFactsCell.h"
#import "CitySpadeTransportationInfoCell.h"
#import "CitySpadeBrokerInfoCell.h"
#import "CitySpadeNearbyCell.h"
#import "TransportationSubwayCell.h"
#import "TransportationBuslinesCell.h"
#import "TransportationListCell.h"

@implementation CitySpadeCell

- (instancetype)initWithFrame:(CGRect)frame {
    frame = CGRectMake(frame.origin.x + 10, frame.origin.y, frame.size.width - 20, frame.size.height);
    self = [super initWithFrame:frame];
    if ( self ) {
        
    }
    return self;
}

+ (instancetype)TabelCellWithInfoTitle: (InfoTitles)title {
    
    switch ( title ) {
        case Basic_Facts:
            return [CitySpadeBasicFactsCell new];
            break;
        
        case Transportation_Info:
            return [CitySpadeTransportationInfoCell new];
            break;
            
        case Broker_Info:
            return [CitySpadeBrokerInfoCell new];
            break;
        case Nearby:
            return [CitySpadeNearbyCell new];
            break;
        case Subway_Lines:
            return [TransportationSubwayCell new];
            break;
        case Buslines:
            return [TransportationBuslinesCell new];
            break;
        case Hottest_Spots:
        case Colleages:
            return [TransportationListCell new];
            break;
        
        //if the title is none of above, crash the app
            
    }
    return nil;
}

- (void)ConfigureCellWithItem: (NSDictionary *)dictionary {
    //abstract
}

@end
