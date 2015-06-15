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
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)onLoginTapped:(UIButton *)sender {
    [self userLogIn];
}

- (IBAction)onSignupTapped:(UIButton *)sender {
    [self userSignUp];
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

-(void)showAlert:(NSString *)message param2:(NSError *)error {
    UIAlertView *alert = [UIAlertView new];
    alert.title = message;
    alert.message = [error localizedDescription];
    [alert addButtonWithTitle:@"Dismiss"];
    alert.delegate = self;
    [alert show];
}

@end
