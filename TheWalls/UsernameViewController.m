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
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@end

@implementation UsernameViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.usernameTextField.placeholder = @"create a username";
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [self updateUsername];
}

-(void)updateUsername {
    self.currentUser.username = self.usernameTextField.text;
    [self.currentUser saveInBackground];
}

@end
