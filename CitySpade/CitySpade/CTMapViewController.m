//
//  CTMapViewController.m
//  CitySpade
//
//  Created by Cho-Yeung Lam on 20/1/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import "CTMapViewController.h"
#import "CTDetailViewController.h"
#import "CTMapView.h"
#import "CTListView.h"
#import "CTDetailView.h"
#import "MFSideMenu.h"
#import "FakeData.h"
#import "CTListCell.h"
#import <GoogleMaps/GoogleMaps.h>
#import "REVClusterMapView.h"
#import "REVClusterPin.h"
#import "REVClusterAnnotationView.h"

#define botttomHeight 44.0f

@interface CTMapViewController()

@property (nonatomic, strong) NSArray *places;

@end

@implementation CTMapViewController {
    BOOL firstLocationUpdate_;
}

- (void)loadView
{
    [super loadView];
// Setup the navigation bar
    [self setupMenuBarButtonItems];
// Setup the map view
    CGRect viewBounds = [[UIScreen mainScreen] applicationFrame];
    
    self.ctmapView = [[REVClusterMapView alloc] initWithFrame:viewBounds];
    self.ctmapView.delegate = self;
    
    [self.view addSubview:self.ctmapView];
    
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = 40.747;
    coordinate.longitude = -74;
    self.ctmapView.region = MKCoordinateRegionMakeWithDistance(coordinate, 5000, 5000);

//Load the pins onto the map
    FakeData *fakeData = [[FakeData alloc] init];
    NSArray *json = [NSJSONSerialization JSONObjectWithData:fakeData.points options:kNilOptions error:nil];
    NSLog(@"fakeData : %@", fakeData.dataString);
    self.places = [NSArray arrayWithArray:json];
    
    NSMutableArray *pins = [NSMutableArray array];
    
    for (NSDictionary *place in self.places) {
        CGFloat latDelta = rand()*0.125/RAND_MAX - 0.02;
        CGFloat lonDelta = rand()*0.130/RAND_MAX - 0.08;
        CGFloat lat = [place[@"lat"] floatValue];
        CGFloat lng = [place[@"lng"] floatValue];
        
        CLLocationCoordinate2D newCoord = {lat+latDelta, lng+lonDelta};
        REVClusterPin *pin = [[REVClusterPin alloc] init];
        pin.title = place[@"title"];
        pin.subtitle = place[@"contact_name"];
        pin.coordinate = newCoord;
        [pins addObject:pin];
    }
    [self.ctmapView addAnnotations:pins];
}


- (void)setupButtons
{
    
}

#pragma mark -
#pragma mark Map view delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if([annotation class] == MKUserLocation.class) {
		//userLocation = annotation;
		return nil;
	}
    
    REVClusterPin *pin = (REVClusterPin *)annotation;
    
    MKAnnotationView *annView;
    
    if( [pin nodeCount] > 0 ){
        pin.title = @"___";
        annView = (REVClusterAnnotationView*)
        [mapView dequeueReusableAnnotationViewWithIdentifier:@"cluster"];
        
        if( !annView )
            annView = (REVClusterAnnotationView*)
            [[REVClusterAnnotationView alloc] initWithAnnotation:annotation
                                                  reuseIdentifier:@"cluster"];
        
        annView.image = [UIImage imageNamed:@"cluster.png"];
        
        [(REVClusterAnnotationView*)annView setClusterText:
         [NSString stringWithFormat:@"%i",[pin nodeCount]]];
        
        annView.canShowCallout = NO;
    } else {
        annView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"pin"];
        
        if( !annView )
            annView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                    reuseIdentifier:@"pin"];
        
        annView.image = [UIImage imageNamed:@"pinpoint.png"];
        annView.canShowCallout = NO;
        
        annView.calloutOffset = CGPointMake(-6.0, 0.0);
    }
    return annView;
}

