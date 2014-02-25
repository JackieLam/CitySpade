//
//  TestViewController.m
//  CitySpade
//
//  Created by Cho-Yeung Lam on 25/2/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import "TestViewController.h"
#import "CTLoginViewController.h"
#import "Constants.h"

@interface TestViewController ()

@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;

@end

@implementation TestViewController

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
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetUserName:) name:kNotificationLoginSuccess object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButtonPressed:(id)sender
{
    CTLoginViewController *loginVC = [[CTLoginViewController alloc] initWithNibName:@"CTLoginViewController" bundle:nil];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:loginVC];
    navi.navigationBar.opaque = YES;
    navi.navigationBar.translucent = NO;
    [navi.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar_shadow"] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [navi.navigationBar setShadowImage:[UIImage new]];
    [self presentViewController:navi animated:YES completion:nil];
}

- (void)didGetUserName:(NSNotification *)aNotification
{
    self.userNameLabel.text = [aNotification object];
}

@end
