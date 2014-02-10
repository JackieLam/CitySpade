//
//  CTListCell.m
//  CitySpade
//
//  Created by Cho-Yeung Lam on 23/1/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import "CTListCell.h"

#define cellHeight 120.0f
#define cellWidth 320.0f
#define imageSize cellHeight
#define infoViewWidth cellWidth-cellHeight
#define infoViewHeight 96.0f
#define bedViewWidth 100.0f
#define bedViewHeight 25.0f
#define bathViewWidth bedViewWidth
#define bathViewHeight bedViewHeight
#define cellBackgroundColor [UIColor colorWithRed:234.0/255.0 green:234.0/255.0 blue:234.0/255.0 alpha:1.0]
#define lineColor [UIColor colorWithRed:207.0/255.0 green:207.0/255.0 blue:207.0/255.0 alpha:1.0f]

@implementation CTListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = cellBackgroundColor;
        [self initCell];
    }
    return self;
}

- (void)initCell
{
    self.thumbImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageSize, imageSize)];
    self.thumbImageView.backgroundColor = [UIColor redColor];
    [self addSubview:self.thumbImageView];
    
    //Info view and the lines
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(imageSize, 0, infoViewWidth, cellHeight)];
    rightView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.9];
    UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(0, infoViewHeight, infoViewWidth, 1.0f)];
    horizontalLine.backgroundColor = lineColor;
    [rightView addSubview:horizontalLine];
    UIView *verticalLine = [[UIView alloc] initWithFrame:CGRectMake(bedViewWidth, infoViewHeight, 1.0f, bedViewHeight)];
    verticalLine.backgroundColor = lineColor;
    [rightView addSubview:verticalLine];
    
    //Labels
    //titleLabel
    CGFloat labelLeftInset = 10;
    CGFloat labelWidth = infoViewWidth - 2 * labelLeftInset;
    
    UIColor *labelGrayColor = [UIColor colorWithRed:77.0/255.0 green:77.0/255.0 blue:76.0/255.0 alpha:1.0f];
    UIColor *labelGreenColor = [UIColor colorWithRed:55.0/255.0 green:182.0/255.0 blue:175.0/255.0 alpha:1.0f];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelLeftInset, labelLeftInset, labelWidth, 20)];
    self.titleLabel.font = [UIFont fontWithName:@"Avenir-Black" size:15.0f];
    self.titleLabel.textColor = labelGrayColor;
    self.titleLabel.text = @"24 5th Ave #210";
    [rightView addSubview:self.titleLabel];
    //priceLabel
    self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelLeftInset, 32, labelWidth, 13)];
    self.priceLabel.font = [UIFont fontWithName:@"Avenir-Black" size:11.0f];
    self.priceLabel.textColor = labelGreenColor;
    self.priceLabel.text = @"$375,000";
    [rightView addSubview:self.priceLabel];
//bargainLabel
    self.bargainLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelLeftInset, 60, labelWidth, 12)];
    self.bargainLabel.font = [UIFont fontWithName:@"Avenir-Roman" size:9.0f];
    self.bargainLabel.textColor = labelGrayColor;
    self.bargainLabel.text = @"Bargain(price): 8.5/10";
    [rightView addSubview:self.bargainLabel];
//transportLabel
    self.transportLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelLeftInset, 76, labelWidth, 12)];
    self.transportLabel.font = [UIFont fontWithName:@"Avenir-Roman" size:9.0f];
    self.transportLabel.textColor = labelGrayColor;
    self.transportLabel.text = @"Transportation:7.5/10";
    [rightView addSubview:self.transportLabel];
    //TODO: use coretext to underline the text
//bedLabel
    self.bedLabel = [[UILabel alloc] initWithFrame:CGRectMake(34, 101, 35, 16)];
    self.bedLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:12.5f];
    self.bedLabel.textColor = labelGrayColor;
    self.bedLabel.text = @"1Bed";
    [rightView addSubview:self.bedLabel];
//bathLabel
    self.bathLabel = [[UILabel alloc] initWithFrame:CGRectMake(133, 101, 35, 16)];
    self.bathLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:12.5f];
    self.bathLabel.textColor = labelGrayColor;
    self.bathLabel.text = @"1Bath";
    [rightView addSubview:self.bathLabel];
    
    [self addSubview:rightView];
}


@end
