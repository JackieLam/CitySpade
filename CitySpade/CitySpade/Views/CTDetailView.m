//
//  CTDetailView.m
//  CitySpade
//
//  Created by Cho-Yeung Lam on 23/1/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import "CTDetailView.h"
#import <QuartzCore/QuartzCore.h>

//Color
#define greenColor [UIColor colorWithRed:40.0/255.0 green:176.0/255.0 blue:170.0/255.0 alpha:1.0f]

//Title
#define titleFont [UIFont fontWithName:@"AvenirNext-Bold" size:15.0f]
#define titleTextColor [UIColor colorWithRed:41.0/255.0 green:41.0/255.0 blue:41.0/255.0 alpha:1.0f]
#define titleInset 10.0f

//Content
#define contentTextColor [UIColor colorWithRed:96.0/255.0 green:96.0/255.0 blue:95.0/255.0 alpha:1.0f]
#define contentFont [UIFont fontWithName:@"Avenir-Roman" size:12.0f]
#define contentFontHeavy [UIFont fontWithName:@"Avenir-Heavy" size:12.0f]

//Image
#define imageHeight 340.0f*0.5

//Basic Facts
#define basicFactTitleFromTop 366.0f*0.5
#define transportationTitleFromTop 558.0f*0.5
#define whiteBackgroundOrginY basicFactTitleFromTop + 42.0f*0.5
#define whiteBackgroundWidth 600.0f*0.5
#define whiteBackgroundHeight 122.0f*0.5


@interface CTDetailView()

@end

@implementation CTDetailView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0f];
        [self setupInterface];
    }
    return self;
}

- (void)setupInterface
{
    self.houseImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, imageHeight)];
    self.houseImageView.image = [UIImage imageNamed:@"imagePlaceholder"];
    self.houseImageView.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:self.houseImageView];
    
    [self setupBasicFactsPart];
}

- (void)setupBasicFactsPart
{
//Basic Facts
    UILabel *basicFact = [[UILabel alloc] initWithFrame:CGRectMake(titleInset, basicFactTitleFromTop, 160.0*0.5, 16.0f)];
    basicFact.font = titleFont;
    basicFact.textColor = titleTextColor;
    basicFact.text = @"Basic Facts";
    [self addSubview:basicFact];
    
    UIImageView *whiteBackground = [[UIImageView alloc] initWithFrame:CGRectMake(titleInset, whiteBackgroundOrginY, whiteBackgroundWidth, whiteBackgroundHeight)];
    whiteBackground.backgroundColor = [UIColor clearColor];
    whiteBackground.image = [UIImage imageNamed:@"basic_facts_white_bg"];
    UILabel *bargain = [[UILabel alloc] initWithFrame:CGRectMake(23.0f*0.5, 26.0f*0.5, 160.0f*0.5, 27.0f*0.5)];
    bargain.font = contentFont;
    bargain.textColor = contentTextColor;
    bargain.text = @"Bargain(price):";
    [whiteBackground addSubview:bargain];
    UILabel *transportation = [[UILabel alloc] initWithFrame:CGRectMake(23.0f*0.5, 70.0f*0.5, 190.0f*0.5, 27.0f*0.5)];
    transportation.font = contentFont;
    transportation.textColor = contentTextColor;
    transportation.text = @"Transportation:";
    [whiteBackground addSubview:transportation];
    
    self.bargainLabel = [[UILabel alloc] initWithFrame:CGRectMake(184.0f*0.5, 26.0f*0.5, 88.0f*0.5, 27.0f*0.5)];
    self.bargainLabel.textColor = greenColor;
    self.bargainLabel.font = contentFontHeavy;
    self.bargainLabel.text = @"8.5/10";
    [whiteBackground addSubview:self.bargainLabel];
    self.transportationLabel = [[UILabel alloc] initWithFrame:CGRectMake(190.0f*0.5, 70.0f*0.5, 88.0f*0.5, 27.0f*0.5)];
    self.transportationLabel.textColor = greenColor;
    self.transportationLabel.font = contentFontHeavy;
    self.transportationLabel.text = @"7.5/10";
    [whiteBackground addSubview:self.transportationLabel];
    
    self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(444.0f*0.5, 26.0f*0.5, 138.0f*0.5, 36.0f*0.5)];
    self.priceLabel.font = [UIFont fontWithName:@"Avenir-Black" size:15.0f];
    self.priceLabel.textColor = greenColor;
    self.priceLabel.text = @"$375,000";
    [whiteBackground addSubview:self.priceLabel];
    
    self.bedLabel = [[UILabel alloc] initWithFrame:CGRectMake(420.0f*0.5, 68.0f*0.5, 64.0f*0.5, 30.0f*0.5)];
    self.bedLabel.textColor = contentTextColor;
    self.bedLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:12.5f];
    self.bedLabel.text = @"1Bed";
    [whiteBackground addSubview:self.bedLabel];
    
    UIView *verticalLine = [[UIView alloc] initWithFrame:CGRectMake(496.0f*0.5, 66.0f*0.5, 1.0f, 30.0f*0.5)];
    verticalLine.backgroundColor = [UIColor colorWithRed:207.0/255.0 green:207.0/255.0 blue:207.0/255.0 alpha:1.0f];
    [whiteBackground addSubview:verticalLine];
    
    self.bathLabel = [[UILabel alloc] initWithFrame:CGRectMake(512.0f*0.5, 68.0f*0.5, 80.0f*0.5, 30.0f*0.5)];
    self.bathLabel.textColor = contentTextColor;
    self.bathLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:12.5f];
    self.bathLabel.text = @"1Bath";
    [whiteBackground addSubview:self.bathLabel];
    
    [self addSubview:whiteBackground];
}

- (void)setupTransportationInfoPart
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleInset, transportationTitleFromTop, 287.0f*0.5, 14.0f)];
    titleLabel.font = titleFont;
    titleLabel.textColor = titleTextColor;
    titleLabel.text = @"Transportation Info";
    [self addSubview:titleLabel];
}

- (void)setInfosWithJSON:(NSDictionary *)json
{
    
}

@end
