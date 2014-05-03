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
#import "MapCollectionCell.h"
#import "CTMapViewDelegate.h"
#import "MainTableViewDelegate.h"
#import "NSString+RegEx.h"
#import "SortTableView.h"
#import "SwitchSegment.h"
#import "BlockCache.h"

#define cellHeight 231.0f //130.0f
#define cellWidth 320.0f //290.0f
#define cellGap 0.0f //20.0f
#define cellOriginFromBottomLine cellHeight //150.0f
#define botttomHeight 44.0f
#define greenColor [UIColor colorWithRed:41.0/255.0 green:188.0/255.0 blue:184.0/255.0 alpha:1.0f]
#define sortTableViewOriginY self.ctmapView.frame.size.height - 52

@interface CTMapViewController()<SortTableViewDelegate>
{
    double previousZoomLevel;
    BOOL forRent;
    int numBlocksToLoad;
}

@property (nonatomic, strong) NSArray *listings;
@property (nonatomic, strong) NSArray *placesClicked;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeCollectionView;
// FilterDictionary
@property (nonatomic, strong) NSDictionary *filterData;

// Drawing related property
@property (nonatomic, strong) UIView *pathOverlay;
@property (nonatomic, strong) UIPanGestureRecognizer *panDrawGesture;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) UIBezierPath *path;

@property (nonatomic) float collectionViewOriginY;

@end

@implementation CTMapViewController {
    BOOL firstLocationUpdate_;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self registerNotification];
// Setup the datas
    self.listings = [NSArray array];
    self.filterData = [NSDictionary dictionary];
    self.pinsAll = [NSMutableArray array];
    self.pinsFilterRight = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    
// Setup the navigation bar
    [self setupMenuBarButtonItems];
        
// Setup the map view
    CGRect viewBounds = [UIScreen mainScreen].bounds;
    viewBounds.size.height = viewBounds.size.height - self.navigationController.navigationBar.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height;
    self.ctmapView = [[REVClusterMapView alloc] initWithFrame:viewBounds];
    self.ctmapView.delegate = [CTMapViewDelegate sharedInstance];
    [CTMapViewDelegate sharedInstance].forRent = YES;
    [self.view addSubview:self.ctmapView];
    
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = 40.747;
    coordinate.longitude = -74;
    self.ctmapView.region = MKCoordinateRegionMakeWithDistance(coordinate, 5000, 5000);
    previousZoomLevel = self.ctmapView.region.span.longitudeDelta;
    
// Setup the list view
    self.ctlistView = [[CTListView alloc] initWithFrame:viewBounds];
    self.ctlistView.delegate = [MainTableViewDelegate sharedInstance];
    
    UIView *containView = [[UIView alloc] initWithFrame:viewBounds];
    [containView addSubview:self.ctlistView];
    [containView addSubview:self.ctmapView];
    [self.view addSubview:containView];

// Setup the state Label
    self.stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -30, self.view.frame.size.width, 30)];
    self.stateLabel.backgroundColor = [UIColor colorWithRed:212.0/255.0 green:239.0/255.0 blue:237.0/255.0 alpha:0.8f];
    self.stateLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0f];
    self.stateLabel.textColor = [UIColor colorWithRed:40.0/255.0 green:176.0/255.0 blue:170.0/255.0 alpha:1.0f];
    self.stateLabel.textAlignment = NSTextAlignmentCenter;
    self.stateLabel.text = [NSString stringWithFormat:@"TEMP"];
    [self.ctmapView addSubview:self.stateLabel];
    
// Setup BottomBar
    [self setupBottomBar];
    
// Setup collectionView
    [self setupCollectionView];
    
