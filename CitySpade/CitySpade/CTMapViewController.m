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
#import "REVClusterMapView.h"
#import "REVClusterPin.h"
#import "REVClusterAnnotationView.h"
#import "MapBottomBar.h"

#define cellHeight 130.0f
#define cellWidth 290.0f
#define cellGap 20.0f
#define cellOriginFromBottomLine 150.0f
#define botttomHeight 44.0f

@interface CTMapViewController()

@property (nonatomic, strong) NSArray *places;
@property (nonatomic, strong) NSArray *placesClicked;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeCollectionView;

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
    CGRect viewBounds = [UIScreen mainScreen].bounds;
    viewBounds.size.height = viewBounds.size.height - self.navigationController.navigationBar.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height;
    self.ctmapView = [[REVClusterMapView alloc] initWithFrame:viewBounds];
    self.ctmapView.delegate = self;
    [self.view addSubview:self.ctmapView];
    
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = 40.747;
    coordinate.longitude = -74;
    self.ctmapView.region = MKCoordinateRegionMakeWithDistance(coordinate, 5000, 5000);
    
// Setup BottomBar
    [self setupBottomBar];

// Setup the list view
    self.ctlistView = [[CTListView alloc] initWithFrame:viewBounds];
    self.ctlistView.delegate = self;

// Setup collectionView
    [self setupCollectionView];
    
//Load the pins onto the map
    FakeData *fakeData = [[FakeData alloc] init];
    NSArray *json = [NSJSONSerialization JSONObjectWithData:fakeData.points options:kNilOptions error:nil];
    self.places = [NSArray arrayWithArray:json];
    
    NSMutableArray *pins = [NSMutableArray array];
    int count = 0;
    for (NSDictionary *place in self.places) {
        count += 1;
        NSLog(@"count : %d", count);
        CGFloat lat = [place[@"lat"] floatValue];
        CGFloat lng = [place[@"lng"] floatValue];
        
        CLLocationCoordinate2D newCoord = {lat, lng};
        REVClusterPin *pin = [[REVClusterPin alloc] init];
        pin.title = place[@"title"];
        pin.subtitle = place[@"contact_tel"];
        pin.coordinate = newCoord;
        [pins addObject:pin];
    }
    [self.ctmapView addAnnotations:pins];
}

- (void)viewDidLoad
{
    UIColor *red = [UIColor colorWithRed:73.0f/255.0f green:73.0f/255.0f blue:73.0f/255.0f alpha:1.0];
    UIFont *font = [UIFont fontWithName:@"Avenir-Black" size:16.0f];
    NSMutableDictionary *navBarTextAttributes = [NSMutableDictionary dictionaryWithCapacity:1];
    [navBarTextAttributes setObject:font forKey:NSFontAttributeName];
    [navBarTextAttributes setObject:red forKey:NSForegroundColorAttributeName ];
    
    self.navigationController.navigationBar.titleTextAttributes = navBarTextAttributes;
    self.title = @"Fake Data Here";
}

- (void)setupBottomBar
{
    CGRect screenFrame = [UIScreen mainScreen].bounds;
    CGFloat bottomHeight = 52;
    CGRect bottomFrame = CGRectMake(0, self.ctmapView.frame.size.height - bottomHeight, screenFrame.size.width, bottomHeight);
    self.mapBottomBar = [[MapBottomBar alloc] initWithFrame:bottomFrame];
    [self.mapBottomBar.segmentControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    [self.mapBottomBar.saveButton addTarget:self action:@selector(saveButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.mapBottomBar];
}

-(void)segmentAction:(UISegmentedControl*)sender
{
    if (sender.selectedSegmentIndex == 0) {
        [UIView transitionFromView:self.ctlistView toView:self.ctmapView duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve completion:^(BOOL finished) {
            [self.ctlistView removeFromSuperview];
            [self.view addSubview:self.ctmapView];
            [self.view addSubview:self.mapBottomBar];
        }];
    }
    else {
        [UIView transitionFromView:self.ctmapView toView:self.ctlistView duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve completion:^(BOOL finished) {
            [self.ctmapView removeFromSuperview];
            [self.view addSubview:self.ctlistView];
            [self.view addSubview:self.mapBottomBar];
            [self.ctlistView loadPlacesToList:self.places];
        }];
    }
}

- (void)setupCollectionView
{
    CGRect collectionViewFrame = CGRectMake(0, self.view.frame.size.height - cellOriginFromBottomLine, self.view.frame.size.width, cellHeight);
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [flowLayout setMinimumInteritemSpacing:0.0f];
    [flowLayout setMinimumLineSpacing:0.0f];
    self.collectionView = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:flowLayout];
    [self.collectionView setPagingEnabled:NO];
    self.collectionView.alpha = 0.0f;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.swipeCollectionView = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeCollectionView)];
    self.swipeCollectionView.direction = UISwipeGestureRecognizerDirectionDown;
    [self.collectionView addGestureRecognizer:self.swipeCollectionView];
    [self.collectionView registerClass:[CTCollectionCell class] forCellWithReuseIdentifier:@"CTCollectionCell"];
    [self.view addSubview:self.collectionView];
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
    annView = (REVClusterAnnotationView*)
    [mapView dequeueReusableAnnotationViewWithIdentifier:@"cluster"];
    if( !annView )
        annView = (REVClusterAnnotationView*)
        [[REVClusterAnnotationView alloc] initWithAnnotation:annotation
                                             reuseIdentifier:@"cluster"];
    annView.image = [UIImage imageNamed:@"cluster.png"];
    annView.canShowCallout = NO;
    
    if( [pin nodeCount] > 0 ){
        pin.title = @"___";
        [(REVClusterAnnotationView*)annView setClusterText:
         [NSString stringWithFormat:@"%i",[pin nodeCount]]];
    } else {
        [(REVClusterAnnotationView*)annView setClusterText:@"1"];
    }
    return annView;
}

