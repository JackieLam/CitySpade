//
//  CTDetailViewController.m
//  CitySpade
//
//  Created by Cho-Yeung Lam on 23/1/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import "CTDetailViewController.h"
#import "CTDetailView.h"

@implementation CTDetailViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
        CGRect screenFrame = [UIScreen mainScreen].bounds;
        screenFrame = CGRectOffset(screenFrame, 0, -self.navigationController.navigationBar.frame.size.height);
        self.ctdetailView = [[CTDetailView alloc] initWithFrame:screenFrame];
        [self.ctdetailView setHouseImageViewImage:self.houseImage];
        [self.ctdetailView setHouseDict:self.house];
    }
    return self;
}

- (void)viewDidLoad
{
    [self.view addSubview:self.ctdetailView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


@end
