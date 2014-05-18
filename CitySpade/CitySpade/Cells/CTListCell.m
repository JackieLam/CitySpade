//
//  CTListCell.m
//  CitySpade
//
//  Created by Cho-Yeung Lam on 23/1/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import "CTListCell.h"
#import "REVClusterPin.h"
#import "AsynImageView.h"
#import "Listing.h"
#import "Images.h"

#define cellHeight 120.0f
#define cellWidth 320.0f
#define imageSize cellHeight
#define infoViewWidth cellWidth-cellHeight
#define infoViewHeight 96.0f
#define bedViewWidth 100.0f
#define bedViewHeight 25.0f
#define bathViewWidth bedViewWidth
#define bathViewHeight bedViewHeight
#define moveoffset 30.0f
#define dotX -20.0f
#define dotY 53.5f
#define dotWidth 12.5f
#define dotHeight 12.5f
#define kSelectedTag 1
#define kEditingTag 2
#define kVerticalLineTag1 3
#define kVerticalLineTag2 4
#define kfavorBtnTag   7
#define cellBackgroundColor [UIColor colorWithRed:234.0/255.0 green:234.0/255.0 blue:234.0/255.0 alpha:1.0]
#define lineColor [UIColor colorWithRed:207.0/255.0 green:207.0/255.0 blue:207.0/255.0 alpha:1.0f]

@implementation CTListCell

- (id)initWithCTListCellStyle:(CTListCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = cellBackgroundColor;
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(-moveoffset, 0, moveoffset, cellHeight)];
        backgroundView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:backgroundView];
        [self initCell];
        if (style == CTListCellStyleSaved) {
            [self setFavorState];
        }
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = cellBackgroundColor;
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(-moveoffset, 0, moveoffset, cellHeight)];
        backgroundView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:backgroundView];
        [self initCell];
    }
    return self;
}

- (void)initCell
{
    self.thumbImageView = [[AsynImageView alloc] initWithFrame:CGRectMake(0, 0, imageSize, imageSize)];
    self.thumbImageView.placeholderImage = [UIImage imageNamed:@"imgplaceholder_square"];
    [self addSubview:self.thumbImageView];
    
    //Info view and the lines
    self.rightView = [[UIView alloc] initWithFrame:CGRectMake(imageSize, 0, infoViewWidth, cellHeight)];
    self.rightView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.9];
    UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(0, infoViewHeight, infoViewWidth, 1.0f)];
    horizontalLine.backgroundColor = lineColor;
    [self.rightView addSubview:horizontalLine];
    UIView *verticalLine1 = [[UIView alloc] initWithFrame:CGRectMake(bedViewWidth, infoViewHeight, 1.0f, bedViewHeight)];
    verticalLine1.backgroundColor = lineColor;
    verticalLine1.tag = kVerticalLineTag1;
    [self.rightView addSubview:verticalLine1];
    UIView *verticalLine2 = [[UIView alloc] initWithFrame:CGRectMake(bedViewWidth, infoViewHeight, 1.0f, bedViewHeight)];
    verticalLine2.backgroundColor = lineColor;
    verticalLine2.tag = kVerticalLineTag2;
    [self.rightView addSubview:verticalLine2];
    
    self.favorBtn = [[UIButton alloc] initWithFrame:CGRectMake(155.5f, 95.0f, 45.0f, 25.0f)];
    [self.favorBtn setImageEdgeInsets:UIEdgeInsetsMake(12.0/2, 30.0/2, 12.0/2, 30.0/2)];
    [self.favorBtn setImage:[UIImage imageNamed:@"dislike"] forState:UIControlStateNormal];
    [self.favorBtn setImage:[UIImage imageNamed:@"like"] forState:UIControlStateSelected];
    self.favorBtn.tag = kfavorBtnTag;
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
    [self.rightView addSubview:self.titleLabel];
    //priceLabel
    self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelLeftInset, 32, labelWidth, 13)];
    self.priceLabel.font = [UIFont fontWithName:@"Avenir-Black" size:11.0f];
    self.priceLabel.textColor = labelGreenColor;
    self.priceLabel.text = @"$375,000";
    [self.rightView addSubview:self.priceLabel];
