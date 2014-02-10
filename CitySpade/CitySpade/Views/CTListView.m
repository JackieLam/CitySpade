//
//  CTListView.m
//  CitySpade
//
//  Created by Cho-Yeung Lam on 23/1/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import "CTListView.h"
#import "CTListCell.h"

#define heightForLabel 30.0f
#define heightForRow 127.0f
#define tableViewBackgroundColor [UIColor colorWithRed:234.0/255.0 green:234.0/255.0 blue:234.0/255.0 alpha:1.0]

@interface CTListView()<UITableViewDataSource, UISearchBarDelegate>

@property (nonatomic, strong) NSArray *places;
@property (nonatomic, strong) UILabel *totalCountLabel;

@end

@implementation CTListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.totalCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, heightForLabel)];
        self.totalCountLabel.backgroundColor = [UIColor colorWithRed:212.0/255.0 green:239.0/255.0 blue:237.0/255.0 alpha:1.0f];
        self.totalCountLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0f];
        self.totalCountLabel.textColor = [UIColor colorWithRed:40.0/255.0 green:176.0/255.0 blue:170.0/255.0 alpha:1.0f];
        self.totalCountLabel.textAlignment = NSTextAlignmentCenter;
        self.totalCountLabel.text = @"158 results total";
//        [self addSubview:self.totalCountLabel];
        self.tableHeaderView = self.totalCountLabel;
        
        self.backgroundColor = tableViewBackgroundColor;
        self.rowHeight = heightForRow;
        self.dataSource = self;
    }
    return self;
}

- (void)loadPlacesToList:(NSArray *)places
{
    self.places = places;
    [self reloadData];
}

#pragma mark - UITableView's Delegate and DataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.places count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ListCell";
    CTListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[CTListCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.frame = CGRectMake(0, 0, self.frame.size.width, heightForRow);
    }

    cell.house = self.places[indexPath.row];
    cell.titleLabel.text = cell.house[@"title"];

    NSMutableString *urlString = [NSMutableString stringWithString:cell.house[@"images"][0][@"s3_url"]];
    [urlString appendString:cell.house[@"images"][0][@"sizes"][3]];
    NSLog(@"PICTURE URL STRING : %@", urlString);
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        UIImage *image = [UIImage imageWithData:data];
        [cell.thumbImageView setImage:image];

    }] resume];
    
    return cell;
}

@end
