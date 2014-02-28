//
//  CTRegisterViewController.m
//  CitySpade
//
//  Created by Cho-Yeung Lam on 24/2/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import "CTRegisterViewController.h"
#import "UIBarButtonItem+ProjectButton.h"
#import "RESTfulEngine.h"
#import <FacebookSDK/FacebookSDK.h>
#import "FacebookDelegate.h"
#import "NSString+Encryption.h"
#import "Constants.h"

#define titleTextColor [UIColor colorWithRed:91.0f/255.0f green:91.0f/255.0f blue:91.0f/255.0f alpha:1.0]
#define placeHolderColor [UIColor colorWithRed:111.0f/255.0f green:111.0f/255.0f blue:111.0f/255.0f alpha:1.0]

@interface CTRegisterViewController () <UITextFieldDelegate>

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
    self.title = @"Register";
    self.navigationItem.leftBarButtonItems = [UIBarButtonItem createEdgeButtonWithText:@"Sign in" WithTarget:self action:@selector(cancelButtonClicked:)];
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
    [self registerCitySpade];
}

- (IBAction)signinButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)facebookButtonClicked:(id)sender
{
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        [FBSession.activeSession closeAndClearTokenInformation];
    } else {
        [FBSession openActiveSessionWithReadPermissions:@[@"basic_info"]
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             FacebookDelegate *delegate = [FacebookDelegate sharedInstance];
             // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
             [delegate sessionStateChanged:session state:state error:error];
         }];
    }
}

#pragma mark -
#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //点击Return按钮时候触发此method
    if (textField == self.emailTextField) {
        [self.passwordTextField becomeFirstResponder];
    }
    else if (textField == self.passwordTextField) {
        [self.passwordTextField resignFirstResponder];
        [SVProgressHUD showWithStatus:@"Logging in"];
        [self registerCitySpade];
    }
    return YES;
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

#pragma mark -
#pragma mark - Helper Method

- (void)registerCitySpade
{
    [SVProgressHUD showWithStatus:@"Registering"];
    
    if (![NSString isEmailAddress:self.emailTextField.text]) {
        [SVProgressHUD showErrorWithStatus:@"Invalid email address"];
    }
    else if (self.passwordTextField.text.length < 8) {
        [SVProgressHUD showErrorWithStatus:@"Invalid password"];
    }
    else {
        
        //Send registration request
        
        [RESTfulEngine registerWithUsername:self.emailTextField.text password:self.passwordTextField.text firstName:nil lastName:nil onSucceeded:^{
            
            [SVProgressHUD showSuccessWithStatus:@"Register Success!"];
            [[NSUserDefaults standardUserDefaults] setObject:[NSString usernameWithEmail:self.emailTextField.text] forKey:kUserName];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRegisterSuccess object:self.emailTextField.text userInfo:nil];
            
        } onError:^(NSError *engineError) {
            
        }];
    }
}

@end
