//
//  SortTableView.m
//  CitySpade
//
//  Created by Cho-Yeung Lam on 18/4/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import "SortTableView.h"

@interface SortTableView()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *elementArray;

@end

@implementation SortTableView

- (id)initWithFrame:(CGRect)frame delegate:(id)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.elementArray = @[@"Price: High to low", @"Price: Low to high", @"Bargain: High to low", @"Bargain: Low to high", @"Transportation: High to low", @"Transportation: Low to high"];
        self.backgroundColor = [UIColor colorWithWhite:1.0f alpha:1.0f];
        self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.separatorInset = UIEdgeInsetsZero;
        self.separatorColor = [UIColor grayColor];
        self.delegate = self;
        self.dataSource = self;
        self.sortDelegate = delegate;
    }
    return self;
}

#pragma mark -
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.textLabel.font = [UIFont fontWithName:@"Avenir-Roman" size:12.5f];
    cell.textLabel.textColor = [UIColor colorWithRed:96.0f/255.0 green:95.0f/255.0 blue:95.0f/255.0 alpha:1.0f];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.text = self.elementArray[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = [UIColor colorWithRed:40.0f/255.0 green:176.0/255.0 blue:170.0/255.0 alpha:1.0f];
    [self.sortDelegate sortTableViewDidSelectOption:indexPath.row];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = [UIColor colorWithRed:96.0f/255.0 green:95.0f/255.0 blue:95.0f/255.0 alpha:1.0f];
}


@end
