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
#import "CTListCell.h"
#import "CTCollectionCell.h"
#import "REVClusterMapView.h"
#import "REVClusterPin.h"
#import "REVClusterAnnotationView.h"
#import "MapBottomBar.h"
#import "RESTfulEngine.h"
#import "DataModels.h"
#import "Constants.h"
#import "RegExCategories.h"
#import "MapCollectionCell.h"
#import "AppCache.h"

#define cellHeight 231.0f //130.0f
#define cellWidth 320.0f //290.0f
#define cellGap 0.0f //20.0f
#define cellOriginFromBottomLine cellHeight //150.0f
#define botttomHeight 44.0f
#define greenColor [UIColor colorWithRed:41.0/255.0 green:188.0/255.0 blue:184.0/255.0 alpha:1.0f]

@interface CTMapViewController()
{
    double previousZoomLevel;
    BOOL forRent;
}

@property (nonatomic, strong) NSArray *listings;
@property (nonatomic, strong) NSMutableArray *pinsAll;
@property (nonatomic, strong) NSMutableArray *pinsFilterRight;

@property (nonatomic, strong) NSArray *placesClicked;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeCollectionView;
//Drawing related property
@property (nonatomic, strong) UIView *pathOverlay;
@property (nonatomic, strong) UIPanGestureRecognizer *panDrawGesture;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) UIBezierPath *path;

@property (nonatomic) float collectionViewOriginY;

@end

@implementation CTMapViewController {
    BOOL firstLocationUpdate_;
}

- (void)loadView
{
    [super loadView];
// Setup the dataArray
    self.listings = [NSArray array];
    self.pinsAll = [NSMutableArray array];
    self.pinsFilterRight = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
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
    previousZoomLevel = self.ctmapView.region.span.longitudeDelta;
    
// Setup BottomBar
    [self setupBottomBar];

// Setup the list view
    self.ctlistView = [[CTListView alloc] initWithFrame:viewBounds];
    self.ctlistView.delegate = self;

// Setup collectionView
    [self setupCollectionView];
    
// RESTfulEngine
    self.listings = [AppCache getCachedListingItems];
    if (!self.listings || [AppCache isListingItemsStale]) {
        [self loadForAllListings:[NSNotification notificationWithName:kNotificationToLoadAllListings object:@{@"rent": @1} userInfo:nil]];
    }
    else {
        [self resetAnnotationsWithResultArray:self.listings];
    }
}

- (void)viewDidLoad
{
    UIColor *red = [UIColor colorWithRed:73.0f/255.0f green:73.0f/255.0f blue:73.0f/255.0f alpha:1.0];
    UIFont *font = [UIFont fontWithName:@"Avenir-Black" size:16.0f];
    NSMutableDictionary *navBarTextAttributes = [NSMutableDictionary dictionaryWithCapacity:1];
    [navBarTextAttributes setObject:font forKey:NSFontAttributeName];
    [navBarTextAttributes setObject:red forKey:NSForegroundColorAttributeName ];
    
    self.navigationController.navigationBar.titleTextAttributes = navBarTextAttributes;
    self.title = @"For Rent";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadForAllListings:) name:kNotificationToLoadAllListings object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePinsFilterRight:) name:kNotificationDidRightFilter object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
}

