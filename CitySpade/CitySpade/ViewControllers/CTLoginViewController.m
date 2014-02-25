//
//  CTLoginViewController.m
//  CitySpade
//
//  Created by Cho-Yeung Lam on 22/2/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import "CTLoginViewController.h"
#import "CTRegisterViewController.h"
#import "UIBarButtonItem+ProjectButton.h"
#import "AppDelegate.h"

#define titleTextColor [UIColor colorWithRed:91.0f/255.0f green:91.0f/255.0f blue:91.0f/255.0f alpha:1.0]
#define placeHolderColor [UIColor colorWithRed:111.0f/255.0f green:111.0f/255.0f blue:111.0f/255.0f alpha:1.0]

@interface CTLoginViewController ()

@property (strong, nonatomic) IBOutlet UIView *textFieldsMask;
@property (strong, nonatomic) IBOutlet UIButton *facebookButton;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation CTLoginViewController

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
#pragma mark - Handle Button Clicked

- (void)cancelButtonClicked:(id)sender
{
    
}

- (void)submitButtonClicked:(id)sender
{
    
}

- (IBAction)facebookButtonClicked:(id)sender
{
    // If the session state is any of the two "open" states when the button is clicked
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        
        // Close the session and remove the access token from the cache
        // The session state handler (in the app delegate) will be called automatically
        [FBSession.activeSession closeAndClearTokenInformation];
        
        // If the session state is not any of the two "open" states when the button is clicked
    } else {
        // Open a session showing the user the login UI
        // You must ALWAYS ask for basic_info permissions when opening a session
        [FBSession openActiveSessionWithReadPermissions:@[@"basic_info"]
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             
             // Retrieve the app delegate
             AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
             // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
             [appDelegate sessionStateChanged:session state:state error:error];
         }];
    }
}

- (IBAction)registerButtonClicked:(id)sender
{
    CTRegisterViewController *registerVC = [[CTRegisterViewController alloc] initWithNibName:@"CTRegisterViewController" bundle:nil];
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (IBAction)forgetPasswordButtonClicked:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Forgot your password?" message:@"Please enter the email address for your account. A verification code will be sent to you. Once you have received the verification code, you will be able to choose a new password for your account." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Send", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView show];
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
    self.textFieldsMask.layer.cornerRadius = 2.0f;
    self.textFieldsMask.layer.shadowOpacity = 0.2f;
    self.textFieldsMask.layer.shadowOffset = CGSizeMake(0, -1);
    //Facebook Button
    self.facebookButton.layer.cornerRadius = 2.0f;
    
    //Input textfield
    self.emailTextField.attributedPlaceholder =[[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName: placeHolderColor}];
    self.passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: placeHolderColor}];
}

@end
