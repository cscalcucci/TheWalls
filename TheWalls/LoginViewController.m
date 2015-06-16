//
//  LoginViewController.m
//  TheWalls
//
//  Created by Bryon Finke on 6/15/15.
//  Copyright (c) 2015 machine^n. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property PFUser *currentUser;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.center = self.view.center;
    [self.view addSubview:loginButton];

    if ([PFUser currentUser] == nil) {
        [self.logoutButton setHidden:YES];
    } else {
        [self.usernameTextField setHidden:YES];
        [self.emailTextField setHidden:YES];
        [self.passwordTextField setHidden:YES];
        [self.signupButton setHidden:YES];
        [self.loginButton setHidden:YES];
    }
}

- (IBAction)onLoginTapped:(UIButton *)sender {
    [self userLogIn];
}
- (IBAction)onSignupTapped:(UIButton *)sender {
    [self userSignUp];
}
- (IBAction)onLogoutTapped:(UIButton *)sender {
    [self userLogout];
}

-(void)userSignUp {
    PFUser *user = [PFUser new];
    user.username = self.usernameTextField.text;
    user.email = self.emailTextField.text;
    user.password = self.passwordTextField.text;

    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            [self dismissViewControllerAnimated:true completion:nil];
        } else {
            [self showAlert:@"Signup error" param2:error];
        }
    }];
}

-(void)userLogIn {
    [PFUser logInWithUsernameInBackground:self.usernameTextField.text password:self.passwordTextField.text block:^(PFUser *user, NSError *error) {
        if (!error) {
            [self dismissViewControllerAnimated:true completion:nil];
        } else {
            [self showAlert:@"Login error" param2:error];
        }
    }];
}

- (void)_loginWithFacebook {
    // Set permissions required from the facebook user account
    NSArray *permissionsArray = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location"];

    // Login PFUser using Facebook
//    [PFFacebookUtils logInInBackgroundWithReadPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
//        if (!user) {
//            NSLog(@"Uh oh. The user cancelled the Facebook login.");
//        } else if (user.isNew) {
//            NSLog(@"User signed up and logged in through Facebook!");
//        } else {
//            NSLog(@"User logged in through Facebook!");
//        }
//    }];
}

- (void)userLogout {
    [PFUser logOutInBackground];
    [self dismissViewControllerAnimated:true completion:nil];
}

-(void)showAlert:(NSString *)message param2:(NSError *)error {
    UIAlertView *alert = [UIAlertView new];
    alert.title = message;
    alert.message = [error localizedDescription];
    [alert addButtonWithTitle:@"Dismiss"];
    alert.delegate = self;
    [alert show];
}

@end