- (void)setupBottomBar
{
    CGRect screenFrame = [UIScreen mainScreen].bounds;
    CGFloat bottomHeight = 52;
    CGRect bottomFrame = CGRectMake(0, self.ctmapView.frame.size.height - bottomHeight, screenFrame.size.width, bottomHeight);
    self.mapBottomBar = [[MapBottomBar alloc] initWithFrame:bottomFrame];
    self.mapBottomBar.barState = BarStateMapDefault;
    [self.mapBottomBar.segmentControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    [self.mapBottomBar.saveButton addTarget:self action:@selector(saveButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.mapBottomBar.drawButton addTarget:self action:@selector(drawButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.mapBottomBar.cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.mapBottomBar.clearButton addTarget:self action:@selector(clearButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.mapBottomBar];
}

- (void)setupCollectionView
{
    self.collectionViewOriginY = self.view.frame.size.height-statusBarHeight-navigationBarHeight+2;
    CGRect collectionViewFrame = CGRectMake(0, self.collectionViewOriginY, self.view.frame.size.width, cellHeight);
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [flowLayout setMinimumInteritemSpacing:0.0f];
    [flowLayout setMinimumLineSpacing:0.0f];
    self.collectionView = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:flowLayout];
    [self.collectionView registerClass:[MapCollectionCell class] forCellWithReuseIdentifier:@"mapCollectionCell"];
    [self.collectionView setPagingEnabled:YES];
    self.collectionView.alpha = 1.0f;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.swipeCollectionView = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(collectionViewDisappear)];
    self.swipeCollectionView.direction = UISwipeGestureRecognizerDirectionDown;
    [self.collectionView addGestureRecognizer:self.swipeCollectionView];
    [self.view addSubview:self.collectionView];
}

#pragma mark - 
#pragma mark - Reload Listing(For Rent / For Sale)
- (void)loadForAllListings:(NSNotification *)aNotification
{
    NSDictionary *param = [aNotification object];
    forRent = [param[@"rent"] boolValue];
    //Remove all annotaions first
    [self.ctmapView removeAnnotations:self.ctmapView.annotations];
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.navigationItem.titleView = activityIndicator;
    [activityIndicator startAnimating];
    
    [RESTfulEngine loadListingsWithQuery:param onSucceeded:^(NSMutableArray *resultArray) {
        [activityIndicator stopAnimating];
        self.listings = resultArray;
        [AppCache cacheListingItems:self.listings];
        self.navigationItem.titleView = nil;
        self.navigationItem.title = forRent ? @"For Rent": @"For Sale";
        [self resetAnnotationsWithResultArray:self.listings];
    } onError:^(NSError *engineError) {
        
        [SVProgressHUD showErrorWithStatus:engineError.description];
    }];
}

- (void)resetAnnotationsWithResultArray:(NSArray *)resultArray
{
    for (Listing *listing in resultArray) {
        
        REVClusterPin *pin = [[REVClusterPin alloc] init];
        pin.title = listing.title;
        pin.subtitle = [NSString stringWithFormat:@"$%d", (int)listing.price];
        pin.beds = [NSString stringWithFormat:@"%d", (int)listing.beds];
        pin.baths = [NSString stringWithFormat:@"%d", (int)listing.baths];
        pin.bargain = listing.bargain;
        pin.transportation = listing.transportation;
        pin.coordinate = CLLocationCoordinate2DMake(listing.lat, listing.lng);
        
        Images *image = (Images *)[listing.images firstObject];
        pin.thumbImageLink = [NSString stringWithFormat:@"%@%@", image.url, [image.sizes firstObject]];
        [self.pinsAll addObject:pin];
    }
    self.pinsFilterRight = self.pinsAll;
    [self.ctmapView addAnnotations:self.pinsAll];
}

#pragma mark - MapView delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if([annotation class] == MKUserLocation.class) {
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
    [(REVClusterAnnotationView *)annView configureAnnotationView:[pin nodeCount]];
    return annView;
}

- (void)mapView:(MKMapView *)mapView
didSelectAnnotationView:(MKAnnotationView *)view
{
    REVClusterPin *annotation = (REVClusterPin *)view.annotation;
    if (annotation.nodes == nil) self.placesClicked = [NSArray arrayWithObject:annotation];
    else
        self.placesClicked = [NSArray arrayWithArray:annotation.nodes];
    //zoom in if click on a cluster less than 20 
    if ([annotation.nodes count] > 20) {
        CLLocationCoordinate2D centerCoordinate = [annotation coordinate];
        MKCoordinateSpan newSpan = MKCoordinateSpanMake(mapView.region.span.latitudeDelta/2.0, mapView.region.span.longitudeDelta/2.0);
        [mapView setRegion:MKCoordinateRegionMake(centerCoordinate, newSpan)
                  animated:YES];
    }
    else {
        if (self.collectionView.frame.origin.y == self.collectionViewOriginY) {
            [self.collectionView reloadData];
            [self collectionViewAppear];
        }
        else {
            [self.collectionView reloadData];
        }
    }
    [mapView deselectAnnotation:view.annotation animated:YES];
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{

}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    if (views.count > 0) {
        UIView *firstAnnotation = [views objectAtIndex:0];
        UIView *parentView = [firstAnnotation superview];
        if (self.pathOverlay == nil) {
            self.pathOverlay = [[UIView alloc] initWithFrame:parentView.frame];
            self.pathOverlay.opaque = NO;
            self.pathOverlay.backgroundColor = [UIColor clearColor];
            self.pathOverlay.userInteractionEnabled = NO;
            self.panDrawGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
            [self.pathOverlay addGestureRecognizer:self.panDrawGesture];
            [parentView addSubview:self.pathOverlay];
        }
        
        for (UIView *view in views) {
            [parentView bringSubviewToFront:view];
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
    static NSString *CellIdentifier = @"mapCollectionCell";
    MapCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[MapCollectionCell alloc] initWithFrame:CGRectMake(0, 0, cellWidth+cellGap, cellHeight)];
    }
    int count = (int)[indexPath row];
    [cell configureCellWithClusterPin:self.placesClicked[count]];
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(cellWidth+cellGap, cellHeight);
}

#pragma mark - Animation: UICollectionView
- (void)collectionViewAppear
{
    CGRect viewFrame = self.collectionView.frame;
    viewFrame.origin.y = viewFrame.origin.y - cellHeight;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    [UIView setAnimationDelay:0.0];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    self.collectionView.frame = viewFrame;
    [UIView commitAnimations];
}

- (void)collectionViewDisappear
{
    CGRect viewFrame = self.collectionView.frame;
    viewFrame.origin.y = viewFrame.origin.y + cellHeight;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelay:0.0];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithImage:[UIImage imageNamed:@"Search"] style:UIBarButtonItemStyleBordered
                                              target:self
                                              action:@selector(rightSideMenuButtonPressed:)];
    if(self.menuContainerViewController.menuState == MFSideMenuStateClosed &&
       ![[self.navigationController.viewControllers objectAtIndex:0] isEqual:self]) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back-arrow"]
                                                                                 style:UIBarButtonItemStyleBordered
                                                                                target:self
                                                                                action:@selector(backButtonPressed:)];
    } else {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                                 initWithImage:[UIImage imageNamed:@"User-Profile"] style:UIBarButtonItemStyleBordered
                                                 target:self
                                                 action:@selector(leftSideMenuButtonPressed:)];
    }
}

