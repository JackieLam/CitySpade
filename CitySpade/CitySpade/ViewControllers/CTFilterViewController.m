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
#import "RESTfulEngine.h"
#import "Constants.h"
#import "UIBarButtonItem+ProjectButton.h"
#import <MFSideMenu.h>
#import <QuartzCore/QuartzCore.h>

#define greenColor [UIColor colorWithRed:41.0/255.0 green:188.0/255.0 blue:184.0/255.0 alpha:1.0f]
#define toolbarColor [UIColor colorWithRed:60/255.0f green:193/255.0f blue:189/255.0f alpha:1.0f]
#define toolbarTextColor [UIColor colorWithRed:184/255.0f green:255/255.0f blue:252/255.0f alpha:1.0f]
#define saleMaxValue 12000000
#define rentMaxValue 12000
#define kTitleViewTag 1
#define kFilterControlCellNum 5

static const int toolBarHeight = 52;

@interface CTFilterViewController ()

@end

@implementation CTFilterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetSliderValueRange:) name:kNotificationToggleRentSale object:nil];
    [self setTableView];
    [self setTitleWithText:@"For Rent"];
    [self setApplyButton];
    [self setToolBar];
    
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
    
    CTFilterControlCell *PriceCell = [[CTFilterControlCell alloc] initWithStyle:CTFilterCellStylePrice withTableViewBlock:nil];
    CTFilterControlCell *BargainCell = [[CTFilterControlCell alloc] initWithStyle:CTFilterCellStyleBargain withTableViewBlock:^{
        [self.tableView reloadData];
    }];
    CTFilterControlCell *TransportationCell = [[CTFilterControlCell alloc] initWithStyle:CTFilterCellStyleTransportation withTableViewBlock:^{
        [self.tableView reloadData];
    }];
    CTFilterControlCell *BedrommCell = [[CTFilterControlCell alloc] initWithStyle:CTFilterCellStyleBedroom withTableViewBlock:nil];
    CTFilterControlCell *BathroomCell = [[CTFilterControlCell alloc] initWithStyle:CTFilterCellStyleBathroom withTableViewBlock:nil];
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

- (void)setApplyButton
{
    self.navigationItem.rightBarButtonItems = [UIBarButtonItem createEdgeButtonWithText:@"Apply" WithTarget:self action:@selector(didApplyFiltering)];
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
    return kFilterControlCellNum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CTFilterControlCell *cell = [cellArray objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

#pragma mark - Apply Filtering

- (void)didApplyFiltering
{
    CTFilterControlCell *cell = [cellArray objectAtIndex:0];
    CTFilterControlCell *cell1 = [cellArray objectAtIndex:1];
    CTFilterControlCell *cell2 = [cellArray objectAtIndex:2];
    CTFilterControlCell *cell3 = [cellArray objectAtIndex:3];
    CTFilterControlCell *cell4 = [cellArray objectAtIndex:4];
    NSMutableDictionary *filterData = [NSMutableDictionary dictionaryWithDictionary:[cell getSliderRangeValue]];
    filterData[@"bargain"] = [cell1 selectedItem];
    filterData[@"transportation"] = [cell2 selectedItem];
    filterData[@"beds"] = [cell3 selectedItem];
    filterData[@"baths"] = [cell4 selectedItem];
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationDidRightFilter object:filterData];
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
    [cell resetControl];
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