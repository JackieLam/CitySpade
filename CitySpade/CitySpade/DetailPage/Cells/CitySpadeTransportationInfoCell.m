//
//  CitySpadeTransportation_InfoCell.m
//  CitySpadeDemo
//
//  Created by izhuxin on 14-3-19.
//  Copyright (c) 2014年 Jeason. All rights reserved.
//

#import "CitySpadeTransportationInfoCell.h"
#import "BaseClass.h"
#import "constant.h"
@interface CitySpadeTransportationInfoCell ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *transportationsTable;
@property (nonatomic, weak) BaseClass *list;
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
        _transportationsTable.separatorColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0];
        _transportationsTable.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
        [self addSubview:_transportationsTable];
    }
    return self;
}

- (void)ConfigureCellWithItem:(BaseClass *)list {
    self.list = list;
    CGRect configureFrame = CGRectMake(_transportationsTable.frame.origin.x, _transportationsTable.frame.origin.y, _transportationsTable.frame.size.width, list.transportationCellHeight);
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
            cell = [CitySpadeCell TabelCellWithInfoTitle:Bus_lines];
        } else if ( indexPath.row == 2 ) {
            //hottest spots
            cell = [CitySpadeCell TabelCellWithInfoTitle:Hottest_Spots];
            [cell setValue:@"Hottest spots:" forKey:@"nameString"];
            [cell setValue:self.list.hottestSpots  forKey:@"transporationsArray"];
        } else if ( indexPath.row == 3 ) {
            //colleages
            cell = [CitySpadeCell TabelCellWithInfoTitle:Colleages];
            [cell setValue:@"Colleges:" forKey:@"nameString"];
            [cell setValue:self.list.colleges forKey:@"transporationsArray"];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell ConfigureCellWithItem:self.list];
    
    return cell;
}

#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.list ) {
        return 44;
    } else {
        NSNumber *height =  @[@(self.list.subwayCellHeight),
                              @(self.list.buslineCellHeight),
                              @(self.list.hottestSpotCellHeight),
                              @(self.list.colleagesCellHeight)
                              ][indexPath.row];
        return [height floatValue];
    }
}

- (NSString *)headerNameAtIndex: (NSInteger)index {
    return @[@"Subway", @"Buslines", @"Hottest Spots", @"Colleges"][index];
}

@end
