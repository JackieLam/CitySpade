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
#import "AsynImageView.h"
#import "RESTfulEngine.h"
#define kAccessToken @"ACCESS_TOKEN"

static const int toolBarHeight = 50;
static const int navigationBarHeight = 44;
@interface CitySpadeDemoViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UIButton *favorBtn;
@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) UITableView *infotableView;
@property (strong, nonatomic) NSString *brokerTitle;
@property (nonatomic, strong) AsynImageView *featureImageView;
@property (atomic, strong) CitySpadeModelManager *manager;
@property (nonatomic, strong) BaseClass *baseList;

@end

@implementation CitySpadeDemoViewController

- (id)init
{
    self = [super init];
    if (self) {
        _featureImageView = [[AsynImageView alloc] initWithFrame:CGRectZero];
        _featureImageView.placeholderImage = [UIImage imageNamed:@"imgplaceholder_long"];
//        _featureImage = [UIImage imageNamed:@"imgplaceholder_long"];
    }
    return self;
}

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
    
    [self initNavigationBar];
    [self initInfoTableView];
    //network
    //indicator
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.center = CGPointMake(self.view.frame.size.width / 2, 400);
    [indicator startAnimating];
    [self.view addSubview:indicator];
    
    //network handler
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

    [self initToolBar];
}

- (void)initNavigationBar {
    [[UINavigationBar appearance] setTitleTextAttributes:
     @{
        NSForegroundColorAttributeName:[UIColor colorWithRed:122.0/255.0
                                                          green:122.0/255.0
                                                           blue:122.0/255.0
                                                          alpha:1.0],
        NSFontAttributeName: [UIFont fontWithName:@"Avenir-Black" size:15]
        }
    ];
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 36)];
    [backButton setImage:[UIImage imageNamed:@"navbar_backbtn"] forState:UIControlStateNormal];
    [backButton addTarget:self
                   action:@selector(back:)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backNavigationItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    if ( DEVICEVERSION >= 7.0 ) {
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = -10;
        self.navigationItem.leftBarButtonItems = @[negativeSpacer, backNavigationItem];
    } else {
        self.navigationItem.leftBarButtonItem = backNavigationItem;
    }
    self.title = self.VCtitle;

}

- (void)initInfoTableView {
    CGRect infoTableFrame = [[UIScreen mainScreen] bounds];
    infoTableFrame.size.height -= navigationBarHeight;
    infoTableFrame.origin.y -= 35;
    self.infotableView = [[UITableView alloc] initWithFrame:infoTableFrame style:UITableViewStyleGrouped];
    _infotableView.dataSource = self;
    _infotableView.delegate = self;
    _infotableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _infotableView.tableHeaderView.hidden = YES;
    [self.view addSubview:_infotableView];
}

- (void)initToolBar {
    CGRect toolBarFrame = CGRectMake(0,
                                     _infotableView.frame.size.height - 35*2,
                                     self.view.frame.size.width,
                                     toolBarHeight);
    UIView *toolBarView = [[UIView alloc] initWithFrame:toolBarFrame];
    toolBarView.backgroundColor = [UIColor colorWithRed:51/255.0f green:204/255.0f blue:204/255.0f alpha:0.9];
    //procceed to broker
    UIButton *proToBroBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 7, 145, 35)];
    [proToBroBtn setImage:[UIImage imageNamed:@"pro-to-bo"] forState:UIControlStateNormal];
    [proToBroBtn addTarget:self action:@selector(pressProcceedToBroker:) forControlEvents:UIControlEventTouchUpInside];
    [toolBarView addSubview:proToBroBtn];
    
    //favor
    UIButton *favorBtn = [[UIButton alloc] initWithFrame:CGRectMake(228, 16, 20, 22)];
    [favorBtn setImage:[UIImage imageNamed:@"LikeBefore"] forState:UIControlStateNormal];
    [favorBtn setImage:[UIImage imageNamed:@"LikePressed.png"] forState:UIControlStateSelected];
    [favorBtn addTarget:self action:@selector(pressFavorBtn:) forControlEvents:UIControlEventTouchUpInside];
    favorBtn.selected = self.isSaved;
    [toolBarView addSubview:favorBtn];
    
    //share
    UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(270, 1, 50, 50)];
    [shareBtn setImage:[UIImage imageNamed:@"Share-"] forState:UIControlStateNormal];
    [shareBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
    [shareBtn addTarget:self action:@selector(pressForwardBtn:) forControlEvents:UIControlEventTouchUpInside];
    [toolBarView addSubview:shareBtn];
    
    [self.view addSubview:toolBarView];
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
            [_featureImageView setFrame:CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, featureImageCellHeight)];
            /*
            _featureImageView.layer.shadowRadius = 1;
            _featureImageView.layer.shadowOffset = CGSizeMake(0, 1);
            _featureImageView.layer.shadowOpacity = 0.15;*/
            /*
            _featureImageView = [[UIImageView alloc] init];
            CGRect featureImageViewFrame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, featureImageCellHeight);
            [_featureImageView setFrame:featureImageViewFrame];
            [_featureImageView setImage:_featureImage];*/
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
    cell.layer.shadowRadius = 1;
    cell.layer.shadowOffset = CGSizeMake(1, 1*tan(M_PI*60/180));
    
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
    headerLabel.frame = CGRectMake(inset, -5, 0, 0);
    headerLabel.font = [UIFont fontWithName:@"AvenirNext-Bold"
                                       size:sessionHeaderFontSize];
    headerLabel.text = [self headerNameAtIndex:section];
    [headerLabel sizeToFit];
    
    [headerView addSubview:headerLabel];
    return headerView;
}

