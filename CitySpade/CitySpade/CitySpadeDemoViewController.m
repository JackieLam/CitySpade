//
//  CitySpadeDemoViewController.m
//  CitySpadeDemo
//
//  Created by izhuxin on 14-3-19.
//  Copyright (c) 2014年 Jeason. All rights reserved.
//
// TODO: show a loading view before all the networking work is done
#import "CitySpadeDemoViewController.h"
#import "CitySpadeCell.h"
#import "CitySpadeListsModel.h"
#import "CitySpadeBrokerWebViewController.h"
#import "Constants.h"

@interface CitySpadeDemoViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *backgroundView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *InfotableView;
@property (nonatomic, strong) NSString *BrokerTitle;
@property (strong, nonatomic) UIImageView *featureImageView;
@property (nonatomic, strong) CitySpadeListsModel *listsModel;

@end

@implementation CitySpadeDemoViewController


#pragma mark Pragma
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        if ( !_listAPI ) {
            self.listAPI = @"http://cityspade.com/api/v1/listings/123.json";
        }
        if (!_featureImage) {
            self.featureImage = [UIImage imageNamed:@"feature.png"];
        }
        if (!_basicFactsDictionary) {
            self.basicFactsDictionary = @{
                                          @"bargain" : @(8.5),
                                          @"transportation" : @(7.5),
                                          @"totalPrice" : @(375000),
                                          @"numberOfBed" : @(1),
                                          @"numberOfBath" : @(1)
                                          };
        }
        self.listsModel = [[CitySpadeListsModel alloc] initWithAPI:_listAPI];
    }
    return self;
}

#pragma mark - UIViewController LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if ( _VCtitle ) {
        _titleLabel.text = _VCtitle;
    }
    _InfotableView.dataSource = self;
    _InfotableView.delegate = self;
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.center = CGPointMake(self.view.frame.size.width / 2, 400);
    [indicator startAnimating];
    [self.view addSubview:indicator];
    [_listsModel beginFetchListWithCompletionHandler:^(NSDictionary *resultDictionary) {
        [indicator stopAnimating];
        [indicator removeFromSuperview];
        [_listsModel fetchImageForURL:resultDictionary[@"original_icon_url"] WithCompletionHandler:^(NSDictionary *resultDictionary) {
            [_InfotableView reloadData];
        }];
        [_InfotableView reloadData];
    }];
    
    //autolayout
    NSLayoutConstraint *topConstraint;
    if ( DEVICEVERSION >= 7.0 ) {
        topConstraint = [NSLayoutConstraint constraintWithItem:self.backgroundView
                                                      attribute:NSLayoutAttributeTop
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self.view attribute:NSLayoutAttributeTop
                                                     multiplier:1
                                                       constant:0];
    } else {
        topConstraint = [NSLayoutConstraint constraintWithItem:self.backgroundView
                                                      attribute:NSLayoutAttributeTop
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self.view attribute:NSLayoutAttributeTop
                                                     multiplier:1
                                                       constant:-20];
    }
    [self.view addConstraint:topConstraint];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -UITableView DataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [self headerNameAtIndex:indexPath.section];
    
    CitySpadeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if ( !cell ) {
        if ( indexPath.section == 0 ) {
            //feature image
            cell = (CitySpadeCell *)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            self.featureImageView = [[UIImageView alloc] initWithFrame:cell.frame];
            _featureImageView.image = _featureImage;
            [_featureImageView sizeToFit];
            [cell addSubview:_featureImageView];
        } else if ( indexPath.section == 1 ) {
            //Basic Facts
            cell = [CitySpadeCell TabelCellWithInfoTitle:Basic_Facts];
            [cell setValue: _basicFactsDictionary forKey:@"basicFactsDictionary"];


        } else if ( indexPath.section == 2 ) {
            //Transportation Info
            cell = [CitySpadeCell TabelCellWithInfoTitle:Transportation_Info];

        } else if ( indexPath.section == 3 ) {
            //Broker Info
            cell = [CitySpadeCell TabelCellWithInfoTitle:Broker_Info];

        } else if ( indexPath.section == 4 ) {
            //Nearby
            cell = [CitySpadeCell TabelCellWithInfoTitle:Nearby];
        }
    }
    if ( indexPath.section != 0 ) {
        [cell ConfigureCellWithItem:_listsModel];
    }
    cell.layer.shadowOpacity = 0.15;
    cell.layer.shadowOffset = CGSizeMake(1.5, 1.5);
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return numberOfInfo + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

#pragma mark -UITableViewController Delegate
- (NSString *)headerNameAtIndex: (NSInteger)index {
    return @[@"Feature Image", @"Basic Facts", @"Transportation Info", @"Broker's Info", @"Nearby"][index];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *transportationCellHeight;
    if ( !_listsModel.infoDictionary[@"transportationCellHeight"] ) {
        transportationCellHeight = @(398);
    } else {
        transportationCellHeight = _listsModel.infoDictionary[@"transportationCellHeight"];
    }
    NSNumber *cellHeight =  @[@(featureImageCellHeight), @(basicFactsCellHeight), transportationCellHeight, @(brokerInfoCellHeight), @(nearbyCellHeight)][indexPath.section];
    return [cellHeight floatValue];

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return headerHegiht;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ( section == 0 ) {
        //no header view for section zero
        return nil;
    }
    int inset = 10;
    UIView *headerView = [[UIView alloc] init];
    
    UILabel *headerLabel = [[UILabel alloc] init];
    headerLabel.frame = CGRectMake(inset, inset * 0.5, 0, 0);
    headerLabel.font = [UIFont fontWithName:@"AvenirNext-Bold"
                                       size:sessionHeaderFontSize];
    headerLabel.text = [self headerNameAtIndex:section];
    [headerLabel sizeToFit];
    
    [headerView addSubview:headerLabel];
    
    return headerView;
}

- (IBAction)pressProcceedToBroker:(id)sender {
    CitySpadeBrokerWebViewController *webViewController = [[CitySpadeBrokerWebViewController alloc] init];
    webViewController.originalIconURLString = _listsModel.infoDictionary[@"original_url"];
    [self.navigationController pushViewController:webViewController animated:YES];
}

- (IBAction)pressFavorBtn:(id)sender {

}

- (IBAction)pressForwardBtn:(id)sender {

}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
