//
//  SignupViewController.m
//  TheWalls
//
//  Created by Bryon Finke on 6/17/15.
//  Copyright (c) 2015 machine^n. All rights reserved.
//

#import "SignupViewController.h"

@interface SignupViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property PFUser *currentUser;
@property (weak, nonatomic) IBOutlet UINavigationBar *signupNav;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;
@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.signupNav.topItem.title = @"Sign Up";
    self.passwordTextField.secureTextEntry = YES;
    self.emailTextField.placeholder = @"email";
    self.passwordTextField.placeholder = @"password";
    [self.signupButton setHidden:YES];
    [self.emailTextField becomeFirstResponder];
    self.signupButton.backgroundColor = [UIColor
                                        colorWithRed:0.518
                                        green:0.894
                                        blue:0.345
                                        alpha:1];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.emailTextField.isFirstResponder) {
        [self.passwordTextField becomeFirstResponder];
    } else if (self.passwordTextField.isFirstResponder) {
        [self userSignUp];
    }

    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (self.passwordTextField.isFirstResponder) {
        [self.signupButton setHidden:NO];
    }

    return YES;
}

- (IBAction)onSignupPressed:(UIButton *)sender {
    [self userSignUp];
}

-(void)userSignUp {
    PFUser *user = [PFUser new];
    user.username = self.emailTextField.text;
    user.email = self.emailTextField.text;
    user.password = self.passwordTextField.text;

    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            [self showAlert:@"Signup error" param2:error];
        } else {
            [self performSegueWithIdentifier:@"signupSegue" sender:self];
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
