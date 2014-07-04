//
//  CityPopoverView.m
//  CitySpade
//
//  Created by Alaysh on 7/4/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import "CityPopoverView.h"

#define kCityCellHeight 48.0f
#define kSelectedCellFont [UIFont fontWithName:@"Avenir-Heavy" size:15.0f];
#define kSelectedCellTextColor [UIColor colorWithRed:91/255.0 green:91/255.0 blue:91/255.0 alpha:1.0]
#define kDeselectedCellFont [UIFont fontWithName:@"Avenir-Roman" size:15.0f];
#define kDeselectedCellTextColor [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0]

@implementation CityPopoverView

- (id)initWithFrame:(CGRect)frame withCitys:(NSArray*)cityArray withBlock:(CitySelectedBlock)aCitySelectedBlock
{
    self = [super initWithFrame:frame];
    if (self) {
        self.cityArray = cityArray;
        self.citySelectedBlock = aCitySelectedBlock;
        
        UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cityBgView"]];
        [self addSubview:backgroundView];
        
        _touchView = [[UIButton alloc] initWithFrame: [UIScreen mainScreen].bounds];
        [_touchView addTarget:self action:@selector(pushOutCityTableView) forControlEvents:UIControlEventTouchUpInside];
       
        _cityTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, frame.size.width, frame.size.height-17)];
        _cityTableView.dataSource = self;
        _cityTableView.delegate = self;
        _cityTableView.backgroundColor = [UIColor clearColor];
        _cityTableView.separatorInset = UIEdgeInsetsZero;
        [_cityTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionBottom];
        [self addSubview:_cityTableView];
    }
    return self;
}

#pragma mark - TableView Datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cityCellIdentifier = @"CityCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cityCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cityCellIdentifier];
        if (indexPath.row == 0) {
            cell.textLabel.font = kSelectedCellFont;
            cell.textLabel.textColor = kSelectedCellTextColor;
        }
        else{
            cell.textLabel.font = kDeselectedCellFont;
            cell.textLabel.textColor = kDeselectedCellTextColor;
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = [self.cityArray objectAtIndex:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kCityCellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cityArray.count;
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.font = kSelectedCellFont;
    cell.textLabel.textColor = kSelectedCellTextColor;
    self.citySelectedBlock(cell.textLabel.text);
    [self pushOutCityTableView];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.font = kDeselectedCellFont;
    cell.textLabel.textColor = kDeselectedCellTextColor;
}

#pragma mark - PushTableView Method

- (void)pushInCityTableView
{
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = 0.3;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionFade;
    [self setAlpha:1.0f];
    [self.layer addAnimation:animation forKey:@"pushIn"];
    [[[UIApplication sharedApplication] keyWindow] addSubview:_touchView];
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
}

- (void)pushOutCityTableView
{
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = 0.3;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionFade;
    [self setAlpha:0.0f];
    [self.layer addAnimation:animation forKey:@"pushOut"];
    [_touchView removeFromSuperview];
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.1];
}

@end