#pragma mark - MapBottomBar Button

-(void)segmentAction:(UISegmentedControl*)sender
{
    if (sender.selectedSegmentIndex == 0) {
        [UIView transitionFromView:self.ctlistView toView:self.ctmapView duration:1.0 options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished) {
            [self.ctlistView removeFromSuperview];
            [self.mapBottomBar resetBarState:BarStateMapDefault];
            [self.view insertSubview:self.ctmapView aboveSubview:self.view];
            [self.view bringSubviewToFront:self.mapBottomBar];
            [self.view bringSubviewToFront:self.collectionView];
        }];
    }
    else {
        [UIView transitionFromView:self.ctmapView toView:self.ctlistView duration:1.0 options:UIViewAnimationOptionTransitionFlipFromRight completion:^(BOOL finished) {
            [self.ctmapView removeFromSuperview];
            [self.view insertSubview:self.ctlistView belowSubview:self.mapBottomBar];
            [self.mapBottomBar resetBarState:BarStateList];
            [self.view bringSubviewToFront:self.mapBottomBar];
            [self.ctlistView loadPlacesToList:self.pinsAll];
        }];
    }
}

- (void)saveButtonClicked:(id)sender
{
    NSLog(@"saveButtonClicked");
}

- (void)drawButtonClicked:(id)sender
{
    self.navigationItem.title = @"Draw";
    [self.mapBottomBar resetBarState:BarStateMapDraw];
    self.ctmapView.zoomEnabled = NO;
    self.ctmapView.scrollEnabled = NO;
    self.ctmapView.rotateEnabled = NO;
    self.pathOverlay.userInteractionEnabled = YES;
    self.pathOverlay.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
}

- (void)cancelButtonClicked:(id)sender
{
    if (forRent) self.navigationItem.title = @"For Rent";
    else self.navigationItem.title = @"For Sale";
    
    if (self.path) {
        [self.path removeAllPoints];
        self.shapeLayer.path = [self.path CGPath];
        self.path = nil;
    }
    
    [self.ctmapView removeAnnotations:self.ctmapView.annotations];
    [self.ctmapView addAnnotations:self.pinsFilterRight];
    
    self.ctmapView.zoomEnabled = YES;
    self.ctmapView.scrollEnabled = YES;
    self.ctmapView.rotateEnabled = YES;
    self.pathOverlay.userInteractionEnabled = NO;
    self.pathOverlay.backgroundColor = [UIColor clearColor];
    [self.mapBottomBar resetBarState:BarStateMapDefault];
}

