//
//  MainTableViewDelegate.m
//  CitySpade
//
//  Created by Cho-Yeung Lam on 17/3/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import "MainTableViewDelegate.h"
#import "CTListCell.h"
#import "CTDetailViewController.h"
#import "Constants.h"
#import "CitySpadeDemoViewController.h"
#import "NSString+RegEx.h"
#import "AsynImageView.h"

@implementation MainTableViewDelegate

#pragma mark - UITableViewDelegate Methods

+ (MainTableViewDelegate *)sharedInstance
{
    static MainTableViewDelegate *sharedDelegate = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedDelegate = [[self alloc] init];
    });
    return sharedDelegate;
}


- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    CTListCell *cell = (CTListCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.rightView.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1.0f];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CTListCell *cell = (CTListCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.rightView.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1.0f];
    CitySpadeDemoViewController *detailViewController = [[CitySpadeDemoViewController alloc] init];
    detailViewController.VCtitle = cell.titleLabel.text;
    detailViewController.listID = [NSString stringWithFormat:@"%d", (int)cell.identiferNumber];
    detailViewController.featureImageUrl = cell.thumbImageView.imageURL;
    NSNumber *bargain = [NSNumber numberWithDouble:[[cell.bargainLabel.text firstNumberInString] doubleValue]];
    NSNumber *transportation = [NSNumber numberWithDouble:[[cell.transportLabel.text firstNumberInString] doubleValue]];
    NSNumber *price = [NSNumber numberWithInt:[[cell.priceLabel.text firstNumberInString] intValue]];
    NSNumber *bed = [NSNumber numberWithInt:[[cell.bedLabel.text firstNumberInString] intValue]];
    NSNumber *bath = [NSNumber numberWithInt:[[cell.bathLabel.text firstNumberInString] intValue]];
    NSArray *basicFactDict = @[@{@"bargain" : bargain,
                                @"transportation" : transportation,
                                @"totalPrice" : price,
                                @"numberOfBed" : bed,
                                @"numberOfBath" : bath},
                               @{@"lng": [NSNumber numberWithDouble:cell.coordinate.longitude], @"lat": [NSNumber numberWithDouble:cell.coordinate.latitude]}];
    detailViewController.preViewInfo = basicFactDict;
    detailViewController.isSaved = cell.isSaved;
    detailViewController.indexPath = indexPath;
    [[NSNotificationCenter defaultCenter] postNotificationName:kShouldPushDetailViewController object:detailViewController userInfo:nil];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
