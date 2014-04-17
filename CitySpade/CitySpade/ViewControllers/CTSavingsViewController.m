//
//  CTSavingsViewController.m
//  CitySpade
//
//  Created by Cho-Yeung Lam on 14/3/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import "CTSavingsViewController.h"
#import "UISegmentedControl+Project.h"

@interface CTSavingsViewController ()

@property (nonatomic, strong) UISegmentedControl *savingSegmentControl;

@end

@implementation CTSavingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"TEST";
	[self setupView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupView
{
    self.savingSegmentControl = [UISegmentedControl createSavingSegmentWithItems:@[@"Addresses", @"Homes"]];
    self.savingSegmentControl.frame = CGRectMake(0, 0, self.view.frame.size.width, 30);
    [self.view addSubview:self.savingSegmentControl];
}

@end
