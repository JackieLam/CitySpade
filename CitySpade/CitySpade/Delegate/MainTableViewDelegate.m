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
//    CTDetailViewController *detailViewController = [[CTDetailViewController alloc] init];
//    NSDictionary *basicInfo = @{@"title": cell.titleLabel.text, @"price": cell.priceLabel.text, @"bargain": cell.bargainLabel.text, @"transport": cell.transportLabel.text, @"bed": cell.bedLabel.text, @"bath": cell.bathLabel.text};
//    detailViewController.basicInfo = basicInfo;
    CitySpadeDemoViewController *detailViewController = [[CitySpadeDemoViewController alloc] initWithNibName:@"CitySpadeDemoViewController" bundle:nil];
    NSLog(@"id -- %d", (int)cell.identiferNumber);
    detailViewController.VCtitle = cell.titleLabel.text;
    detailViewController.listAPI = [NSString stringWithFormat:@"http://cityspade.com/api/v1/listings/%d.json", (int)cell.identiferNumber];
    detailViewController.featureImage = cell.thumbImageView.image;
    NSDictionary *basicFactDict = @{@"bargain" : @(8.5),
                                    @"transportation" : @(7.5),
                                    @"totalPrice" : @(375000),
                                    @"numberOfBed" : @(1),
                                    @"numberOfBath" : @(1)};
    detailViewController.basicFactsDictionary = basicFactDict;
    [[NSNotificationCenter defaultCenter] postNotificationName:kShouldPushDetailViewController object:detailViewController userInfo:nil];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
