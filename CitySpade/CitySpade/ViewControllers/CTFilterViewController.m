//
//  CTFilterViewController.m
//  CitySpade
//
//  Created by Cho-Yeung Lam on 22/1/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import "CTFilterViewController.h"
#import "CTFilterControlCell.h"
#import "BTPickerView.h"
#import "BedSegment.h"
#import "NMRangeSlider.h"
#import "RESTfulEngine.h"
#import "Constants.h"
#import "BTPickerView.h"
#import "UIBarButtonItem+ProjectButton.h"
#import <MFSideMenu.h>
#import <QuartzCore/QuartzCore.h>

#define greenColor [UIColor colorWithRed:41.0/255.0 green:188.0/255.0 blue:184.0/255.0 alpha:1.0f]
#define toolbarColor [UIColor colorWithRed:60/255.0f green:193/255.0f blue:189/255.0f alpha:1.0f]
#define toolbarTextColor [UIColor colorWithRed:184/255.0f green:255/255.0f blue:252/255.0f alpha:1.0f]
#define saleMaxValue 120000000
#define rentMaxValue 120000
#define kTitleViewTag 1

static const int toolBarHeight = 52;

@interface CTFilterViewController ()

@end

@implementation CTFilterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView) name:@"reload" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetSliderValueRange:) name:kNotificationToggleRentSale object:nil];
    [self setTableView];
    
    [self setTitleWithText:@"For Rent"];
//    [self setSearchBar];
    [self setApplyButton];
    [self setToolBar];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //    [self updateRangeLabel:self.rangeSlider];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self dismissSearchControllerWhileStayingActive];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - SetPerformance

- (void)setTableView
{
    //SetTableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -38, 320, self.view.bounds.size.height-78) style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.placesTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 110.0f, 300.0f, self.view.bounds.size.height-66.0f)];
    self.placesTableView.delegate = self;
    self.placesTableView.dataSource = self;
    self.placesTableView.alpha = 0.0f;
    
    CTFilterControlCell *PriceCell = [[CTFilterControlCell alloc] initWithStyle:CTFilterCellStylePrice];
    CTFilterControlCell *BargainCell = [[CTFilterControlCell alloc] initWithStyle:CTFilterCellStyleBargain];
    CTFilterControlCell *TransportationCell = [[CTFilterControlCell alloc] initWithStyle:CTFilterCellStyleTransportation];
    CTFilterControlCell *BedrommCell = [[CTFilterControlCell alloc] initWithStyle:CTFilterCellStyleBedroom];
    CTFilterControlCell *BathroomCell = [[CTFilterControlCell alloc] initWithStyle:CTFilterCellStyleBathroom];
    [BargainCell.bargainPickerView.headerButton addTarget:self action:@selector(reloadTableView) forControlEvents:UIControlEventTouchUpInside];
    [TransportationCell.transportationPickerView.headerButton addTarget:self action:@selector(reloadTableView) forControlEvents:UIControlEventTouchUpInside];
    cellArray = [NSArray arrayWithObjects:PriceCell,BargainCell,TransportationCell,BedrommCell,BathroomCell, nil];
}

- (void)setTitleAttribute
{
    UIColor *red = [UIColor colorWithRed:73.0f/255.0f green:73.0f/255.0f blue:73.0f/255.0f alpha:1.0];
    UIFont *font = [UIFont fontWithName:@"Avenir-Black" size:16.0f];
    NSMutableDictionary *navBarTextAttributes = [NSMutableDictionary dictionaryWithCapacity:1];
    [navBarTextAttributes setObject:font forKey:NSFontAttributeName];
    [navBarTextAttributes setObject:red forKey:NSForegroundColorAttributeName ];
    self.navigationController.navigationBar.titleTextAttributes = navBarTextAttributes;
}

- (void)setTitleWithText:(NSString *)title
{
    self.title = title;
}

- (void)setSearchBar
{
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0, 195.0f, 43.0f)];
    self.searchBar.backgroundColor = [UIColor clearColor];
    self.searchBar.placeholder = @" New York NY             ";
    self.searchBar.userInteractionEnabled = YES;
    self.searchBar.delegate = self;
    shouldBeginEditing = YES;
    [self.view addSubview:self.searchBar];
}

- (void)setApplyButton
{
    self.navigationItem.rightBarButtonItems = [UIBarButtonItem createEdgeButtonWithText:@"Filter" WithTarget:self action:@selector(didApplyFiltering)];
}

