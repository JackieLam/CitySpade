//
//  CitySpadeListsModel.m
//  CitySpadeDemo
//
//  Created by izhuxin on 14-4-7.
//  Copyright (c) 2014年 Jeason. All rights reserved.
//

#import "CitySpadeListsModel.h"
#import "CitySpadeRequestHandler.h"
#import "Constants.h"

@interface CitySpadeListsModel()

@property (readwrite) BOOL fetchListCompleted;
@property (nonatomic, strong) NSString *listAPI;
@end

@implementation CitySpadeListsModel

- (instancetype)initWithAPI: (NSString *)listAPI {
    self = [super init];
    if ( self ) {
        self.listAPI = listAPI;
        self.fetchListCompleted = NO;
    }
    return self;
}

- (void)beginFetchListWithCompletionHandler:(void (^)(NSDictionary *resultDictionary))completionHandler{
    NSURL *listURL = [NSURL URLWithString:_listAPI];
    CitySpadeRequestHandler *handler = [[CitySpadeRequestHandler alloc] init];
    
    [handler fetchListingForURL:listURL WithCompletionHandler:^(NSDictionary *listDictionary) {
        [self handlerListDictionary:listDictionary];
        completionHandler( _infoDictionary );
        
    }];

}

- (void)handlerListDictionary:(NSDictionary *)listDicionary {
    NSLog(@"featch listing...");
    NSMutableDictionary *tempMutableDic = [listDicionary mutableCopy];
    
    //subways
    NSArray *subwaysArray = [self configureSubwaysArrayInDictionary:tempMutableDic];
    CGFloat subwayCellHeight = 0;
    if ( [subwaysArray count] != 0 ) {
        //height
        subwayCellHeight = nameFrameSizeHeight + listLineHeight * [subwaysArray count] + linesLeading * ( [subwaysArray count] - 1 ) + edgeLeading * 2;
    }
    [tempMutableDic setObject:@(subwayCellHeight) forKey:@"subwayCellHeight"];
    
    [tempMutableDic setObject:subwaysArray
                       forKey:@"subwaysArray"];
    
    //hottest Spots
    NSArray *hottestSpotsArray = tempMutableDic[@"hottest_spots"];
    CGFloat hottestSpotCellHeight = 0;
    if ( [hottestSpotsArray count] != 0 ) {
        hottestSpotCellHeight = nameFrameSizeHeight + listLineHeight * [hottestSpotsArray count] + linesLeading * ([hottestSpotsArray count]-1) + edgeLeading * 2;
    }
    [tempMutableDic setObject:@(hottestSpotCellHeight)
                       forKey:@"hottestSpotCellHeight"];
    
    //colleages
    NSArray *colleagesArray = tempMutableDic[@"colleges"];
    CGFloat colleagesCellHeight = 0;
    if ( [colleagesArray count] != 0 ) {
        colleagesCellHeight = nameFrameSizeHeight + listLineHeight*[colleagesArray count] + linesLeading*([colleagesArray count]-1) + edgeLeading*2;
    }
    [tempMutableDic setObject:@(colleagesCellHeight)
                       forKey:@"colleagesCellHeight"];

    //busline
    NSArray *busArray = tempMutableDic[@"bus_lines"];
    CGFloat buslineCellHeight = 0;
    if ( [busArray count] != 0 ) {
        buslineCellHeight = ([busArray count]/ numberOfBusInOneLine + 1) * heightForOneBusesLine;
    }
    [tempMutableDic setObject:@(buslineCellHeight)
                       forKey:@"buslineCellHeight"];

    //all have down
    NSNumber *transportationCellHeight = @( subwayCellHeight + buslineCellHeight + hottestSpotCellHeight + colleagesCellHeight );
    [tempMutableDic setObject:transportationCellHeight forKey:@"transportationCellHeight"];
    
    self.infoDictionary = tempMutableDic;
}

- (NSArray *)configureSubwaysArrayInDictionary: (NSDictionary *)dictionary {
    
    //construct an array ordered by their distance
    NSMutableArray *tempMutableArray = dictionary[@"subway_lines"];
    if ( [tempMutableArray count] == 0 ) {
        return tempMutableArray;
    }
    [tempMutableArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSDictionary *subway1 = (NSDictionary *)obj1;
        NSDictionary *subway2 = (NSDictionary *)obj2;
        return [subway1[@"distance_text"] compare:subway2[@"distance_text"] options:NSNumericSearch];
    }];
    
    int count = 0;
    NSString *lastDistance = tempMutableArray[0][@"distance_text"];
    NSMutableArray *resultArray = [[NSMutableArray alloc] initWithObjects:[NSMutableArray arrayWithArray:@[lastDistance]], nil];
    
    for ( NSDictionary *subway in tempMutableArray ) {
        //distance_text
        if ( [subway[@"distance_text"] isEqualToString:lastDistance] ) {
            [resultArray[count] addObject:subway];
        } else {
            lastDistance = subway[@"distance_text"];
            [resultArray addObject:[NSMutableArray arrayWithArray:@[lastDistance, subway]]];
            count++;
        }
    }
    return resultArray;
}

- (void)fetchImageForURL: (NSString *)urlString WithCompletionHandler:(void (^)(NSDictionary *resultDictionary))completionHandler {
    
    CitySpadeRequestHandler *handler = [[CitySpadeRequestHandler alloc] init];
    [handler downloadImagesForURL:[NSURL URLWithString:urlString] WithCompletionHandler:^(NSDictionary *imagePathsDictionary) {
        [_infoDictionary setValuesForKeysWithDictionary:imagePathsDictionary];
        completionHandler(_infoDictionary);
    }];
}


- (void)getIconImage:(NSNotification *)notification {
    NSMutableDictionary *tempMutableDic = [_infoDictionary mutableCopy];
    [tempMutableDic setValuesForKeysWithDictionary:[notification userInfo]];
    self.infoDictionary = tempMutableDic;
}

@end
