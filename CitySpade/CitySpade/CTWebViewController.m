//
//  CTWebViewController.m
//  CitySpade
//
//  Created by Cho-Yeung Lam on 30/4/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import "CTWebViewController.h"
#import <MFSideMenu.h>
#import <SVProgressHUD.h>

@interface CTWebViewController ()<UIWebViewDelegate>

@end

@implementation CTWebViewController

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
    [self setupMenuBarButtonItems];
    CGRect screenFrame = [UIScreen mainScreen].bounds;
    CGFloat navHeight = self.navigationController.navigationBar.bounds.size.height;
    screenFrame.size.height -= navHeight;
    
    self.webView = [[UIWebView alloc] initWithFrame:screenFrame];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    NSURL *url = [NSURL URLWithString:self.urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0f];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self.webView loadRequest:request]; 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIBarButtonItem Callbacks
- (void)setupMenuBarButtonItems {
    if(self.menuContainerViewController.menuState == MFSideMenuStateClosed &&
       ![[self.navigationController.viewControllers objectAtIndex:0] isEqual:self]) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back-arrow"] style:UIBarButtonItemStyleBordered target:self action:@selector(backButtonPressed:)];
    } else {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                                 initWithImage:[UIImage imageNamed:@"User-Profile"] style:UIBarButtonItemStyleBordered
                                                 target:self
                                                 action:@selector(leftSideMenuButtonPressed:)];
    }
}

- (void)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)leftSideMenuButtonPressed:(id)sender {
    
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
        [self setupMenuBarButtonItems];
    }];
    UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
    [navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [SVProgressHUD showImage:[UIImage imageNamed:@"erroricon"] status:@"No internet connection"];
}

@end