- (void)mapView:(MKMapView *)mapView
didSelectAnnotationView:(MKAnnotationView *)view
{
    NSLog(@"REVMapViewController mapView didSelectAnnotationView:");
    
    REVClusterPin *annotation = (REVClusterPin *)view.annotation;
    
    if (annotation.nodes > 0) {
//        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 250, self.view.frame.size.width, self.view.frame.size.height-250)];
//        _collectionView.delegate = self;
//        _collectionView.dataSource = self;
        //        _collectionView.collectionViewLayout =
    }
    
    //if click on a pin
    if (![view isKindOfClass:[REVClusterAnnotationView class]]) {
        //show something at the bottom of the view
        UIView *annotationUIView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, self.view.frame.size.height)];
        annotationUIView.backgroundColor = [UIColor whiteColor];
        UILabel *firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 80, 20)];
        firstLabel.text = annotation.title;
        [annotationUIView addSubview:firstLabel];
        UILabel *secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 80, 20)];
        secondLabel.text = annotation.subtitle;
        [annotationUIView addSubview:secondLabel];
        
//        [self.ctmapView addSubview:annotationUIView];
        return;
    }
    
    //if click on a cluster group
    
    CLLocationCoordinate2D centerCoordinate = [annotation coordinate];
    
    MKCoordinateSpan newSpan =
    MKCoordinateSpanMake(mapView.region.span.latitudeDelta/2.0,
                         mapView.region.span.longitudeDelta/2.0);
    
    [mapView setRegion:MKCoordinateRegionMake(centerCoordinate, newSpan)
              animated:YES];
}


#pragma mark - NavigationBar Button
- (void)setupMenuBarButtonItems {
    self.navigationItem.rightBarButtonItem = [self rightMenuBarButtonItem];
    if(self.menuContainerViewController.menuState == MFSideMenuStateClosed &&
       ![[self.navigationController.viewControllers objectAtIndex:0] isEqual:self]) {
        self.navigationItem.leftBarButtonItem = [self backBarButtonItem];
    } else {
        self.navigationItem.leftBarButtonItem = [self leftMenuBarButtonItem];
    }
}

- (UIBarButtonItem *)leftMenuBarButtonItem {
    return [[UIBarButtonItem alloc]
            initWithImage:[UIImage imageNamed:@"menu-icon.png"] style:UIBarButtonItemStyleBordered
            target:self
            action:@selector(leftSideMenuButtonPressed:)];
}

- (UIBarButtonItem *)rightMenuBarButtonItem {
    return [[UIBarButtonItem alloc]
            initWithImage:[UIImage imageNamed:@"menu-icon.png"] style:UIBarButtonItemStyleBordered
            target:self
            action:@selector(rightSideMenuButtonPressed:)];
}

- (UIBarButtonItem *)backBarButtonItem {
    return [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back-arrow"]
                                            style:UIBarButtonItemStyleBordered
                                           target:self
                                           action:@selector(backButtonPressed:)];
}

#pragma mark - UIBarButtonItem Callbacks

- (void)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)leftSideMenuButtonPressed:(id)sender {
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
        [self setupMenuBarButtonItems];
    }];
}

- (void)rightSideMenuButtonPressed:(id)sender {
    [self.menuContainerViewController toggleRightSideMenuCompletion:^{
        [self setupMenuBarButtonItems];
    }];
}

#pragma mark - Handle the button click
- (void)saveButtonClicked:(id)sender
{
    NSLog(@"saveButtonClicked");
}

- (void)currentLocationButtonClicked:(id)sender
{
    NSLog(@"currentLocationButtonClicked");

}

- (void)listButtonClicked:(id)sender
{
    NSLog(@"list button clicked");
    
    [UIView transitionFromView:self.ctmapView toView:self.ctlistView duration:0.5 options:UIViewAnimationOptionTransitionFlipFromRight completion:^(BOOL finished) {
        [self.ctmapView removeFromSuperview];
        [self.view addSubview:self.ctlistView];
        [self.ctlistView loadPlacesToList:self.places];
    }];
}

- (void)mapButtonClicked:(id)sender
{
    NSLog(@"mapButtonClicked");
    [UIView transitionFromView:self.ctlistView toView:self.ctmapView duration:0.5 options:UIViewAnimationOptionTransitionFlipFromRight completion:^(BOOL finished) {
        [self.ctlistView removeFromSuperview];
        [self.view addSubview:self.ctmapView];
    }];
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectRowAtIndexPath : %d", indexPath.row);
    CTListCell *cell = (CTListCell *)[tableView cellForRowAtIndexPath:indexPath];
    CTDetailViewController *detailViewController = [[CTDetailViewController alloc] init];
    detailViewController.house = [NSDictionary dictionaryWithDictionary:cell.house];
    detailViewController.houseImage = cell.thumbImageView.image;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

@end