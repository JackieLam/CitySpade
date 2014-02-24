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
#import "RESTfulEngine.h"
#import "Listing.h"

#define cellHeight 130.0f
#define cellWidth 290.0f
#define cellGap 20.0f
#define cellOriginFromBottomLine 150.0f
#define botttomHeight 44.0f
#define greenColor [UIColor colorWithRed:41.0/255.0 green:188.0/255.0 blue:184.0/255.0 alpha:1.0f]

@interface CTMapViewController()
{
    double previousZoomLevel;
}

@property (nonatomic, strong) NSMutableArray *pins;
@property (nonatomic, strong) NSArray *places;
@property (nonatomic, strong) NSArray *placesClicked;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeCollectionView;
//Drawing related property
@property (nonatomic, strong) UIView *pathOverlay;
@property (nonatomic, strong) UIPanGestureRecognizer *panDrawGesture;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) UIBezierPath *path;

@end

@implementation CTMapViewController {
    BOOL firstLocationUpdate_;
}

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
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
    previousZoomLevel = self.ctmapView.region.span.longitudeDelta;
    
// Setup BottomBar
    [self setupBottomBar];

// Setup the list view
    self.ctlistView = [[CTListView alloc] initWithFrame:viewBounds];
    self.ctlistView.delegate = self;

// Setup collectionView
    [self setupCollectionView];
    
// RESTfulEngine
    NSDictionary *dict = @{@"rent": @"1"};
    [RESTfulEngine loadListingsWithQuery:dict onSucceeded:^(NSMutableArray *resultArray) {
        
        self.pins = [NSMutableArray array];
        for (Listing *listing in resultArray) {
            
            REVClusterPin *pin = [[REVClusterPin alloc] init];
            pin.title = listing.title;
            pin.subtitle = [[NSNumber numberWithDouble:listing.price] stringValue];
            pin.coordinate = CLLocationCoordinate2DMake(listing.lat, listing.lng);
            [self.pins addObject:pin];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.ctmapView addAnnotations:self.pins];
        });
        
    } onError:^(NSError *engineError) {
        //
    }];
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

#pragma mark - MapBottomBar Button

-(void)segmentAction:(UISegmentedControl*)sender
{
    if (sender.selectedSegmentIndex == 0) {
        [UIView transitionFromView:self.ctlistView toView:self.ctmapView duration:1.0 options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished) {
            [self.ctlistView removeFromSuperview];
            [self.view addSubview:self.ctmapView];
            [self.view bringSubviewToFront:self.mapBottomBar];
        }];
    }
    else {
        [UIView transitionFromView:self.ctmapView toView:self.ctlistView duration:1.0 options:UIViewAnimationOptionTransitionFlipFromRight completion:^(BOOL finished) {
            [self.ctmapView removeFromSuperview];
            [self.view insertSubview:self.ctlistView belowSubview:self.mapBottomBar];
            [self.view bringSubviewToFront:self.mapBottomBar];
            [self.ctlistView loadPlacesToList:self.places];
        }];
    }
}

- (void)saveButtonClicked:(id)sender
{
    NSLog(@"saveButtonClicked");
}

- (void)drawButtonClicked:(id)sender
{
    [self.mapBottomBar resetBarState:BarStateMapDraw];
    self.ctmapView.zoomEnabled = NO;
    self.ctmapView.scrollEnabled = NO;
    self.ctmapView.rotateEnabled = NO;
    self.pathOverlay.userInteractionEnabled = YES;
}

- (void)cancelButtonClicked:(id)sender
{
    if (self.path) {
        [self.path removeAllPoints];
        self.shapeLayer.path = [self.path CGPath];
    }
    [self.ctmapView recoverFromSearch];
    self.ctmapView.zoomEnabled = YES;
    self.ctmapView.scrollEnabled = YES;
    self.ctmapView.rotateEnabled = YES;
    self.pathOverlay.userInteractionEnabled = NO;
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
            self.shapeLayer.lineWidth = 5.0;
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
        NSMutableArray *newAnnotations = [NSMutableArray array];
        for (REVClusterPin *pin in self.pins) {
            CLLocationCoordinate2D coords = pin.coordinate;
            CGPoint loc = [self.ctmapView convertCoordinate:coords toPointToView: self.pathOverlay];
            if ([self.path containsPoint:loc]) {
                [newAnnotations addObject:pin];
            }
        }
        [self.ctmapView addAnnotations:newAnnotations];
    }
}


@end