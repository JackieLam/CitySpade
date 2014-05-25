//
//  
//    ___  _____   ______  __ _   _________ 
//   / _ \/ __/ | / / __ \/ /| | / / __/ _ \
//  / , _/ _/ | |/ / /_/ / /_| |/ / _// , _/
// /_/|_/___/ |___/\____/____/___/___/_/|_| 
//
//  Created by Bart Claessens. bart (at) revolver . be
//

#import "REVClusterPin.h"
#import "Listing.h"
#import "DataModels.h"
#import "NSString+RegEx.h"

@implementation REVClusterPin

@synthesize thumbImageLink;
@synthesize title,coordinate,subtitle;
@synthesize nodes;
@synthesize beds, baths, bargain, transportation;
@synthesize priceInt, bargainDouble, transportationDouble, bedInt, bathInt;

- (NSUInteger) nodeCount
{
    if( nodes )
        return [nodes count];
    return 0;
}

#if !__has_feature(objc_arc)
- (void)dealloc
{
    [thumbImageLink release];
    [title release];
    [subtitle release];
    [beds release];
    [baths release];
    [bargain release];
    [transportation release];
    [nodes release];
    [super dealloc];
}
#endif

- (void)configureWithListing:(Listing *)listing
{
    self.title = listing.title;
    self.subtitle = [NSString stringWithFormat:@"$%d", (int)listing.price];
    self.beds = [NSString stringWithFormat:@"%d", (int)listing.beds];
    self.baths = [NSString stringWithFormat:@"%d", (int)listing.baths];
    self.bargain = listing.bargain;
    self.transportation = listing.transportation;
    self.coordinate = CLLocationCoordinate2DMake(listing.lat, listing.lng);
    self.identiferNumber = listing.internalBaseClassIdentifier;
    
    Images *image = (Images *)[listing.images firstObject];
    self.thumbImageLink = [NSString stringWithFormat:@"%@%@", image.url, [image.sizes firstObject]];
    
    self.priceInt = (int)listing.price;
    self.bargainDouble = [[listing.bargain firstNumberInString] doubleValue];
    self.transportationDouble = [[listing.transportation firstNumberInString] doubleValue];
    self.bedInt = (int)listing.beds;
    self.bathInt = (int)listing.baths;
}

- (BOOL)fitsFilterData:(NSDictionary *)filterData
{
    int lowerbound = [filterData[@"lowerBound"] intValue];
    int higherbound = [filterData[@"higherBound"] intValue];
    
    // price range
    if (!(lowerbound <= self.priceInt) || ((!(self.priceInt <= higherbound)) && higherbound > 0))
        return NO;
    
    // baths
    if ([filterData[@"baths"] isEqualToString:@"Any"]) { /*Skip and cont'*/ }
    else if ([filterData[@"baths"] isEqualToString:@"4+"] && [self.baths intValue] >= 4) { /*Skip and cont'*/}
    else if (![self.baths isEqualToString:filterData[@"baths"]])
        return NO;
    
    // beds
    if ([filterData[@"beds"] isEqualToString:@"Any"]) { /*Skip and cont'*/ }
    else if ([filterData[@"beds"] isEqualToString:@"4+"] && [self.beds intValue] >= 4) { /*Skip and cont'*/}
    else if (![self.beds isEqualToString:filterData[@"beds"]])
        return NO;
    
    // bargain
    NSString *bargainNum = [filterData[@"bargain"] firstNumberInString];
    if ([filterData[@"bargain"] isEqualToString:@"Any"]) {/*Skip and cont'*/}
    else if (self.bargainDouble > [bargainNum doubleValue]) {/*Skip and cont'*/}
    else
        return NO;
    
    // transportation
    NSString *transNum = [filterData[@"transportation"] firstNumberInString];
    if ([filterData[@"transportation"] isEqualToString:@"Any"]) {/*Skip and cont'*/}
    else if (self.transportationDouble > [transNum doubleValue]) {/*Skip and cont'*/}
    else
        return NO;
    
    return YES;
}

@end
