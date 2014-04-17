//
//  CitySpadeTransportation_InfoCell.m
//  CitySpadeDemo
//
//  Created by izhuxin on 14-3-19.
//  Copyright (c) 2014年 Jeason. All rights reserved.
//

#import "CitySpadeTransportationInfoCell.h"
#import "CitySpadeListsModel.h"
#import "Constants.h"

@interface CitySpadeTransportationInfoCell ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSDictionary *transportationaDic;
@property (strong, nonatomic) UITableView *transportationsTable;
@property (nonatomic, weak) CitySpadeListsModel *list;
@end

@implementation CitySpadeTransportationInfoCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGRect placeholderFrame = CGRectMake(frame.origin.x, frame.origin.y, 300, 460);
        self.transportationsTable = [[UITableView alloc] initWithFrame:placeholderFrame style:UITableViewStylePlain];
        _transportationsTable.scrollEnabled = NO;
        _transportationsTable.dataSource = self;
        _transportationsTable.delegate = self;
        [self addSubview:_transportationsTable];
    }
    return self;
}

- (void)ConfigureCellWithItem:(CitySpadeListsModel *)list {
    self.list = list;
    self.transportationaDic = list.infoDictionary;
    NSNumber *transportationCellHeight = _transportationaDic[@"transportationCellHeight"];

    CGRect configureFrame = CGRectMake(_transportationsTable.frame.origin.x, _transportationsTable.frame.origin.y, _transportationsTable.frame.size.width, [transportationCellHeight floatValue]);
    _transportationsTable.frame = configureFrame;
    
    [_transportationsTable reloadData];
}

- (void) setFrame:(CGRect)frame{
    frame.origin.x += 10;
    frame.size.width -= 20;
    [super setFrame:frame];
}


#pragma mark -UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CitySpadeCell *cell = [tableView dequeueReusableCellWithIdentifier:[self headerNameAtIndex:indexPath.row]];
    if ( !cell ) {
        if ( indexPath.row == 0 ) {
            //subways
            cell = [CitySpadeCell TabelCellWithInfoTitle:Subway_Lines];
            [cell setValue:@"Subway Lines:" forKey:@"nameString"];

        } else if ( indexPath.row == 1 ) {
            //buslines
            cell = [CitySpadeCell TabelCellWithInfoTitle:Buslines];
        } else if ( indexPath.row == 2 ) {
            //hottest spots
            cell = [CitySpadeCell TabelCellWithInfoTitle:Hottest_Spots];
            [cell setValue:@"Hottest spots:" forKey:@"nameString"];
            [cell setValue:_transportationaDic[@"hottest_spots"] forKey:@"transporationsArray"];
        } else if ( indexPath.row == 3 ) {
            //colleages
            cell = [CitySpadeCell TabelCellWithInfoTitle:Colleages];
            [cell setValue:@"Colleages:" forKey:@"nameString"];
            [cell setValue:_transportationaDic[@"colleges"] forKey:@"transporationsArray"];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell ConfigureCellWithItem:self.list];
    
    return cell;
}

#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!_transportationaDic[@"subwayCellHeight"]) {
        return 44;
    } else {
        NSNumber *height =  @[_transportationaDic[@"subwayCellHeight"], _transportationaDic[@"buslineCellHeight"], _transportationaDic[@"hottestSpotCellHeight"], _transportationaDic[@"colleagesCellHeight"]][indexPath.row];
        return [height floatValue];
    }
}

- (NSString *)headerNameAtIndex: (NSInteger)index {
    return @[@"Subway", @"Buslines", @"Hottest Spots", @"Colleages"][index];
}

@end
