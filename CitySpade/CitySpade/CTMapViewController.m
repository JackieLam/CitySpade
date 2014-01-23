//
//  CTMapViewController.m
//  CitySpade
//
//  Created by Cho-Yeung Lam on 20/1/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import "CTMapViewController.h"
#import "CTListViewController.h"
#import "CTMapView.h"
#import "MFSideMenu.h"
#import "FakeData.h"
#import <GoogleMaps/GoogleMaps.h>

#define botttomHeight 44.0f

@interface CTMapViewController() <GMSMapViewDelegate>

@property (nonatomic, strong) NSArray *places;

@end

@implementation CTMapViewController {
//    CTMapView *ctmapView;
    BOOL firstLocationUpdate_;
}

- (void)viewDidLoad
{
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _ctmapView = [[CTMapView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = _ctmapView;
    
    [self setupMenuBarButtonItems];
    
    FakeData *fakeData = [[FakeData alloc] init];
    NSArray *json = [NSJSONSerialization JSONObjectWithData:fakeData.points options:kNilOptions error:nil];
    self.places = [NSArray arrayWithArray:json];

//MapView Setting
    [_ctmapView.mapView addObserver:self forKeyPath:@"myLocation" options:NSKeyValueObservingOptionNew context:NULL];
    _ctmapView.mapView.delegate = self;
    
//Setup Markers
    [self setupMarkers:self.places];

//Setup Buttons
    [self setupButtons];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _ctmapView.mapView.myLocationEnabled = YES;
}

- (void)setupButtons
{
    [self.ctmapView.listButton addTarget:self action:@selector(listButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.ctmapView.saveButton addTarget:self action:@selector(saveButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.ctmapView.currentLocationButton addTarget:self action:@selector(currentLocationButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.ctmapView.localButton addTarget:self action:@selector(localButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Google Map Marker Setup
- (void)setupMarkers:(NSArray *)points
{
    for (NSDictionary *point in points) {
        GMSMarker *marker = [[GMSMarker alloc] init];
        double lat = [point[@"lat"] doubleValue];
        double lng = [point[@"lng"] doubleValue];
        marker.position = CLLocationCoordinate2DMake(lat, lng);
        marker.map = self.ctmapView.mapView;
    }
}

#pragma mark - GMSMapViewDelegate Methods
- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker {
    return [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"default_marker.png"]];
}

#pragma mark - KVO updates

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (!firstLocationUpdate_) {
        // If the first location update has not yet been recieved, then jump to that
        // location.
        firstLocationUpdate_ = YES;
        CLLocation *location = [change objectForKey:NSKeyValueChangeNewKey];
        self.ctmapView.mapView.camera = [GMSCameraPosition cameraWithTarget:location.coordinate
                                                         zoom:14];
    }
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
    CTListViewController *listVC = [[CTListViewController alloc] init];
    [self.navigationController pushViewController:listVC animated:YES];
}

- (void)localButtonClicked:(id)sender
{
    NSLog(@"localButtonClicked");
}

@end