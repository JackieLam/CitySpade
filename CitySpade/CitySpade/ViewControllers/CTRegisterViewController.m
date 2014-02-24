//
//  CTRegisterViewController.m
//  CitySpade
//
//  Created by Cho-Yeung Lam on 24/2/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import "CTRegisterViewController.h"
#import "UIBarButtonItem+ProjectButton.h"

#define titleTextColor [UIColor colorWithRed:91.0f/255.0f green:91.0f/255.0f blue:91.0f/255.0f alpha:1.0]
#define placeHolderColor [UIColor colorWithRed:111.0f/255.0f green:111.0f/255.0f blue:111.0f/255.0f alpha:1.0]

@interface CTRegisterViewController ()

@property (strong, nonatomic) IBOutlet UIView *textFieldMask;
@property (strong, nonatomic) IBOutlet UIButton *facebookButton;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation CTRegisterViewController

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
    [self customizeAppearance];
    self.title = @"Sign up";
    self.navigationItem.leftBarButtonItems = [UIBarButtonItem createEdgeButtonWithText:@"Cancel" WithTarget:self action:@selector(cancelButtonClicked:)];
    self.navigationItem.rightBarButtonItems = [UIBarButtonItem createEdgeButtonWithText:@"Submit" WithTarget:self action:@selector(submitButtonClicked:)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 
#pragma mark - Handle button

- (void)cancelButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)submitButtonClicked:(id)sender
{
    
}

- (IBAction)signinButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)facebookButtonClicked:(id)sender
{
    
}

#pragma mark - 
#pragma mark - Customize Appearance

- (void)customizeAppearance
{
    //NavigationBar title
    UIColor *red = titleTextColor;
    UIFont *font = [UIFont fontWithName:@"Avenir-Black" size:16.0f];
    NSMutableDictionary *navBarTextAttributes = [NSMutableDictionary dictionaryWithCapacity:1];
    [navBarTextAttributes setObject:font forKey:NSFontAttributeName];
    [navBarTextAttributes setObject:red forKey:NSForegroundColorAttributeName ];
    self.navigationController.navigationBar.titleTextAttributes = navBarTextAttributes;
    
    //TextField background mask
    self.textFieldMask.layer.cornerRadius = 2.0f;
    self.textFieldMask.layer.shadowOpacity = 0.2f;
    self.textFieldMask.layer.shadowOffset = CGSizeMake(0, -1);
    //Facebook Button
    self.facebookButton.layer.cornerRadius = 2.0f;
    
    //Input textfield
    self.emailTextField.attributedPlaceholder =[[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName: placeHolderColor}];
    self.passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: placeHolderColor}];
}

@end
