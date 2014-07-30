//
//  CTSavingsViewController.m
//  CitySpade
//
//  Created by Cho-Yeung Lam on 14/3/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import "CTSavingsViewController.h"
#import "CTListCell.h"
#import "RESTfulEngine.h"
#import "AppCache.h"
#import "Constants.h"
#import "QuartzCore/QuartzCore.h"
#import "NSString+RegEx.h"
#import "AsynImageView.h"
#import "CitySpadeDemoViewController.h"
#import "Listing.h"
#import "SVProgressHUD.h"
#import <MFSideMenu.h>

#define TitleColor [UIColor colorWithRed:91/255.0 green:91/255.0 blue:91/255.0 alpha:1.0]
#define SegmentTintColor [UIColor colorWithRed:42/255.0 green:188/255.0 blue:184/255.0 alpha:1.0]
#define BarButtonTintColor [UIColor colorWithRed:151/255.0 green:151/255.0 blue:151/255.0 alpha:1.0]
#define TableViewBackGroundColor [UIColor colorWithRed:0.9294 green:0.9294 blue:0.9294 alpha:1.0]
#define kNoLoginViewTag 1
@interface CTSavingsViewController ()
@property (nonatomic, strong) NSMutableArray *saveList;
@property (nonatomic, strong) UIBarButtonItem *myEditButtonItem;
@property (nonatomic, strong) UIBarButtonItem *trashButtonItem;
@property (nonatomic, strong) UIBarButtonItem *cancelButtonItem;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, assign) BOOL isUpdated;
@end

@implementation CTSavingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addListingFromToSaveListing:) name:kNotificationAddSaveListing object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteListingFromSaveListing:) name:kNotificationDeleteSaveListing object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpAppearance];
    _isUpdated = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([self isLogined]) {
        UIImageView *noLoginImageView = (UIImageView*)[self.view viewWithTag:kNoLoginViewTag];
        if (noLoginImageView) {
            [noLoginImageView removeFromSuperview];
        }
        self.tableView.scrollEnabled = YES;
        [self reloadSaveListingFromCache];
    }
    else{
        UIImageView *noLoginImageView = (UIImageView*)[self.view viewWithTag:kNoLoginViewTag];
        if (noLoginImageView == nil) {
            noLoginImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_logined"]];
            noLoginImageView.tag = kNoLoginViewTag;
            [self.view addSubview:noLoginImageView];
            [self.saveList removeAllObjects];
            self.tableView.scrollEnabled = NO;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma TableView Delegate and Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.saveList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SaveListCell";
    
    CTListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[CTListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell configureCellWithListing:self.saveList[indexPath.row]];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 255.0/2;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    CTListCell *cell = (CTListCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.rightView.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1.0f];
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    CTListCell *cell = (CTListCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.rightView.backgroundColor = [UIColor whiteColor];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!tableView.editing) {
        CTListCell *cell = (CTListCell *)[tableView cellForRowAtIndexPath:indexPath];
        cell.rightView.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1.0f];
        CitySpadeDemoViewController *detailViewController = [[CitySpadeDemoViewController alloc] init];
        
        detailViewController.VCtitle = cell.titleLabel.text;
        detailViewController.listID = [NSString stringWithFormat:@"%d", (int)cell.identiferNumber];
        detailViewController.featureImageUrl = cell.thumbImageView.imageURL;
        NSString *bargain = [cell.bargainLabel.text substringFromIndex:17];
        NSString *transportation = [cell.transportLabel.text substringFromIndex:16];
        NSNumber *price = [NSNumber numberWithInt:[[cell.priceLabel.text firstNumberInString] intValue]];
        NSNumber *bed = [NSNumber numberWithInt:[[cell.bedLabel.text firstNumberInString] intValue]];
        NSNumber *bath = [NSNumber numberWithInt:[[cell.bathLabel.text firstNumberInString] intValue]];
        NSArray *basicFactDict = @[@{@"bargain" : bargain,
                                     @"transportation" : transportation,
                                     @"totalPrice" : price,
                                     @"numberOfBed" : bed,
                                     @"numberOfBath" : bath},
                                   @{@"lng": @40, @"lat": @70}];
        detailViewController.preViewInfo = basicFactDict;
        detailViewController.isSaved = 1;
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
    else{
        if (self.navigationItem.rightBarButtonItem != self.trashButtonItem) {
            self.navigationItem.rightBarButtonItem = self.trashButtonItem;
        }
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.editing) {
        if ([[self.tableView indexPathsForSelectedRows] count] == 0 && self.navigationItem.rightBarButtonItem != self.cancelButtonItem) {
            self.navigationItem.rightBarButtonItem = self.cancelButtonItem;
        }
    }
}

#pragma private method

- (void)setUpAppearance
{
    //设置NavigationItem Title
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 110, 100, 30)];
    [_titleLabel setTextColor:TitleColor];
    [_titleLabel setText:@"My Saves"];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont fontWithName:@"Avenir-Black" size:16];
    _titleLabel.textColor = [UIColor colorWithRed:90/255.0 green:90/255.0 blue:90/255.0 alpha:1.0];
    self.navigationItem.titleView = _titleLabel;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = TableViewBackGroundColor;
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    self.tableView.scrollsToTop = YES;
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull down to refresh"];
    [self.refreshControl addTarget:self action:@selector(reloadSaveListing:) forControlEvents:UIControlEventValueChanged];
    //设置navigationItem's leftBarButtonItem,rightBarButtonItem
    
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"userProfile"] style:UIBarButtonItemStyleDone target:self action:@selector(backButtonPressed:)];
    leftButtonItem.tintColor = BarButtonTintColor;
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    self.myEditButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleDone target:self action:@selector(startRemoveItem)];
    [self.myEditButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Avenir-Roman"size:15],NSFontAttributeName, BarButtonTintColor,NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    self.trashButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"trash"] style:UIBarButtonItemStyleDone target:self action:@selector(finishRempveItem)];
    self.trashButtonItem.tintColor = BarButtonTintColor;
    self.navigationItem.rightBarButtonItem = self.myEditButtonItem;
    self.cancelButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(cancelRemoveItem)];
    [self.cancelButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Avenir-Roman"size:15],NSFontAttributeName, BarButtonTintColor,NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
}