// Setup the title
    UIColor *red = [UIColor colorWithRed:73.0f/255.0f green:73.0f/255.0f blue:73.0f/255.0f alpha:1.0];
    UIFont *font = [UIFont fontWithName:@"Avenir-Black" size:16.0f];
    NSMutableDictionary *navBarTextAttributes = [NSMutableDictionary dictionaryWithCapacity:1];
    [navBarTextAttributes setObject:font forKey:NSFontAttributeName];
    [navBarTextAttributes setObject:red forKey:NSForegroundColorAttributeName ];
    
    self.navigationController.navigationBar.titleTextAttributes = navBarTextAttributes;
    forRent = YES;
    self.title = @"For Rent";
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationToggleRentSale object:@{@"rent": [NSNumber numberWithBool:forRent]}];
}

#pragma mark - NSNotification
- (void)registerNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadForAllListings:) name:kNotificationToLoadAllListings object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePinsFilterRight:) name:kNotificationDidRightFilter object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadCollectionViewData) name:kCollectionViewShouldShowUp object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addPathOverlayOnAnnotationViews:) name:kPathOverLayShouldBeAdded object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushDetailViewController:) name:kShouldPushDetailViewController object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moveColletionCell:) name:kShouldMoveCell object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stateLabelShow:) name:kNotificationStateLabelShouldShowUp object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setBlocksToLoadCnt:) name:kNotificationBlocksCount object:nil];
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
    [self.mapBottomBar.sortButton addTarget:self action:@selector(sortButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
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
    self.collectionView.delegate = [CTMapViewDelegate sharedInstance];
    self.collectionView.dataSource = [CTMapViewDelegate sharedInstance];
    self.swipeCollectionView = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(viewDisappearAnimation:)];
    self.swipeCollectionView.direction = UISwipeGestureRecognizerDirectionDown;
    [self.collectionView addGestureRecognizer:self.swipeCollectionView];
    [self.view addSubview:self.collectionView];
}

#pragma mark - 
#pragma mark - Reload Listing(For Rent / For Sale)
- (void)setBlocksToLoadCnt:(NSNotification *)aNotification
{
    NSNumber *num = [[aNotification object] objectForKey:@"total"];
    numBlocksToLoad = [num intValue];
}

- (void)loadForAllListings:(NSNotification *)aNotification
{
    NSDictionary *param = [aNotification object];
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.navigationItem.titleView = activityIndicator;
    [activityIndicator startAnimating];
    
    // 如果改变状态，需要把地图上的点全部去掉，清除pinsAll，清除BlockCache中的loadedBlockSet
    if ([param[@"rent"] boolValue] != forRent) {
        forRent = [param[@"rent"] boolValue];
    }
    
    [RESTfulEngine loadListingsWithQuery:param onSucceeded:^(NSMutableArray *resultArray) {
        [activityIndicator stopAnimating];
        self.listings = resultArray;
        [BlockCache cacheListingItems:self.listings block:param];
        self.navigationItem.titleView = nil;
        [self resetAnnotationsWithResultArray:self.listings];
    } onError:^(NSError *engineError) {
        [activityIndicator stopAnimating];
        self.navigationItem.titleView = nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationStateLabelShouldShowUp object:@{@"content": @"Fail loading new listings", @"still": [NSNumber numberWithBool:NO]}];
    }];
}

- (void)resetAnnotationsWithResultArray:(NSArray *)resultArray
{
    NSMutableArray *newAddAnnos = [NSMutableArray array];
    for (Listing __strong *listing in resultArray) {
        REVClusterPin *pin = [[REVClusterPin alloc] init];
        [pin configureWithListing:listing];
        listing = nil;
        [self.pinsAll addObject:pin];
        if ([pin fitsFilterData:self.filterData] || [self.filterData count] == 0) {
            [newAddAnnos addObject:pin];
            [self.pinsFilterRight addObject:pin];
        }
    }
    
    if ([newAddAnnos count] > 0) {
        NSString *content = [NSString stringWithFormat:@"Loading %d more listings", [newAddAnnos count]];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationStateLabelShouldShowUp object:@{@"content": content, @"still": [NSNumber numberWithBool:NO]}];
    }
    
    [self.ctmapView addAnnotations:newAddAnnos];
}