#pragma mark - Click Button Method

- (void)pressProcceedToBroker:(id)sender {
    CitySpadeBrokerWebViewController *webViewController = [[CitySpadeBrokerWebViewController alloc] init];
    webViewController.originalIconURLString = _baseList.originalUrl;
    [self.navigationController pushViewController:webViewController animated:YES];
}

- (void)pressFavorBtn:(id)sender {
    if ( [sender isKindOfClass:[UIButton class]] ) {
        UIButton *favorBtn = (UIButton *)sender;
        NSUserDefaults *defauts = [NSUserDefaults standardUserDefaults];
        NSString *token = [defauts objectForKey:kAccessToken];
        if (!token) {
            [SVProgressHUD showImage:[UIImage imageNamed:@"User-Profile"] status:@"Please login to save listings"];
            return;
        }
        
        favorBtn.selected = !favorBtn.selected;
        if (favorBtn.selected) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            NSDictionary *listDic1 = [self.preViewInfo objectAtIndex:0];
            NSDictionary *listDic2 = [self.preViewInfo objectAtIndex:1];
            CGFloat bargain = [[listDic1 objectForKey:@"bargain"] floatValue];
            CGFloat transportation = [[listDic1 objectForKey:@"transportation"] floatValue];
            NSArray *images = [NSArray arrayWithObject:[NSDictionary dictionaryWithObject:self.featureImageUrl forKey:@"url"]];
            [dic setObject:images forKey:@"images"];
            [dic setObject:self.listID forKey:@"id"];
            [dic setObject:[listDic1 objectForKey:@"numberOfBed"] forKey:@"beds"];
            [dic setObject:self.VCtitle forKey:@"title"];
            [dic setObject:[listDic1 objectForKey:@"totalPrice"] forKey:@"price"];
            [dic setObject:[listDic1 objectForKey:@"numberOfBath"] forKey:@"baths"];
            [dic setObject:[NSString stringWithFormat:@"%.2f/10", bargain] forKey:@"bargain"];
            [dic setObject:[NSString stringWithFormat:@"%.2f/10", transportation] forKey:@"transportation"];
            [dic setObject:[listDic2 objectForKey:@"lng"] forKey:@"lng"];
            [dic setObject:[listDic2 objectForKey:@"lat"] forKey:@"lat"];
            
            [RESTfulEngine addAListingToSaveListWithId:_listID onSucceeded:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationAddSaveListing object:dic userInfo:nil];
                if (self.indexPath) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTableView" object:self.indexPath];
                }
                NSLog(@"AddToListing Success");
            } onError:^(NSError *engineError) {
                favorBtn.selected = !favorBtn.selected;
                NSLog(@"AddToListing Error");
            }];
        }
        else{
            
            [RESTfulEngine deleteAListingFromSaveListWithId:_listID onSucceeded:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationDeleteSaveListing object:_listID userInfo:nil];
                if (self.indexPath) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTableView" object:self.indexPath];
                }
                NSLog(@"Delete From Listing Success");
            } onError:^(NSError *engineError) {
                favorBtn.selected = !favorBtn.selected;
                NSLog(@"Delete From Listing Error");
            }];
        }
    }
}

- (void)pressForwardBtn:(id)sender {

    NSURL *url = [NSURL URLWithString:_baseList.originalUrl];
    UIActivityViewController *activityViewController;
    if (url == nil) {
        activityViewController  = [[UIActivityViewController alloc] initWithActivityItems:@[self,self.featureImageView.image,@"I found this property via CitySpade iPhone App"] applicationActivities:nil];
    }
    else{
        activityViewController  = [[UIActivityViewController alloc] initWithActivityItems:@[self,self.featureImageView.image,@"I found this property via CitySpade iPhone App",url] applicationActivities:nil];
    }
    
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

#pragma mark - UIActivityItemSource

-(id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType
{
    if ([activityType isEqualToString:UIActivityTypePostToFacebook] ||[activityType isEqualToString:UIActivityTypeMail]) {

        NSDictionary *listDic1 = [self.preViewInfo objectAtIndex:0];
        NSString *bargain = [listDic1 objectForKey:@"bargain"];
        NSString *transportation = [listDic1 objectForKey:@"transportation"];
        NSString *str = [NSString stringWithFormat:@"Check out this properity I found via CitySpade iPhone app\n\nBasic Info:\n%@\n$%@\nCost-Efficiency rating:%@\nTransportation rating:%@\n%@Beds\n%@Baths\n",self.VCtitle,[listDic1 objectForKey:@"totalPrice"],bargain, transportation, [listDic1 objectForKey:@"numberOfBed"],[listDic1 objectForKey:@"numberOfBath"]];
        return str;
    }
    else{
        return @"";
    }
    
}

- (id)activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController
{
    return @"";
}

- (void)setFeatureImageUrl:(NSString *)featureImageUrl
{
    if (_featureImageUrl != featureImageUrl) {
        _featureImageUrl = featureImageUrl;
        _featureImageView.imageURL = featureImageUrl;
    }
}
@end
