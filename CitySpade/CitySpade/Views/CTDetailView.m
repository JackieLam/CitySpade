//
//  CTDetailView.m
//  CitySpade
//
//  Created by Cho-Yeung Lam on 23/1/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import "CTDetailView.h"

@interface CTDetailView()

@property (nonatomic) NSDictionary *house;
@property (nonatomic, strong) UIImageView *houseImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *facebookButton;
@property (nonatomic, strong) UIButton *emailButton;

@end

@implementation CTDetailView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.house = [NSDictionary dictionary];
        [self initializeInterface];
    }
    return self;
}

- (void)initializeInterface
{
    CGRect screenFrame = [UIScreen mainScreen].bounds;
    CGRect imageFrame = CGRectMake(0, 0, screenFrame.size.width, screenFrame.size.width*0.5);
    self.houseImageView = [[UIImageView alloc] initWithFrame:imageFrame];
    self.houseImageView.backgroundColor = [UIColor redColor];
    [self addSubview:self.houseImageView];
    
    CGRect titleLabelFrame = CGRectOffset(imageFrame, 0, -20);
    self.titleLabel = [[UILabel alloc] initWithFrame:titleLabelFrame];
    self.titleLabel.backgroundColor = [UIColor greenColor];
    self.titleLabel.textColor = [UIColor blackColor];
    [self addSubview:self.titleLabel];
}

- (void)setHouseImageViewImage:(UIImage *)image
{
    if (!self.houseImageView)
        [NSException raise:@"View not initialize" format:@"You should initialize the CTDetailView first"];
    self.houseImageView.image = image;
}


- (void)setTitleLabelText:(NSString *)text
{
    if (!self.titleLabel)
        [NSException raise:@"View not initialize" format:@"You should initialize the CTDetailView first"];
    self.titleLabel.text = text;
}

- (void)setHouseDict:(NSDictionary *)house
{
//    if (!self.house)
//        [NSException raise:@"View not initialize" format:@"You should initialize the CTDetailView first"];
    self.house = house;
}

@end