//bargainLabel
    self.bargainLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelLeftInset, 60, labelWidth, 12)];
    self.bargainLabel.font = [UIFont fontWithName:@"Avenir-Roman" size:9.0f];
    self.bargainLabel.textColor = labelGrayColor;
    self.bargainLabel.text = @"Bargain(price): 8.5/10";
    [self.rightView addSubview:self.bargainLabel];
//transportLabel
    self.transportLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelLeftInset, 76, labelWidth, 12)];
    self.transportLabel.font = [UIFont fontWithName:@"Avenir-Roman" size:9.0f];
    self.transportLabel.textColor = labelGrayColor;
    self.transportLabel.text = @"Transportation:7.5/10";
    [self.rightView addSubview:self.transportLabel];
    //TODO: use coretext to underline the text
//bedLabel
    self.bedLabel = [[UILabel alloc] initWithFrame:CGRectMake(32, 101, 40, 16)];
    self.bedLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:12.5f];
    self.bedLabel.textColor = labelGrayColor;
    self.bedLabel.text = @"1Bed";
    [self.self.rightView addSubview:self.bedLabel];
//bathLabel
    self.bathLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 101, 40, 16)];
    self.bathLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:12.5f];
    self.bathLabel.textColor = labelGrayColor;
    self.bathLabel.text = @"1Bath";
    [self.rightView addSubview:self.bathLabel];
    
    [self addSubview:self.rightView];
}

- (void)configureCellWithClusterPin:(REVClusterPin *)pin
{
    self.titleLabel.text = pin.title;
    self.priceLabel.text = pin.subtitle;
    self.bargainLabel.text = [NSString stringWithFormat:@"Bargain(price):%@", pin.bargain];
    self.transportLabel.text = [NSString stringWithFormat:@"Transportation:%@", pin.transportation];
    int numberOfBed = [pin.beds intValue];
    if (numberOfBed > 1) {
        self.bedLabel.text = [NSString stringWithFormat:@"%dBeds", numberOfBed];
    }
    else{
        self.bedLabel.text = [NSString stringWithFormat:@"%dBed", numberOfBed];
    }
    int numberOfBath = [pin.baths intValue];
    if (numberOfBath > 1) {
        self.bathLabel.text = [NSString stringWithFormat:@"%dBaths", numberOfBath];
    }
    else{
        self.bathLabel.text = [NSString stringWithFormat:@"%dBath", numberOfBath];
    }
    self.identiferNumber = pin.identiferNumber;
    self.thumbImageView.imageURL = pin.thumbImageLink;
    self.favorBtn.selected = self.isSaved;
    self.coordinate = pin.coordinate;
}

- (void)setNormalState
{
    [self.bedLabel setFrame:CGRectMake(22, 101, 40, 16)];
    [self.bathLabel setFrame:CGRectMake(97, 101, 40, 16)];
    UIView *verticalLine1 = [self.rightView viewWithTag:kVerticalLineTag1];
    UIView *verticalLine2 = [self.rightView viewWithTag:kVerticalLineTag2];
    [verticalLine1 setFrame:CGRectMake(80.0f, infoViewHeight, 1.0f, bedViewHeight)];
    [verticalLine2 setFrame:CGRectMake(155.5f, infoViewHeight, 1.0f, bedViewHeight)];
    if (![self.favorBtn superview]) {
        [self.rightView addSubview:self.favorBtn];
    }
}

- (void)setFavorState
{
    [self.bedLabel setFrame:CGRectMake(22, 101, 40, 16)];
    [self.bathLabel setFrame:CGRectMake(97, 101, 40, 16)];
    UIView *verticalLine1 = [self.rightView viewWithTag:kVerticalLineTag1];
    UIView *verticalLine2 = [self.rightView viewWithTag:kVerticalLineTag2];
    [verticalLine1 setFrame:CGRectMake(80.0f, infoViewHeight, 1.0f, bedViewHeight)];
    [verticalLine2 setFrame:CGRectMake(155.5f, infoViewHeight, 1.0f, bedViewHeight)];
    [self.rightView addSubview:self.favorBtn];
}

