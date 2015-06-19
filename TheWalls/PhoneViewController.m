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
@property (weak, nonatomic) IBOutlet UIButton *phoneButton;
@end

@implementation PhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.phoneNav.topItem.title = @"Phone Number";
    self.phoneTextField.placeholder = @"enter your phone number";
    [self.phoneTextField becomeFirstResponder];
    [self.phoneButton setHidden:YES];
    self.phoneButton.backgroundColor = [UIColor
                                         colorWithRed:0.518
                                         green:0.894
                                         blue:0.345
                                         alpha:1];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self updatePhone];

    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    [self.phoneButton setHidden:NO];

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
