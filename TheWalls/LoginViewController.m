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
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property PFUser *currentUser;
@property (weak, nonatomic) IBOutlet UINavigationBar *loginNav;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.loginNav.topItem.title = @"Log In";
    self.passwordTextField.secureTextEntry = YES;
    self.usernameTextField.placeholder = @"username";
    self.passwordTextField.placeholder = @"password";
    [self.usernameTextField becomeFirstResponder];
//    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
//    loginButton.center = self.view.center;
//    [self.view addSubview:loginButton];

}

- (IBAction)onLoginTapped:(UIButton *)sender {
    [self userLogIn];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([PFUser currentUser] == nil) {
        [self userLogIn];
    } else {

    }
    return YES;
}

-(void)userLogIn {
    [PFUser logInWithUsernameInBackground:self.usernameTextField.text password:self.passwordTextField.text block:^(PFUser *user, NSError *error) {
        if (!error) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PrimaryView" bundle:[NSBundle mainBundle]];
            UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"RootViewController"];
            [self presentViewController:viewController animated:NO completion:NULL];
        } else {
            [self showAlert:@"Login error" param2:error];
        }
    }];
}

- (void)_loginWithFacebook {
    // Set permissions required from the facebook user account
//    NSArray *permissionsArray = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location"];
//
//    // Login PFUser using Facebook
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

-(void)showAlert:(NSString *)message param2:(NSError *)error {
    UIAlertView *alert = [UIAlertView new];
    alert.title = message;
    alert.message = [error localizedDescription];
    [alert addButtonWithTitle:@"Dismiss"];
    alert.delegate = self;
    [alert show];
}

@end