- (void)changeState
{
    self.favorBtn.selected = !self.favorBtn.selected;
    self.isSaved = !self.isSaved;
    if (self.favorBtn.selected) {
        [self setFavorState];
    }
    else{
        [self setNormalState];
    }
}

- (void)configureCellWithListing:(Listing *)listing
{
    self.titleLabel.text = listing.title;
    self.priceLabel.text = [NSString stringWithFormat:@"$%d", (int)listing.price];
    self.bargainLabel.text = [NSString stringWithFormat:@"Bargain(price):%@", listing.bargain];
    self.transportLabel.text = [NSString stringWithFormat:@"Transportation:%@", listing.transportation];
    int numberOfBed = (int)listing.beds;
    if (numberOfBed > 1) {
        self.bedLabel.text = [NSString stringWithFormat:@"%dBeds", numberOfBed];
    }
    else{
        self.bedLabel.text = [NSString stringWithFormat:@"%dBed", numberOfBed];
    }
    int numberOfBath = (int)listing.baths;
    if (numberOfBath > 1) {
        self.bathLabel.text = [NSString stringWithFormat:@"%dBaths", numberOfBath];
    }
    else{
        self.bathLabel.text = [NSString stringWithFormat:@"%dBath", numberOfBath];
    }
    self.identiferNumber = listing.internalBaseClassIdentifier;
    Images *image = (Images *)[listing.images firstObject];
    self.thumbImageView.imageURL = [NSString stringWithFormat:@"%@%@", image.url, [image.sizes firstObject]];
    self.coordinate = CLLocationCoordinate2DMake(listing.lat, listing.lng);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    int TagValue = 1;
    if(isEditing)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        if (selected) {
            UIImage *dotimage = [UIImage imageNamed:@"dot_selected.png"];
            UIImageView *editDotView = [[UIImageView alloc] initWithImage:dotimage];
            editDotView.tag = TagValue;
            editDotView.frame = CGRectMake(dotX, dotY, dotWidth, dotHeight);
            [self addSubview:editDotView];
        }
        else{
            UIView *editDotView = [self viewWithTag:TagValue];
            if(editDotView)
            {
                [editDotView removeFromSuperview];
            }
        }
        
    }
    else{
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        UIView *editDotView = [self viewWithTag:TagValue];
        if(editDotView)
        {
            [editDotView removeFromSuperview];
        }
        
    }
    [super setSelected:selected animated:animated];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    int TagValue = 2;
    if(editing)
    {
        isEditing = YES;
        
        if(![self viewWithTag:TagValue])
        {
            UIImage *dotimage = [UIImage imageNamed:@"dot_disselect.png"];
            UIImageView *editDotView = [[UIImageView alloc] initWithImage:dotimage];
            editDotView.tag = TagValue;
            editDotView.frame = CGRectMake(-12.0, dotY, dotWidth, dotHeight);
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3];
            CGRect rect = CGRectMake(dotX, dotY , dotWidth, dotHeight);
            editDotView.frame = rect;
            [UIView  commitAnimations];
            [self.contentView addSubview:editDotView];
            
        }
        else
        {
            UIView *editDotView = [self viewWithTag:TagValue];
            CGRect rect = CGRectMake(dotX, dotY , dotWidth, dotHeight);
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3];
            editDotView.frame = rect;
            [UIView commitAnimations];
        }
        
        CGRect rect2 = self.frame;
        rect2.origin.x += 25;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        self.frame = rect2;
        [UIView commitAnimations];
        
    }
    else{
        isEditing = NO;
        CGRect rect = CGRectMake(-25.0, dotY , dotWidth , dotHeight);
        UIView *editDotView = [self viewWithTag:TagValue];
        if(editDotView)
        {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3];
            editDotView.frame = rect;
            [UIView commitAnimations];
        }
        CGRect rect2 = self.frame;
        if (rect2.origin.x == 25) {
            rect2.origin.x -= 25;
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3];
            self.frame = rect2;
            [UIView commitAnimations];
        }
        
    }
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    [self.thumbImageView cancelConnection];
}

@end