- (void)reloadSaveListingFromCache
{
    self.saveList = [AppCache getCachedSaveList];
    if (self.saveList) {
        if (_isUpdated == NO) {
            _isUpdated = YES;
            UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [indicatorView startAnimating];
            self.navigationItem.titleView = indicatorView;
            [RESTfulEngine loadUserSaveList:^(NSMutableArray *resultArray) {
                if (_saveList) {
                    [_saveList removeAllObjects];
                }
                _saveList = resultArray;
                [AppCache cacheSaveList:_saveList];
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationDidModifySaveListing object:_saveList];
                [indicatorView stopAnimating];
                self.navigationItem.titleView = _titleLabel;
                [self.tableView reloadData];
            } onError:^(NSError *engineError) {
                [indicatorView stopAnimating];
                self.navigationItem.titleView = _titleLabel;
            }];
        }
        else {
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationDidModifySaveListing object:self.saveList];
            [self.tableView reloadData];
        }
    }
    if (!self.saveList || [AppCache isSaveListStale]){
        [self reloadSaveListing:nil];
    }
}

- (void)reloadSaveListing:(NSNotification *)aNotification
{
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Loading..."];
    [RESTfulEngine loadUserSaveList:^(NSMutableArray *resultArray) {
        if (_saveList) {
            [_saveList removeAllObjects];
        }
        _saveList = resultArray;
        [AppCache cacheSaveList:_saveList];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationDidModifySaveListing object:_saveList];
        [self.refreshControl endRefreshing];
        self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull down to refresh"];
        [self.tableView reloadData];
    } onError:^(NSError *engineError) {
        [self.refreshControl endRefreshing];
        self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull down to refresh"];
    }];
}

- (void)removeAllSaveListing
{
    _isUpdated = NO;
    [self.saveList removeAllObjects];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationDidModifySaveListing object:self.saveList];
}

