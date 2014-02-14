//
//  CTDetailViewController.m
//  CitySpade
//
//  Created by Cho-Yeung Lam on 23/1/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import "CTDetailViewController.h"
#import "CTDetailView.h"
#import "UIBarButtonItem+ProjectButton.h"

@implementation CTDetailViewController

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.basicInfo = [NSDictionary dictionary];
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [self setNeedsStatusBarAppearanceUpdate];
    self.navigationItem.leftBarButtonItems = [UIBarButtonItem createEdgeButtonWithImage:[UIImage imageNamed:@"navbar_backbtn"] WithTarget:self action:@selector(backBtnClicked)];
    CGRect screenFrame = [UIScreen mainScreen].bounds;
    screenFrame = CGRectOffset(screenFrame, 0, -self.navigationController.navigationBar.frame.size.height);
    self.ctdetailView = [[CTDetailView alloc] initWithFrame:screenFrame];
    [self.ctdetailView setInfosWithJSON:self.basicInfo];
    [self.view addSubview:self.ctdetailView];
}

- (void)setupNavTitle
{
    UIColor *red = [UIColor colorWithRed:73.0f/255.0f green:73.0f/255.0f blue:73.0f/255.0f alpha:1.0];
    UIFont *font = [UIFont fontWithName:@"Avenir-Black" size:16.0f];
    NSMutableDictionary *navBarTextAttributes = [NSMutableDictionary dictionaryWithCapacity:1];
    [navBarTextAttributes setObject:font forKey:NSFontAttributeName];
    [navBarTextAttributes setObject:red forKey:NSForegroundColorAttributeName ];
    
    self.navigationController.navigationBar.titleTextAttributes = navBarTextAttributes;
    self.title = self.basicInfo[@"title"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupNavTitle];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)backBtnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
