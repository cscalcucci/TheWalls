//
//  HomeViewController.m
//  TheWalls
//
//  Created by Bryon Finke on 6/15/15.
//  Copyright (c) 2015 machine^n. All rights reserved.
//

#import "HomeViewController.h"
#import <Parse/Parse.h>
#import "LoginViewController.h"

@interface HomeViewController ()
@property PFUser *currentUser;
@property (weak, nonatomic) IBOutlet UILabel *currentUserLabel;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"Logged in as: %@", self.currentUser.username);
    if ([PFUser currentUser] == nil) {
        [self performSegueWithIdentifier:@"LoginSegue" sender:self];
    } else {
        self.currentUser = [PFUser currentUser];
        self.currentUserLabel.text = self.currentUser.email;
    }
}

- (IBAction)onLogoutTapped:(UIButton *)sender {
    [self userLogout];
}

- (void)userLogout {
    NSLog(@"logout attempted");
    [PFUser logOutInBackground];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Logged Out" message:@"You have logged out." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
    [alert show];
}

@end