#pragma mark - Adding PathOverlay
- (void)addPathOverlayOnAnnotationViews:(NSNotification *)aNotification
{
    NSArray *views = [aNotification object];
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

#pragma mark - UICollectionView
- (void)reloadCollectionViewData
{
    if (self.collectionView.frame.origin.y == self.collectionViewOriginY) {
        [self.collectionView reloadData];
        [self viewAppearAnimation:self.collectionView];
    }
    else {
        [self.collectionView reloadData];
    }
}

- (void)moveColletionCell:(NSNotification *)aNotification
{
    int isNext = [[aNotification object] intValue];
    CGPoint offsetPoint = self.collectionView.contentOffset;
    if (isNext == 1) {
        offsetPoint.x += 320;
    }
    else{
        offsetPoint.x -= 320;
    }
    if (offsetPoint.x <= 0) {
        offsetPoint.x = 0;
    }
    else if(offsetPoint.x >= self.collectionView.contentSize.width){
        offsetPoint.x -= 320;
    }
    [self.collectionView setContentOffset:offsetPoint animated:YES];
}

- (void)viewAppearAnimation:(id)sender
{
    UIView *view = (UIView *)sender;
    CGRect viewFrame = view.frame;
    if ([sender isKindOfClass:[UICollectionView class]]) {
        viewFrame.origin.y = viewFrame.origin.y - cellHeight;
    }
    else if ([sender isKindOfClass:[SortTableView class]]) {
        viewFrame.origin.y = viewFrame.origin.y - 90.0f;
        viewFrame.size.height = 90.0f;
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    [UIView setAnimationDelay:0.0];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    view.frame = viewFrame;
    [UIView commitAnimations];
}

- (void)viewDisappearAnimation:(id)sender
{
    UIView *view;
    CGRect viewFrame;
    if ([sender isKindOfClass:[UISwipeGestureRecognizer class]]) {  // UIViewCollectionView
        view = self.collectionView;
        viewFrame = view.frame;
        viewFrame.origin.y = viewFrame.origin.y + cellHeight;
    }
    else if ([sender isKindOfClass:[UITableView class]]) {
        view = (UIView *)sender;
        viewFrame = view.frame;
        viewFrame.origin.y = viewFrame.origin.y + 90.0f;
        viewFrame.size.height = 0.0f;
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    [UIView setAnimationDelay:0.0];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    view.frame = viewFrame;
    [UIView commitAnimations];
}

#pragma mark - UIBarButtonItem Callbacks
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

#pragma mark - Push DetailViewController
- (void)pushDetailViewController:(NSNotification *)aNotification
{
    CTDetailViewController *detailViewController = [aNotification object];
    [self.navigationController pushViewController:detailViewController animated:YES];
}

#pragma mark - MapBottomBar Button

-(void)segmentAction:(UISegmentedControl*)sender
{
    if (sender.selectedSegmentIndex == 0) {
        [self.mapBottomBar resetBarState:BarStateMapDefault];
        [self.sortTableView removeFromSuperview];
        [UIView transitionFromView:self.ctlistView toView:self.ctmapView duration:1.0 options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished) {
            // 方法放这里的话会有延迟
        }];
    }
    else {
        [self.mapBottomBar resetBarState:BarStateList];
        [UIView transitionFromView:self.ctmapView toView:self.ctlistView duration:1.0 options:UIViewAnimationOptionTransitionFlipFromRight completion:^(BOOL finished) {
            [self.ctlistView loadPlacesToListAndReloadData:self.pinsFilterRight];
            CGRect bottomBarFrame = self.mapBottomBar.frame;
            self.sortTableView = [[SortTableView alloc] initWithFrame:CGRectMake(bottomBarFrame.origin.x, bottomBarFrame.origin.y, bottomBarFrame.size.width, 0) delegate:self];
            [self.view addSubview:self.sortTableView];
        }];
    }
}

- (void)saveButtonClicked:(id)sender
{
    //http example
    //api.geonames.org/neighbourhood?lat=+40.73559374&lng=-73.98076775&username=jackielam1992
    CLLocation *locationToSave = [[CLLocation alloc] initWithLatitude:self.ctmapView.centerCoordinate.latitude longitude:self.ctmapView.centerCoordinate.longitude];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:locationToSave completionHandler:^(NSArray *placemarks, NSError *error) {
        //10
        if(placemarks.count){
            NSDictionary *dictionary = [[placemarks objectAtIndex:0] addressDictionary];
            NSLog(@"CURRENT ADDRESS: %@", dictionary);
        }
    }];
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

- (void)sortButtonClicked:(id)sender
{
    if (self.sortTableView.frame.size.height == 0.0f) {
        [self viewAppearAnimation:self.sortTableView];
    }
    else {
        [self viewDisappearAnimation:self.sortTableView];
    }
}

#pragma mark - State Label
- (void)stateLabelShow:(NSNotification *)aNotification
{
    NSDictionary *notiObj = [aNotification object];
    self.stateLabel.text = notiObj[@"content"];
    
    if (self.stateLabel.frame.origin.y == -30.0f) {
        CGRect appearRect = self.stateLabel.frame;
        appearRect.origin.y += 30.0f;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationDelay:0.0];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        self.stateLabel.frame = appearRect;
        [UIView commitAnimations];
    }
    
// 不停留显示立即收回
    if ([notiObj[@"still"] isEqualToNumber:[NSNumber numberWithBool:NO]]) {
        if (self.stateLabel.frame.origin.y == 0.0f) {
            CGRect disappearRect = self.stateLabel.frame;
            disappearRect.origin.y -= 30.0f;
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3];
            [UIView setAnimationDelay:1.0f];
            [UIView setAnimationCurve:UIViewAnimationCurveLinear];
            self.stateLabel.frame = disappearRect;
            [UIView commitAnimations];
        }
    }
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

#pragma mark - Filtering
// 由Notification调用
- (void)updatePinsFilterRight:(NSNotification *)aNotification
{
    [self.pinsFilterRight removeAllObjects];
    self.filterData = [aNotification object];
    for (REVClusterPin *pin in self.pinsAll) {
        if ([pin fitsFilterData:self.filterData])
            [self.pinsFilterRight addObject:pin];
    }
    
    //whether it is in drawing mode
    if (self.path) {
        self.pinsFilterRight = [self pinsFilterDrawAndRightFromPinsFilterRight:self.pinsFilterRight];
    }
    
    [self.ctmapView removeAnnotations:self.ctmapView.annotations];
    [self.ctmapView resetAnnotationsCopy:self.pinsFilterRight]; //需要reset一下底层的mapView
    [self.ctmapView addAnnotations:self.pinsFilterRight];
    [self.ctlistView loadPlacesToListAndReloadData:self.pinsFilterRight];
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

#pragma mark - SortTableViewDelegate
- (void)sortTableViewDidSelectOption:(SortOption)option
{
    NSSortDescriptor *sortDescriptor;
    switch (option) {
        case PRICE_HIGH_LOW:
        {
            sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"priceInt" ascending:NO];
        }
            break;
        case PRICE_LOW_HIGH:
        {
            sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"priceInt" ascending:YES];
        }
            break;
        case BARGAIN_HIGH_LOW:
        {
            sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"bargainDouble" ascending:NO];
        }
            break;
        case BARGAIN_LOW_HIGH:
        {
            sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"bargainDouble" ascending:YES];
        }
            break;
        case TRANSPORT_HIGH_LOW:
        {
            sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"transportationDouble" ascending:NO];
        }
            break;
        case TRANSPORT_LOW_HIGH:
        {
            sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"transportationDouble" ascending:YES];
        }
            break;
            
            
        default:
            break;
    }
    [self.ctlistView loadPlacesToListAndReloadData:[self.ctlistView.places sortedArrayUsingDescriptors:@[sortDescriptor]]];
}

@end