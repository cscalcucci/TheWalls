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
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"Logged in as: %@", self.currentUser.username);
    if ([PFUser currentUser] == nil) {
        [self.currentUserLabel setHidden:YES];
        [self.logoutButton setHidden:YES];
        [self performSegueWithIdentifier:@"LoginSegue" sender:self];
    } else {
        self.currentUser = [PFUser currentUser];
        self.currentUserLabel.text = self.currentUser.email;

    }
}

@end