- (void)clearButtonClicked:(id)sender
{
    [self.path removeAllPoints];
    self.shapeLayer.path = [self.path CGPath];
}

#pragma mark -
#pragma mark - Handle the drawing
- (void)handleGesture:(UIPanGestureRecognizer*)gesture
{
    CGPoint location = [gesture locationInView: self.pathOverlay];
    
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        if (!self.shapeLayer)
        {
            self.shapeLayer = [[CAShapeLayer alloc] init];
            self.shapeLayer.fillColor = [[UIColor colorWithRed:41.0/255.0 green:188.0/255.0 blue:184.0/255.0 alpha:0.2f] CGColor];
            self.shapeLayer.strokeColor = [greenColor CGColor];
            self.shapeLayer.lineWidth = 3.0;
            [self.pathOverlay.layer addSublayer:self.shapeLayer];
        }
        self.path = [[UIBezierPath alloc] init];
        [self.path moveToPoint:location];
    }
    else if (gesture.state == UIGestureRecognizerStateChanged)
    {
        [self.path addLineToPoint:location];
        self.shapeLayer.path = [self.path CGPath];
    }
    else if (gesture.state == UIGestureRecognizerStateEnded)
    {
        [self.path addLineToPoint:location];
        [self.path closePath];
        self.shapeLayer.path = [self.path CGPath];
        
        [self.ctmapView removeAnnotations:self.ctmapView.annotations];
        NSMutableArray *filterDrawAnnotations = [self pinsFilterDrawAndRightFromPinsFilterRight:self.pinsFilterRight];
        // TODO: 应该是pinsFilterRight
        [self.ctmapView addAnnotations:filterDrawAnnotations];
    }
}

#pragma mark - Filter Helper Method
#pragma mark - Notification

- (void)updatePinsFilterRight:(NSNotification *)aNotification
{
    self.pinsFilterRight = [NSMutableArray array];
    NSDictionary *filterData = [aNotification object];
    int lowerbound = [filterData[@"lowerBound"] intValue];
    int higherbound = [filterData[@"higherBound"] intValue];
    
    for (REVClusterPin *pin in self.pinsAll) {
        NSArray *pieces = [pin.subtitle split:RX(@"[$]")];
        NSString *price = pieces[1];

        //price range
        if (!(lowerbound <= [price intValue]) || !([price intValue] <= higherbound))
            continue;
        
        //baths1
        if ([filterData[@"baths"] isEqualToString:@"Any"]) { /*Skip continue;*/ }
        else if ([filterData[@"baths"] isEqualToString:@"4+"] && [pin.baths intValue] >= 4) { /*Skip continue;*/}
        else if (![pin.baths isEqualToString:filterData[@"baths"]]) continue;
        
        //beds
        if ([filterData[@"beds"] isEqualToString:@"Any"]) { /*Skip continue;*/ }
        else if ([filterData[@"beds"] isEqualToString:@"4+"] && [pin.beds intValue] >= 4) { /*Skip continue;*/}
        else if (![pin.beds isEqualToString:filterData[@"beds"]]) continue;
        
        
        [self.pinsFilterRight addObject:pin];
    }
    
    //whether it is in drawing mode
    if (self.path) {
        self.pinsFilterRight = [self pinsFilterDrawAndRightFromPinsFilterRight:self.pinsFilterRight];
    }
    
    [self.ctmapView removeAnnotations:self.ctmapView.annotations];
    [self.ctmapView addAnnotations:self.pinsFilterRight];
}

- (NSMutableArray *)pinsFilterRightFromPinsAll:(NSMutableArray *)pinsAll
{
    NSMutableArray *pinsFilterRight = [NSMutableArray array];
    return pinsFilterRight;
}

- (NSMutableArray *)pinsFilterDrawAndRightFromPinsFilterRight:(NSMutableArray *)pinsFilterRight
{
    NSMutableArray *newAnnotations = [NSMutableArray array];
    for (REVClusterPin *pin in pinsFilterRight) {
        CLLocationCoordinate2D coords = pin.coordinate;
        CGPoint loc = [self.ctmapView convertCoordinate:coords toPointToView: self.pathOverlay];
        if ([self.path containsPoint:loc]) {
            [newAnnotations addObject:pin];
        }
    }
    return newAnnotations;
}

@end