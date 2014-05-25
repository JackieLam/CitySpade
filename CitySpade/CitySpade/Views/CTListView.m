//
//  CTListView.m
//  CitySpade
//
//  Created by Cho-Yeung Lam on 23/1/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import "CTListView.h"
#import "CTListCell.h"
#import "REVClusterPin.h"
#import "Listing.h"
#import "RestfulEngine.h"
#import "Constants.h"

#define heightForLabel 30.0f
#define heightForRow 127.0f
#define tableViewBackgroundColor [UIColor colorWithRed:234.0/255.0 green:234.0/255.0 blue:234.0/255.0 alpha:1.0]

@interface CTListView()<UITableViewDataSource, UISearchBarDelegate>
@property (nonatomic, strong) NSMutableArray *saveList;
@end

@implementation CTListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.totalCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, heightForLabel)];
        self.totalCountLabel.backgroundColor = [UIColor colorWithRed:212.0/255.0 green:239.0/255.0 blue:237.0/255.0 alpha:1.0f];
        self.totalCountLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0f];
        self.totalCountLabel.textColor = [UIColor colorWithRed:40.0/255.0 green:176.0/255.0 blue:170.0/255.0 alpha:1.0f];
        self.totalCountLabel.textAlignment = NSTextAlignmentCenter;
        self.totalCountLabel.text = [NSString stringWithFormat:@"0 results total"];
        self.tableHeaderView = self.totalCountLabel;
        
        self.backgroundColor = tableViewBackgroundColor;
        self.rowHeight = heightForRow;
        self.dataSource = self;
        self.saveList = [NSMutableArray array];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshSaveListing:) name:@"didModifySaveListing" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableView:) name:@"refreshTableView" object:nil];
    }
    return self;
}

- (void)loadPlacesToListAndReloadData:(NSArray *)places
{
    self.totalCountLabel.text = [NSString stringWithFormat:@"%d results total", [places count]];
    self.places = places;
    [self reloadData];
}

- (void)refreshTableView:(NSNotification *)aNotification
{
    NSIndexPath *indexPath = [aNotification object];
    if (indexPath) {
        CTListCell *cell = (CTListCell*)[self cellForRowAtIndexPath:indexPath];
        [cell changeState];
    }
}

#pragma mark - UITableView's DataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.places count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ListCell";
    CTListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[CTListCell alloc] initWithCTListCellStyle:CTListCellStyleSaved reuseIdentifier:CellIdentifier];
//        cell = [[CTListCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.frame = CGRectMake(0, 0, self.frame.size.width, heightForRow);
        [cell.favorBtn addTarget:self action:@selector(clickFavorBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    REVClusterPin *pin = self.places[indexPath.row];
    cell.isSaved = [self isContainInSaveListing:(int)pin.identiferNumber];
    cell.favorBtn.tag = indexPath.row + 7;

    [cell configureCellWithClusterPin:self.places[indexPath.row]];
    
    return cell;
}

- (BOOL)isContainInSaveListing:(int)identiferNumber
{
    for (Listing *listing in self.saveList) {
        int identifier = listing.internalBaseClassIdentifier;
        if (identiferNumber == identifier) {
            return YES;
        }
    }
    return NO;
}

- (void)refreshSaveListing:(NSNotification *)aNotification
{
    if (self.saveList) {
        [self.saveList removeAllObjects];
    }
    [self.saveList addObjectsFromArray:[aNotification object]];
}

- (void)clickFavorBtn:(id)sender
{
    UIButton *favorBtn = (UIButton *)sender;
    int index = (int)favorBtn.tag - 7;
    NSUserDefaults *defauts = [NSUserDefaults standardUserDefaults];
    NSString *token = [defauts objectForKey:kAccessToken];
    if (!token) {
        [SVProgressHUD showImage:[UIImage imageNamed:@"User-Profile"] status:@"Please login to save listings"];
        return;
    }
    favorBtn.selected = !favorBtn.selected;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    CTListCell *cell = (CTListCell *)[self cellForRowAtIndexPath:indexPath];
    cell.isSaved = !cell.isSaved;
    if (favorBtn.selected) {
        REVClusterPin *pin = self.places[indexPath.row];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        NSArray *images = [NSArray arrayWithObject:[NSDictionary dictionaryWithObject:pin.thumbImageLink forKey:@"url"]];
        [dic setObject:images forKey:@"images"];
        [dic setObject:[NSString stringWithFormat:@"%d",(int)pin.identiferNumber] forKey:@"id"];
        [dic setObject:[NSString stringWithFormat:@"%d",pin.bedInt] forKey:@"beds"];
        [dic setObject:pin.title forKey:@"title"];
        [dic setObject:[NSString stringWithFormat:@"%d",pin.priceInt] forKey:@"price"];
        [dic setObject:[NSString stringWithFormat:@"%d",pin.bathInt] forKey:@"baths"];
        [dic setObject:pin.bargain forKey:@"bargain"];
        [dic setObject:pin.transportation forKey:@"transportation"];
        [dic setObject:@40 forKey:@"lng"];
        [dic setObject:@70 forKey:@"lat"];
        
        [RESTfulEngine addAListingToSaveListWithId:[NSString stringWithFormat:@"%d",(int)cell.identiferNumber] onSucceeded:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationAddSaveListing object:dic userInfo:nil];
            
        } onError:^(NSError *engineError) {
            favorBtn.selected = !favorBtn.selected;
            cell.isSaved = !cell.isSaved;
        }];
    }
    else{
        [RESTfulEngine deleteAListingFromSaveListWithId:[NSString stringWithFormat:@"%d",(int)cell.identiferNumber] onSucceeded:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationDeleteSaveListing object:[NSString stringWithFormat:@"%d",(int)cell.identiferNumber] userInfo:nil];
    } onError:^(NSError *engineError) {
        favorBtn.selected = !favorBtn.selected;
        cell.isSaved = !cell.isSaved;
    }];
    }
    
    
}
@end
