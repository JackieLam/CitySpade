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
#import "RegExCategories.h"

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
    CitySpadeDemoViewController *detailViewController = [[CitySpadeDemoViewController alloc] initWithNibName:@"CitySpadeDemoViewController" bundle:nil];
    detailViewController.VCtitle = cell.titleLabel.text;
    detailViewController.listID = [NSString stringWithFormat:@"%d", (int)cell.identiferNumber];
    detailViewController.featureImage = cell.thumbImageView.image;
    NSNumber *bargain = [NSNumber numberWithDouble:[[cell.bargainLabel.text firstMatch:RX(@"\\d+([.]\\d+)")] doubleValue]];
    NSNumber *transportation = [NSNumber numberWithDouble:[[cell.transportLabel.text firstMatch:RX(@"\\d+([.]\\d+)")] doubleValue]];
    NSNumber *price = [NSNumber numberWithInt:[[cell.priceLabel.text firstMatch:RX(@"\\d+")] intValue]];
    NSNumber *bed = [NSNumber numberWithInt:[[cell.bedLabel.text firstMatch:RX(@"\\d+")] intValue]];
    NSNumber *bath = [NSNumber numberWithInt:[[cell.bathLabel.text firstMatch:RX(@"\\d+")] intValue]];
    NSDictionary *basicFactDict = @{@"bargain" : bargain,
                                    @"transportation" : transportation,
                                    @"totalPrice" : price,
                                    @"numberOfBed" : bed,
                                    @"numberOfBath" : bath};
    detailViewController.basicFactsDictionary = basicFactDict;
    [[NSNotificationCenter defaultCenter] postNotificationName:kShouldPushDetailViewController object:detailViewController userInfo:nil];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