- (void)addListingFromToSaveListing:(NSNotification *)aNotification
{
    Listing *listing = [[Listing alloc] initWithDictionary:[aNotification object]];
    [self.saveList insertObject:listing atIndex:0];
    [AppCache cacheSaveList:self.saveList];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationDidModifySaveListing object:self.saveList];
}

- (void)deleteListingFromSaveListing:(NSNotification *)aNotification
{
    NSString *identifierString = [aNotification object];
    int identifierNumber = [identifierString intValue];
    int index = 0;
    for (Listing *listing in self.saveList) {
        if ((int)listing.internalBaseClassIdentifier == identifierNumber) {
            [self.saveList removeObjectAtIndex:index];
            break;
        }
        index ++;
    }
    [AppCache cacheSaveList:self.saveList];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationDidModifySaveListing object:self.saveList];
}


- (void)startRemoveItem
{
    [self.tableView setEditing:YES animated:YES];
    self.navigationItem.rightBarButtonItem = self.cancelButtonItem;
}

- (void)finishRempveItem
{
    [self performSelector:@selector(deleteButtonClicked)];
    [self.tableView setEditing:NO animated:YES];
    self.navigationItem.rightBarButtonItem = self.myEditButtonItem;
}

- (void)cancelRemoveItem
{
    [self.tableView setEditing:NO animated:YES];
    self.navigationItem.rightBarButtonItem = self.myEditButtonItem;
}

- (void)deleteButtonClicked
{
    NSArray *selectedRows = [self.tableView indexPathsForSelectedRows];
    NSMutableArray *rowsToDelete = [NSMutableArray array];
    NSMutableArray *rowsToCount = [NSMutableArray array];
    BOOL deleteSpecificRows = selectedRows.count > 0;
    
    if (deleteSpecificRows)
    {
        if ([RESTfulEngine isConnectedToNetwork]) {
            [SVProgressHUD showWithStatus:@"Deleting"];
        }
        for (NSIndexPath *selectionIndex in selectedRows) {
            Listing *listing = [self.saveList objectAtIndex:selectionIndex.row];
            [RESTfulEngine deleteAListingFromSaveListWithId:[NSString stringWithFormat:@"%d", (int)listing.internalBaseClassIdentifier] onSucceeded:^{
                [rowsToDelete addObject:selectionIndex];
                [rowsToCount addObject:selectionIndex];
                if (rowsToCount.count == selectedRows.count) {
                    [self deleteRows:rowsToDelete];
                    if ([RESTfulEngine isConnectedToNetwork]) {
                        [SVProgressHUD dismiss];
                    }
                }
            } onError:^(NSError *engineError) {
                [rowsToCount addObject:selectionIndex];
                if (rowsToCount.count == selectedRows.count) {
                    [self deleteRows:rowsToDelete];
                    if ([RESTfulEngine isConnectedToNetwork]) {
                        [SVProgressHUD dismiss];
                    }
                }
            }];
        }
    }
}

- (void)deleteRows:(NSArray*)deletedRows
{
    NSMutableIndexSet *indexSet = [NSMutableIndexSet new];
    for (NSIndexPath *selectionIndex in deletedRows) {
        [indexSet addIndex:selectionIndex.row];
    }
    if (deletedRows.count > 0) {
        [self.saveList removeObjectsAtIndexes:indexSet];
        [AppCache cacheSaveList:self.saveList];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationDidModifySaveListing object:self.saveList];
        [self.tableView deleteRowsAtIndexPaths:deletedRows withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    self.navigationItem.rightBarButtonItem = self.myEditButtonItem;
}

- (void)backButtonPressed:(id)sender {
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
//        [self setupMenuBarButtonItems];
    }];
    UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
    [navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)isLogined
{
    NSUserDefaults *defauts = [NSUserDefaults standardUserDefaults];
    NSString *token = [defauts objectForKey:kAccessToken];
    if (token) {
        return YES;
    }
    else{
        return NO;
    }
}


@end
