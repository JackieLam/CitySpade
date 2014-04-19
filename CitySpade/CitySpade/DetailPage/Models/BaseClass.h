//
//  BaseClass.h
//
//  Created by 新强 朱 on 14-4-13
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface BaseClass : NSObject <NSCoding>

@property (nonatomic, strong) NSArray *busLines;
@property (nonatomic, strong) NSArray *colleges;
@property (nonatomic, strong) NSString *contactTel;
@property (nonatomic, strong) NSArray *hottestSpots;
@property (nonatomic, strong) NSArray *subwayLines;
@property (nonatomic, strong) NSString *originalUrl;
@property (nonatomic, strong) NSString *originalIconUrl;
@property (nonatomic, strong) NSString *contactName;
@property (nonatomic) CGFloat subwayCellHeight;
@property (nonatomic) CGFloat colleagesCellHeight;
@property (nonatomic) CGFloat hottestSpotCellHeight;
@property (nonatomic) CGFloat buslineCellHeight;
@property (nonatomic) CGFloat transportationCellHeight;

+ (BaseClass *)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
