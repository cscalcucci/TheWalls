//
//  UsernameViewController.m
//  TheWalls
//
//  Created by Bryon Finke on 6/17/15.
//  Copyright (c) 2015 machine^n. All rights reserved.
//

#import "UsernameViewController.h"

@interface UsernameViewController ()
@property PFUser *currentUser;
@property (weak, nonatomic) IBOutlet UINavigationBar *usernameNav;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UIButton *usernameButton;
@end

@implementation UsernameViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.currentUser = [PFUser currentUser];
    self.view.backgroundColor = [UIColor paperColor];
    self.usernameNav.topItem.title = @"Username";
    self.usernameTextField.placeholder = @"create a username";
    [self.usernameTextField becomeFirstResponder];
    [self.usernameButton setHidden:YES];
    self.usernameButton.backgroundColor = [UIColor
                                         colorWithRed:0.518
                                         green:0.894
                                         blue:0.345
                                         alpha:1];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self updateUsername];

    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    [self.usernameButton setHidden:NO];

    return YES;
}

- (IBAction)onContinuePressed:(UIButton *)sender {
    [self updateUsername];
}

-(void)updateUsername {
    PFQuery *splatsQuery = [PFUser query];
    [splatsQuery whereKey:@"username" equalTo:self.usernameTextField.text];
    NSLog(@"%lu", splatsQuery.countObjects);
    NSLog(@"%@", self.usernameTextField.text);
    if (splatsQuery.countObjects == 0) {
        self.currentUser[@"username"] = self.usernameTextField.text;
        [self.currentUser saveInBackground];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PrimaryView" bundle:[NSBundle mainBundle]];
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"RootViewController"];
        [self presentViewController:viewController animated:YES completion:NULL];
    } else {
        self.usernameTextField.text = @"";
        [self showAlert:@"Username error" param2:[NSString stringWithFormat:@"Username %@ is already taken. Please try again.", self.usernameTextField.text]];
    }
}

-(void)showAlert:(NSString *)message param2:(NSString *)error {
    UIAlertView *alert = [UIAlertView new];
    alert.title = message;
    alert.message = error;
    [alert addButtonWithTitle:@"Dismiss"];
    alert.delegate = self;
    [alert show];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PrimaryView" bundle:[NSBundle mainBundle]];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
    [self presentViewController:viewController animated:YES completion:NULL];
}

-(IBAction)unwindUsername:(UIStoryboardSegue *)segue {

}

@end
