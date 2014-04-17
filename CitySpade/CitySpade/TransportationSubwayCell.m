//
//  TransportationSubwayCell.m
//  CitySpadeDemo
//
//  Created by izhuxin on 14-3-20.
//  Copyright (c) 2014年 Jeason. All rights reserved.
//

#import "TransportationSubwayCell.h"
#import "CitySpadeListsModel.h"
#import "Constants.h"
@interface TransportationSubwayCell ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSNumber *cellScreenHeight;
@property (nonatomic, strong) UITableView *subwaysTableView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) NSDictionary *infoDictionary;
@property (nonatomic, strong) NSArray *subwaysArray;
@end

@implementation TransportationSubwayCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CGRect nameLableFrame = CGRectMake(inset * 1.5, inset, 0, 0);
        self.nameLabel = [[UILabel alloc] initWithFrame:nameLableFrame];
        _nameLabel.text = @"Placeholder";
        _nameLabel.font = [UIFont fontWithName:@"Avenir-Heavy" size:13];
        _nameLabel.textColor = [UIColor colorWithRed:51 / 255.0
                                               green:51 / 255.0
                                                blue:51 / 255.0
                                               alpha:1.0];
        _nameLabel.hidden = YES;
        
        [_nameLabel sizeToFit];
        [self addSubview:_nameLabel];
        
        CGRect placeHolderTableViewFrame = CGRectMake(0, 0, 0, 0);
        self.subwaysTableView = [[UITableView alloc] initWithFrame:placeHolderTableViewFrame style:UITableViewStylePlain];
        _subwaysTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _subwaysTableView.scrollEnabled = NO;
        _subwaysTableView.dataSource = self;
        _subwaysTableView.delegate = self;
        [self addSubview:_subwaysTableView];
    }
    return self;
}


- (void)ConfigureCellWithItem:(CitySpadeListsModel *)list {
    if ( list.infoDictionary ) {
        self.list = list;
        _infoDictionary = list.infoDictionary;
        self.subwaysArray = _infoDictionary[@"subwaysArray"];
        if ( [_subwaysArray count] == 0 ) {
            return;
        }
        _nameLabel.text = _nameString;
        [_nameLabel sizeToFit];
        _nameLabel.hidden = NO;
        self.cellScreenHeight = _infoDictionary[@"subwayCellHeight"];
        CGFloat tableViewFrameOriginY = _nameLabel.frame.origin.y + _nameLabel.frame.size.height;
        CGRect TableViewFrame = CGRectMake(inset, tableViewFrameOriginY,self.frame.size.width, [_cellScreenHeight floatValue] - tableViewFrameOriginY);
        _subwaysTableView.frame = TableViewFrame;
        [_subwaysTableView reloadData];

    }
}

#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_subwaysArray count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ( !_subwaysArray ) {
        //return nil cell
        return nil;
    }
    static NSString *cellIdentifier = @"subways";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    //NSMutableSet *downloadQueue = [[NSMutableSet alloc] init];
    if ( !cell ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    NSArray *subways = _subwaysArray[indexPath.row];
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    textLabel.font = [UIFont fontWithName:@"Avenir-Roman" size:11.0];
    textLabel.text = [NSString stringWithFormat:@"-%@",[subways firstObject]];
    [textLabel setTextColor:[UIColor colorWithRed:102 / 255.0
                                            green:102 / 255.0
                                             blue:102 / 255.0
                                            alpha:1.0]];
    [textLabel sizeToFit];
    textLabel.frame = CGRectMake(cell.frame.size.width - 20 - textLabel.frame.size.width - 20, 5, textLabel.frame.size.width, textLabel.frame.size.height);
    [cell addSubview:textLabel];
    
    for ( NSUInteger i = 1; i < [subways count]; i++) {
        CGRect iconFrame = CGRectMake( i * inset * 0.8 + (i-1)*transportIconSize, 3, transportIconSize, transportIconSize);
        
        NSString *iconImageString = subways[i][@"icon_url"];
        NSURL *iconPath = _infoDictionary[iconImageString];
        if ( !iconPath ) {
            UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            indicator.frame = iconFrame;
            [indicator startAnimating];
            [cell addSubview:indicator];
            [self.list fetchImageForURL:iconImageString
                  WithCompletionHandler:^(NSDictionary *resultDictionary) {
                      [indicator stopAnimating];
                      [indicator removeFromSuperview];
                      [_subwaysTableView reloadData];
                  }
             ];
            
        } else {
            UIImage *iconImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:iconPath]];
            UIImageView *icon = [[UIImageView alloc] initWithImage:iconImage];
            [icon setFrame:iconFrame];
            [cell addSubview:icon];
        }
    }

    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

#pragma mark -UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [_cellScreenHeight floatValue] / ([_subwaysArray count] + 1.5);
}

@end
