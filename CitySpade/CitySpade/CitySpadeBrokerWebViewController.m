//
//  CitySpadeBrokerWebViewController.m
//  CitySpadeDemo
//
//  Created by Jeason on 4/11/14.
//  Copyright (c) 2014 Jeason. All rights reserved.
//

#import "CitySpadeBrokerWebViewController.h"
#import "Constants.h"
@interface CitySpadeBrokerWebViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;

@end

@implementation CitySpadeBrokerWebViewController

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
    //autolayout
    NSLayoutConstraint *topConstraint;
    if ( DEVICEVERSION >= 7.0 ) {
        topConstraint = [NSLayoutConstraint constraintWithItem:self.backgroundView
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.view attribute:NSLayoutAttributeTop
                                                    multiplier:1
                                                      constant:0];
    } else {
        topConstraint = [NSLayoutConstraint constraintWithItem:self.backgroundView
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.view attribute:NSLayoutAttributeTop
                                                    multiplier:1
                                                      constant:-20];
    }
    [self.view addConstraint:topConstraint];

    
    self.webView.delegate = self;
    self.webView.scalesPageToFit = YES;
    NSURL *url = [NSURL URLWithString:_originalIconURLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    self.titleLabel.text = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

@end
