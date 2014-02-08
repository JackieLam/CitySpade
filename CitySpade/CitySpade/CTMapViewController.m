//
//  CTMapViewController.m
//  CitySpade
//
//  Created by Cho-Yeung Lam on 20/1/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import "CTMapViewController.h"
#import "CTDetailViewController.h"
#import "CTListView.h"
#import "CTDetailView.h"
#import "MFSideMenu.h"
#import "FakeData.h"
#import "CTListCell.h"
#import "CTCollectionCell.h"
#import <GoogleMaps/GoogleMaps.h>
#import "REVClusterMapView.h"
#import "REVClusterPin.h"
#import "REVClusterAnnotationView.h"
#import "MapBottomBar.h"

#define botttomHeight 44.0f

@interface CTMapViewController()

@property (nonatomic, strong) NSArray *places;
@property (nonatomic, strong) NSArray *placesClicked;

@end

@implementation CTMapViewController {
    BOOL firstLocationUpdate_;
}

- (void)loadView
{
    [super loadView];
    
    self.places = [NSArray array];
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

// Setup the list view
    CGFloat topInset = [UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.frame.size.height;
    self.ctlistView = [[CTListView alloc] initWithFrame:CGRectMake(0, topInset, viewBounds.size.width, viewBounds.size.height-topInset)];
    [self.ctlistView.mapButton addTarget:self action:@selector(mapButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

// Setup the bottom bar buttons
    [self setupButtons];

//Load the pins onto the map
    FakeData *fakeData = [[FakeData alloc] init];
    NSArray *json = [NSJSONSerialization JSONObjectWithData:fakeData.points options:kNilOptions error:nil];
    self.places = [NSArray arrayWithArray:json];
    
    NSMutableArray *pins = [NSMutableArray array];
    
    for (NSDictionary *place in self.places) {
        CGFloat lat = [place[@"lat"] floatValue];
        CGFloat lng = [place[@"lng"] floatValue];
        
        CLLocationCoordinate2D newCoord = {lat, lng};
        REVClusterPin *pin = [[REVClusterPin alloc] init];
        pin.title = place[@"title"];
        pin.subtitle = place[@"contact_name"];
        pin.coordinate = newCoord;
        [pins addObject:pin];
    }
    [self.ctmapView addAnnotations:pins];
}

- (void)viewDidLoad
{
    [self setupCollectionView];
}

- (void)setupButtons
{
    CGRect screenFrame = [UIScreen mainScreen].bounds;
    CGFloat bottomHeight = 60;
    CGRect bottomFrame = CGRectMake(0, screenFrame.size.height - bottomHeight, screenFrame.size.width, bottomHeight);
    self.mapBottomBar = [[MapBottomBar alloc] initWithFrame:bottomFrame];
    [self.ctmapView addSubview:self.mapBottomBar];
    
    [self.mapBottomBar.saveButton addTarget:self action:@selector(saveButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.mapBottomBar.currentLocationButton addTarget:self action:@selector(currentLocationButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.mapBottomBar.listButton addTarget:self action:@selector(listButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupCollectionView
{
    CGRect collectionViewFrame = CGRectMake(0, 400, self.view.frame.size.width, 60);
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [flowLayout setMinimumInteritemSpacing:0.0f];
    [flowLayout setMinimumLineSpacing:0.0f];
    self.collectionView = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:flowLayout];
    [self.collectionView setPagingEnabled:NO];
    self.collectionView.alpha = 0.0f;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[CTCollectionCell class] forCellWithReuseIdentifier:@"CTCollectionCell"];
    [self.ctmapView addSubview:self.collectionView];
}

#pragma mark - MapView delegate

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
    self.placesClicked = annotation.nodes;
    
    //zoom in if click on a cluster less than 20
    if ([annotation.nodes count] > 20) {
        CLLocationCoordinate2D centerCoordinate = [annotation coordinate];
        MKCoordinateSpan newSpan =
        MKCoordinateSpanMake(mapView.region.span.latitudeDelta/2.0,
                             mapView.region.span.longitudeDelta/2.0);
        [mapView setRegion:MKCoordinateRegionMake(centerCoordinate, newSpan)
                  animated:YES];
    }
    else {
        [self.collectionView reloadData];
        
        CGRect viewFrame = self.collectionView.frame;
        viewFrame.origin.y = viewFrame.origin.y - 40;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelay:0.0];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        self.collectionView.backgroundColor = [UIColor whiteColor];
        self.collectionView.alpha = 1.0f;
        self.collectionView.frame = viewFrame;
        [UIView commitAnimations];
    }
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

#pragma mark - UICollectionView DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.placesClicked count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CTCollectionCell";
    CTCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[CTCollectionCell alloc] init];
    }
    int count = (int)[indexPath row];
//    [cell.thumbImageview setImage:self.placesClicked[count][@"images"][0]];
    REVClusterPin *pin = self.placesClicked[count];
    cell.titleLabel.text = pin.title;
    cell.subtitleLabel.text = pin.subtitle;
    return cell;
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
@end