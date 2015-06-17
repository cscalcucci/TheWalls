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
@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Sign Up";
    self.passwordTextField.secureTextEntry = YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([PFUser currentUser] == nil) {
        [self userSignUp];
    }

    return YES;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
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
