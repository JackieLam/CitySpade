//
//  
//    ___  _____   ______  __ _   _________ 
//   / _ \/ __/ | / / __ \/ /| | / / __/ _ \
//  / , _/ _/ | |/ / /_/ / /_| |/ / _// , _/
// /_/|_/___/ |___/\____/____/___/___/_/|_| 
//
//  Created by Bart Claessens. bart (at) revolver . be
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class Listing;

@interface REVClusterPin : NSObject  <MKAnnotation> {
    CLLocationCoordinate2D coordinate;
    NSString *thumbImageLink;
    NSString *title;
    NSString *subtitle;
    NSArray *nodes;
    NSString *beds;
    NSString *baths;
    NSString *bargain;
    NSString *transportation;
    double identifierNumber;
// Integer and double value for sorting
    int priceInt;
    double bargainDouble;
    double transportationDouble;
    int bedInt;
    int bathInt;
}

@property(nonatomic, retain) NSArray *nodes;
@property(nonatomic, assign) CLLocationCoordinate2D coordinate;
@property(nonatomic, copy) NSString *thumbImageLink;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *beds;
@property (nonatomic, copy) NSString *baths;
@property (nonatomic, copy) NSString *bargain;
@property (nonatomic, copy) NSString *transportation; 
@property (nonatomic) double identiferNumber;
// Integer and double value for sorting
@property (nonatomic) int priceInt;
@property (nonatomic) double bargainDouble;
@property (nonatomic) double transportationDouble;
@property (nonatomic) int bedInt;
@property (nonatomic) int bathInt;

- (NSUInteger) nodeCount;
- (void)configureWithListing:(Listing *)listing;
- (BOOL)fitsFilterData:(NSDictionary *)filterData; 

@end