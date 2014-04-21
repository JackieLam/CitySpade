//
//  CitySpadeBrokerWebViewController.m
//  CitySpadeDemo
//
//  Created by Jeason on 4/11/14.
//  Copyright (c) 2014 Jeason. All rights reserved.
//

#import "CitySpadeBrokerWebViewController.h"
#import "constant.h"
@interface CitySpadeBrokerWebViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
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
    
    if([[UINavigationBar class] respondsToSelector:@selector(appearance)]){
        [[UINavigationBar appearance] setTitleTextAttributes:
         @{
           NSForegroundColorAttributeName:[UIColor colorWithRed:122.0/255.0
                                                          green:122.0/255.0
                                                           blue:122.0/255.0
                                                          alpha:1.0],
           NSFontAttributeName: [UIFont fontWithName:@"Avenir-Black" size:15]
           }
         ];
    }
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 36)];
    [backButton setImage:[UIImage imageNamed:@"navbar_backbtn"] forState:UIControlStateNormal];
    [backButton addTarget:self
                   action:@selector(back:)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backNavigationItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    //autolayout
    NSLayoutConstraint *topConstraint;
    if ( DEVICEVERSION >= 7.0 ) {
        topConstraint = [NSLayoutConstraint constraintWithItem:self.backgroundView
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.view attribute:NSLayoutAttributeTop
                                                    multiplier:1
                                                      constant:0];
        //navigation
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = -10;
        self.navigationItem.leftBarButtonItems = @[negativeSpacer, backNavigationItem];
        
    } else {
        topConstraint = [NSLayoutConstraint constraintWithItem:self.backgroundView
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.view attribute:NSLayoutAttributeTop
                                                    multiplier:1
                                                      constant:-20];
        self.navigationItem.leftBarButtonItem = backNavigationItem;
    }
    [self.view addConstraint:topConstraint];
    self.navigationController.navigationBar.translucent = NO;
    
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

- (void)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

@end
