//
//  CTListView.m
//  CitySpade
//
//  Created by Cho-Yeung Lam on 23/1/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import "CTListView.h"
#import "CTListCell.h"

@interface CTListView()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong) NSArray *places;

@end

@implementation CTListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.separatorColor = [UIColor redColor];
        self.dataSource = self;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews
{
    //The bottom background
    CGRect screenFrame = [UIScreen mainScreen].bounds;
    CGFloat bottomHeight = 44;
    CGFloat bottomInset = 0;
    CGRect bottomFrame = CGRectMake(bottomInset, screenFrame.size.height - bottomHeight, screenFrame.size.width, bottomHeight);
    self.bottomView = [[UIView alloc] initWithFrame:bottomFrame];
    self.bottomView.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.7];
    [self addSubview:self.bottomView];
    
    CGFloat topInset = 5.0f;
    CGFloat buttonSize = 30.0f;
    CGRect mapButtonFrame;
    mapButtonFrame = CGRectMake(75.0f, topInset, buttonSize, buttonSize);
    self.mapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.mapButton.frame = mapButtonFrame;
    self.mapButton.backgroundColor = [UIColor whiteColor];
    [self.mapButton setImage:[UIImage imageNamed:@"Delete"] forState:UIControlStateNormal];
    [self.mapButton setImage:[UIImage imageNamed:@"Checked"] forState:UIControlStateHighlighted];
    [self.bottomView addSubview:self.mapButton];
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
//    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ListCell";
    CTListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[CTListCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }

    NSDictionary *place = self.places[indexPath.row];
    cell.titleLabel.text = place[@"title"];

//load the picture
    NSMutableString *urlString = [NSMutableString stringWithString:place[@"images"][0][@"s3_url"]];
    [urlString appendString:place[@"images"][0][@"sizes"][1]];
    NSLog(@"PICTURE URL STRING : %@", urlString);
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        UIImage *image = [UIImage imageWithData:data];
        [cell.thumbImageView setImage:image];

    }] resume];
    
    return cell;
}

@end
