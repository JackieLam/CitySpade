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

@implementation REVClusterPin

@synthesize thumbImageLink;
@synthesize title,coordinate,subtitle;
@synthesize nodes;
@synthesize beds, baths, bargain, transportation;

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
}

@end
