//
//  PhoneViewController.m
//  TheWalls
//
//  Created by Bryon Finke on 6/17/15.
//  Copyright (c) 2015 machine^n. All rights reserved.
//

#import "PhoneViewController.h"

@interface PhoneViewController ()
@property PFUser *currentUser;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UINavigationBar *phoneNav;
@end

@implementation PhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.phoneNav.topItem.title = @"Phone Number";
    self.phoneTextField.placeholder = @"enter your phone number";
    [self.phoneTextField becomeFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self updatePhone];

    return YES;
}

- (IBAction)onContinuePressed:(UIButton *)sender {
    [self updatePhone];
}

-(void)updatePhone {
    [self.currentUser setObject:self.phoneTextField.text forKey:@"phone"];
    [self.currentUser saveInBackground];
    [self performSegueWithIdentifier:@"phoneSegue" sender:self];
}

-(IBAction)unwindPhone:(UIStoryboardSegue *)segue {
    NSLog(@"running unwindPhone");
}

@end