- (void)setToolBar {
    CGRect toolBarFrame = CGRectMake(0,
                                     self.view.frame.size.height-toolBarHeight-64,
                                     self.view.frame.size.width,
                                     toolBarHeight);
    UIView *toolBarView = [[UIView alloc] initWithFrame:toolBarFrame];
    toolBarView.backgroundColor = toolbarColor;
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 19, 46, 14)];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont fontWithName:@"Avenir-Roman" size:15.0f];
    [cancelButton setTitleColor:toolbarTextColor forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelFilter) forControlEvents:UIControlEventTouchUpInside];
    UIButton *resetButton = [[UIButton alloc] initWithFrame:CGRectMake(438.0f/2, 19, 40, 14)];
    [resetButton setTitle:@"Reset" forState:UIControlStateNormal];
    resetButton.titleLabel.font = [UIFont fontWithName:@"Avenir-Roman" size:15.0f];
    [resetButton setTitleColor:toolbarTextColor forState:UIControlStateNormal];
    [resetButton addTarget:self action:@selector(resetFilter) forControlEvents:UIControlEventTouchUpInside];
    [toolBarView addSubview:cancelButton];
    [toolBarView addSubview:resetButton];
    [self.view addSubview:toolBarView];
}

- (void)reloadTableView
{
    [self.tableView reloadData];
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        return 5;
    }
    else{
        return searchResultPlaces.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        CTFilterControlCell *cell = [cellArray objectAtIndex:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else{
        static NSString *cellIdentifier = @"PlacesAutocompleteCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.font = [UIFont fontWithName:@"Avenir-Roman" size:16.0];
        cell.textLabel.text = [searchResultPlaces objectAtIndex:indexPath.row];
        return cell;
    }
}

#pragma mark - Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.searchBar.text = [searchResultPlaces objectAtIndex:indexPath.row];
    [self dismissSearchControllerWhileStayingActive];
}

#pragma mark - UISearchBar Delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchBar isFirstResponder]) {
        shouldBeginEditing = NO;
        static NSTimer *searchWordTimer;
        
        if (searchWordTimer) {
            
            if ([searchWordTimer isValid]) {
                [searchWordTimer invalidate];
            }
            
            searchWordTimer = nil;
        }
        searchWordTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(handleSearchForSearchString:) userInfo:searchText repeats:NO];
    }
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    if (shouldBeginEditing) {
        NSTimeInterval animationDuration = 0.3;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:animationDuration];
        self.placesTableView.alpha = 0.75;
        [self.view addSubview:self.placesTableView];
        [UIView commitAnimations];
    }
    BOOL boolToReturn = shouldBeginEditing;
    shouldBeginEditing = YES;
    return boolToReturn;
}

#pragma mark - Apply Filtering

- (void)didApplyFiltering
{
    CTFilterControlCell *cell = [cellArray objectAtIndex:0];
    CTFilterControlCell *cell1 = [cellArray objectAtIndex:1];
    CTFilterControlCell *cell2 = [cellArray objectAtIndex:2];
    CTFilterControlCell *cell3 = [cellArray objectAtIndex:3];
    CTFilterControlCell *cell4 = [cellArray objectAtIndex:4];
    NSMutableDictionary *filterData = [NSMutableDictionary dictionary];
    filterData[@"lowerBound"] = [NSString stringWithFormat:@"%d", (int)cell.rangeSlider.lowerValue];
    filterData[@"higherBound"] = [NSString stringWithFormat:@"%d", (int)cell.rangeSlider.upperValue];
    filterData[@"bargain"] = [cell1 selectedItem];
    filterData[@"transportation"] = [cell2 selectedItem];
    filterData[@"beds"] = [cell3 selectedItem];
    filterData[@"baths"] = [cell4 selectedItem];
    NSLog(@"filterData:%@",filterData);
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationDidRightFilter object:filterData];
    [self.searchBar resignFirstResponder];
    [self dismissSearchControllerWhileStayingActive];
}

#pragma mark - search for Text

- (void)handleSearchForSearchString:(id)sender {
    
    NSString *searchtext = [(NSString *)[sender userInfo] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"search:%@",searchtext);
    [RESTfulEngine searchPlacesWithName:searchtext onSucceeded:^(NSMutableArray *resultArray) {
        searchResultPlaces = resultArray;
        [self.placesTableView reloadData];
    } onError:^(NSError *engineError) {
        
    }];
}

#pragma mark - dismiss PlacesTableview

- (void)dismissSearchControllerWhileStayingActive {
    NSTimeInterval animationDuration = 0.3;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    self.placesTableView.alpha = 0.0;
    [self.placesTableView removeFromSuperview];
    [UIView commitAnimations];
    [self.searchBar resignFirstResponder];
}

#pragma mark - Reset the slider's value range

- (void)resetSliderValueRange:(NSNotification *)aNotification
{
    NSDictionary *param = [aNotification object];
    BOOL forRent = [param[@"rent"] boolValue];
    CTFilterControlCell *cell = [cellArray objectAtIndex:0];
    if (forRent){
        [cell setSliderWithMaxValue:rentMaxValue minValue:0];
        [self setTitleWithText:@"For Rent"];
    }
    else{
        [cell setSliderWithMaxValue:saleMaxValue minValue:0];
        [self setTitleWithText:@"For Sale"];
    }
}

#pragma mark - Toolbar button method

- (void)cancelFilter
{
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
}

- (void)resetFilter
{
    for (CTFilterControlCell *cell in cellArray) {
        [cell resetControl];
    }
    [self.tableView reloadData];
}
@end