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
#import "CitySpadeModelManager.h"
#import "CitySpadeBrokerWebViewController.h"
#import "constant.h"
#import "BaseClass.h"

@interface CitySpadeDemoViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *favorBtn;

@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UITableView *infotableView;
@property (nonatomic, strong) NSString *brokerTitle;
@property (strong, nonatomic) UIImageView *featureImageView;
@property (atomic, strong) CitySpadeModelManager *manager;
@property (nonatomic, strong) BaseClass *baseList;

@end

@implementation CitySpadeDemoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.manager = [CitySpadeModelManager sharedManager];
    }
    return self;
}

#pragma mark - UIViewController LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _infotableView.dataSource = self;
    _infotableView.delegate = self;
    [_infotableView setTableHeaderView:nil];
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.center = CGPointMake(self.view.frame.size.width / 2, 400);
    [indicator startAnimating];
    [self.view addSubview:indicator];
    
    NSString *listAPI = [listAPIRootURL stringByAppendingString:
                         [NSString stringWithFormat:@"%@.json", _listID]];
    
    [_manager beginFetchList: listAPI WithCompletionHandler:^(BaseClass *baseList) {
        [indicator stopAnimating];
        [indicator removeFromSuperview];
        [_manager fetchImageForURL:baseList.originalIconUrl WithCompletionHandler:^{
            [_infotableView reloadData];
        }];

        self.baseList = baseList;
        [_infotableView reloadData];
        [_infotableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:YES];
    }];
    
    
    if([[UINavigationBar class] respondsToSelector:@selector(appearance)]){
        [[UINavigationBar appearance] setTitleTextAttributes:
         @{
           NSForegroundColorAttributeName:[UIColor colorWithRed:122.0/255.0
                                                          green:122.0/255.0
                                                           blue:122.0/255.0
                                                          alpha:1.0],
           NSFontAttributeName: [UIFont fontWithName:@"Avenir-Black" size:15]
           }
         ];
    }
    self.title = self.VCtitle;
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 36)];
    [backButton setImage:[UIImage imageNamed:@"navbar_backbtn"] forState:UIControlStateNormal];
    [backButton addTarget:self
                   action:@selector(back:)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backNavigationItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    [self.favorBtn setImage:[UIImage imageNamed:@"LikePressed.png"] forState:UIControlStateSelected];
    
    NSLayoutConstraint *topConstraint;
    if ( DEVICEVERSION >= 7.0 ) {
        //autolayout
        topConstraint = [NSLayoutConstraint constraintWithItem:self.backgroundView
                                                      attribute:NSLayoutAttributeTop
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self.view attribute:NSLayoutAttributeTop
                                                     multiplier:1
                                                       constant:0];
        //navigation
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = -10;
        self.navigationItem.leftBarButtonItems = @[negativeSpacer, backNavigationItem];
    } else {
        topConstraint = [NSLayoutConstraint constraintWithItem:self.backgroundView
                                                      attribute:NSLayoutAttributeTop
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self.view attribute:NSLayoutAttributeTop
                                                     multiplier:1
                                                       constant:-20];
        
        self.navigationItem.leftBarButtonItem = backNavigationItem;
    }
    self.navigationController.navigationBar.translucent = NO;
    //self.navigationItem.leftBarButtonItem = backNavigationItem;

    [self.view addConstraint:topConstraint];
}

- (void)viewDidAppear:(BOOL)animated {
    [_infotableView reloadData];
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
            _featureImageView = [[UIImageView alloc] init];
            CGRect featureImageViewFrame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, featureImageCellHeight);
            [_featureImageView setFrame:featureImageViewFrame];
            [_featureImageView setImage:_featureImage];
            [cell addSubview:_featureImageView];
        } else if ( indexPath.section == 1 ) {
            //Basic Facts
            cell = [CitySpadeCell TabelCellWithInfoTitle:Basic_Facts];
            [cell setValue: _preViewInfo[0] forKey:@"basicFactsDictionary"];
        } else if ( indexPath.section == 2 ) {
            //Transportation Info
            cell = [CitySpadeCell TabelCellWithInfoTitle:Transportation_Info];

        } else if ( indexPath.section == 3 ) {
            //Broker Info
            cell = [CitySpadeCell TabelCellWithInfoTitle:Broker_Info];

        } else if ( indexPath.section == 4 ) {
            //Nearby
            cell = [CitySpadeCell TabelCellWithInfoTitle:Nearby];
            [cell setValue:_preViewInfo[1] forKey:@"locationDictionary"];
        }
    }
    if ( indexPath.section != 0 ) {
        [cell ConfigureCellWithItem:_baseList];
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
    CGFloat transportationCellHeight = 398.0f;
    if ( _baseList.transportationCellHeight ) {
        transportationCellHeight = _baseList.transportationCellHeight;
    }
    NSNumber *cellHeight =  @[@(featureImageCellHeight), @(basicFactsCellHeight), @(transportationCellHeight), @(brokerInfoCellHeight), @(nearbyCellHeight)][indexPath.section];
    return [cellHeight floatValue];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ( section == 0 ) {
        return 0;
    } else {
        return headerHegiht;

    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ( section == 0 ) {
        //no header view for section zero
        return nil;
    }
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
    webViewController.originalIconURLString = _baseList.originalUrl;
    [self.navigationController pushViewController:webViewController animated:YES];
}

- (IBAction)pressFavorBtn:(id)sender {
    self.favorBtn.selected = !self.favorBtn.selected;
}

- (IBAction)pressForwardBtn:(id)sender {
    NSString *str = @"Test";
    NSArray *objectsToShare = @[str];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    
    NSArray *excludedActivities = @[UIActivityTypePostToTwitter,
                                    UIActivityTypePostToWeibo,
                                    UIActivityTypePrint, UIActivityTypeCopyToPasteboard,
                                    UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll,
                                    UIActivityTypeAddToReadingList, UIActivityTypePostToFlickr,
                                    UIActivityTypePostToVimeo, UIActivityTypePostToTencentWeibo];
    activityViewController.excludedActivityTypes = excludedActivities;
    
    [self presentViewController:activityViewController animated:YES completion:nil];
}

- (void)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
