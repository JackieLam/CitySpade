//
//  CTFilterViewController.m
//  CitySpade
//
//  Created by Cho-Yeung Lam on 22/1/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import "CTFilterViewController.h"
#import "RangeSlider.h"

@interface CTFilterViewController()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation CTFilterViewController

- (void)viewDidLoad
{
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
}

#pragma mark - Required
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    cell.backgroundColor = [UIColor whiteColor];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Ratings";
    }
    else if (indexPath.row == 1) {
        self.priceRangeSlider =  [[RangeSlider alloc] initWithFrame:CGRectMake(20, 0, cell.bounds.size.width-60, cell.bounds.size.height)];
        self.priceRangeSlider.minimumValue = 100;
        self.priceRangeSlider.selectedMinimumValue = 100;
        self.priceRangeSlider.maximumValue = 1000;
        self.priceRangeSlider.selectedMaximumValue = 1000;
        self.priceRangeSlider.minimumRange = 100;
        [self.priceRangeSlider addTarget:self action:@selector(updateRangeLabel:) forControlEvents:UIControlEventValueChanged];
        
        [cell addSubview:self.priceRangeSlider];
    }
    else if (indexPath.row == 2) {
        cell.textLabel.text = @"Bedrooms";
    }
    else if (indexPath.row == 3) {
        cell.textLabel.text = @"Bathrooms";
    }
    
    return cell;
}

#pragma mark - Optional
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat defaultValue = 44.0f;
    if (indexPath.section == 1) {
        return 80.0f;
    }
    return defaultValue;
}

-(void)updateRangeLabel:(RangeSlider *)slider{
    NSLog(@"Slider Range: %f - %f", slider.selectedMinimumValue, slider.selectedMaximumValue);
}


@end
