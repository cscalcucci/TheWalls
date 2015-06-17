//
//  HomeViewController.m
//  TheWalls
//
//  Created by Bryon Finke on 6/15/15.
//  Copyright (c) 2015 machine^n. All rights reserved.
//

#import "HomeViewController.h"
#import "LoginViewController.h"
#import "SessionViewController.h"

@interface HomeViewController ()
@property PFUser *currentUser;
@property (weak, nonatomic) IBOutlet UILabel *currentUserLabel;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    if ([PFUser currentUser] == nil) {
//        [self.currentUserLabel setHidden:YES];
//        [self.logoutButton setHidden:YES];
//        [self performSegueWithIdentifier:@"NewSessionSegue" sender:self];
//    } else {
//        self.currentUser = [PFUser currentUser];
//        self.currentUserLabel.text = self.currentUser.email;
//    }

}

- (void)viewWillAppear:(BOOL)animated {
    if ([PFUser currentUser] == nil) {
        [self.currentUserLabel setHidden:YES];
        [self.logoutButton setHidden:YES];
        [self performSegueWithIdentifier:@"NewSessionSegue" sender:self];
    } else {
        self.currentUser = [PFUser currentUser];
        self.currentUserLabel.text = self.currentUser.email;
    }
}

- (IBAction)onLogoutButtonPressed:(UIButton *)sender {
    [self userLogout];
}

- (void)userLogout {
    [PFUser logOutInBackground];
    [self refreshView];
}

-(void)refreshView {
    [self viewDidLoad];
    [self viewWillAppear:YES];
    
}

@end