- (void)mapView:(MKMapView *)mapView
didSelectAnnotationView:(MKAnnotationView *)view
{
    REVClusterPin *annotation = (REVClusterPin *)view.annotation;
    if (annotation.nodes == nil) self.placesClicked = [NSArray arrayWithObject:annotation];
    else
        self.placesClicked = annotation.nodes;
    //zoom in if click on a cluster less than 20 
    if ([annotation.nodes count] > 20) {
        CLLocationCoordinate2D centerCoordinate = [annotation coordinate];
        MKCoordinateSpan newSpan = MKCoordinateSpanMake(mapView.region.span.latitudeDelta/2.0, mapView.region.span.longitudeDelta/2.0);
        [mapView setRegion:MKCoordinateRegionMake(centerCoordinate, newSpan)
                  animated:YES];
    }
    else {
        if (self.collectionView.alpha == 0.0f) {
            [self.collectionView reloadData];
            [self collectionViewAppear];
        }
        else {
            [self.collectionView reloadData];
        }
    }
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    CTListCell *cell = (CTListCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.rightView.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1.0f];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CTListCell *cell = (CTListCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.rightView.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1.0f];
    CTDetailViewController *detailViewController = [[CTDetailViewController alloc] init];
    
    NSDictionary *basicInfo = @{@"title": cell.titleLabel.text, @"price": cell.priceLabel.text, @"bargain": cell.bargainLabel.text, @"transport": cell.transportLabel.text, @"bed": cell.bedLabel.text, @"bath": cell.bathLabel.text};
    detailViewController.basicInfo = basicInfo;
    
    [self.navigationController pushViewController:detailViewController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    REVClusterPin *pin = self.placesClicked[count];
    cell.thumbImageView.image = [UIImage imageNamed:@"imagePlaceholder"];
    cell.titleLabel.text = pin.title;
    cell.priceLabel.text = pin.subtitle;
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(cellWidth+cellGap, cellHeight);
}

#pragma mark - Swipe UICollectionView
- (void)didSwipeCollectionView
{
    [self collectionViewDisappear];
}

#pragma mark - Animation: UICollectionView
- (void)collectionViewAppear
{
    CGRect viewFrame = self.collectionView.frame;
    viewFrame.origin.y = viewFrame.origin.y - 40;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelay:0.0];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.alpha = 1.0f;
    self.collectionView.frame = viewFrame;
    [UIView commitAnimations];
}

- (void)collectionViewDisappear
{
    CGRect viewFrame = self.collectionView.frame;
    viewFrame.origin.y = viewFrame.origin.y + 40;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelay:0.0];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    self.collectionView.alpha = 0.0f;
    self.collectionView.frame = viewFrame;
    [UIView commitAnimations];
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
            initWithImage:[UIImage imageNamed:@"User-Profile"] style:UIBarButtonItemStyleBordered
            target:self
            action:@selector(leftSideMenuButtonPressed:)];
}

- (UIBarButtonItem *)rightMenuBarButtonItem {
    return [[UIBarButtonItem alloc]
            initWithImage:[UIImage imageNamed:@"Search"] style:UIBarButtonItemStyleBordered
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

@end