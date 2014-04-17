//
//  TransportationHottestSpotsCell.m
//  CitySpadeDemo
//
//  Created by izhuxin on 14-3-20.
//  Copyright (c) 2014年 Jeason. All rights reserved.
//

#import "TransportationListCell.h"
#import "CitySpadeListsModel.h"
#import "Constants.h"

@interface TransportationListCell ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *transportationListTableView;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) NSDictionary *infoDictionary;
@property (nonatomic, strong) NSNumber *cellScreenHeight;
@property (nonatomic, weak) CitySpadeListsModel *list;

@end

@implementation TransportationListCell


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        int inset = 10;
        CGRect nameLableFrame = CGRectMake(inset * 1.5, inset, 0, 0);
        self.nameLabel = [[UILabel alloc] initWithFrame:nameLableFrame];
        _nameLabel.font = [UIFont fontWithName:@"Avenir-Heavy" size:13];
        _nameLabel.text = @"placeholder";
        _nameLabel.textColor = [UIColor colorWithRed:51 / 255.0
                                               green:51 / 255.0
                                                blue:51 / 255.0
                                               alpha:1.0];
        [_nameLabel sizeToFit];
        _nameLabel.hidden = YES;
        [self addSubview:_nameLabel];
        
        CGRect placeHolderTableViewFrame = CGRectMake(0, 0, 0, 0);
        self.transportationListTableView = [[UITableView alloc] initWithFrame:placeHolderTableViewFrame style:UITableViewStylePlain];
        _transportationListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _transportationListTableView.scrollEnabled = NO;
        _transportationListTableView.dataSource = self;
        _transportationListTableView.delegate = self;
        [self addSubview:_transportationListTableView];
    }
    
    return self;
}


- (void)ConfigureCellWithItem:(CitySpadeListsModel *)list {
    if ( list.infoDictionary ) {
        self.list = list;
        self.infoDictionary = list.infoDictionary;
        if ( [_nameString isEqualToString:@"Colleages:"] ) {
            self.cellScreenHeight = _infoDictionary[@"colleagesCellHeight"];
        } else if( [_nameString isEqualToString:@"Hottest spots:"] ) {
            self.cellScreenHeight = _infoDictionary[@"hottestSpotCellHeight"];
        }
        _nameLabel.text = _nameString;
        [_nameLabel sizeToFit];
        _nameLabel.hidden = NO;
        int inset = 10;
        CGFloat tableViewFrameOriginY = _nameLabel.frame.origin.y + _nameLabel.frame.size.height;
        CGRect TableViewFrame = CGRectMake(inset, tableViewFrameOriginY,self.frame.size.width, [_cellScreenHeight floatValue] - tableViewFrameOriginY);
        _transportationListTableView.frame = TableViewFrame;
        
        [_transportationListTableView reloadData];

    }
}

#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_transporationsArray count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Transportation list";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if ( !cell ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    NSDictionary *transportationItem = _transporationsArray[indexPath.row];
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 0, 0)];
    textLabel.font = [UIFont fontWithName:@"Avenir-Roman" size:12];
    textLabel.text = [NSString stringWithFormat:@"%@- %@",transportationItem[@"name"], transportationItem[@"time"]];
    [textLabel setTextColor:[UIColor colorWithRed:102 / 255.0
                                            green:102 / 255.0
                                             blue:102 / 255.0
                                            alpha:1.0]];
    [textLabel sizeToFit];
    [cell addSubview:textLabel];
    
    NSString *iconURLString = transportationItem[@"transt_type_icon"];
    
    NSURL *iconPath = _infoDictionary[iconURLString];
    CGRect iconFrame = CGRectMake(cell.frame.size.width - 20 - transportIconSize - 2*inset, 5, transportIconSize, transportIconSize);

    if ( !iconPath ) {
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicator.frame = iconFrame;
        [indicator startAnimating];
        [cell addSubview:indicator];
        [self.list fetchImageForURL:iconURLString WithCompletionHandler:^(NSDictionary *resultDictionary) {
            [indicator stopAnimating];
            [indicator removeFromSuperview];
            [_transportationListTableView reloadData];
        }];
    } else {
        UIImage *iconImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:iconPath]];
        UIImageView *icon = [[UIImageView alloc] initWithImage:iconImage];
        [icon setFrame:iconFrame];
        [cell addSubview:icon];
    }

    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

#pragma mark -UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [_cellScreenHeight floatValue] / ([_transporationsArray count] + 1.5);
}

@end
