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

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if ([PFUser currentUser] == nil) {
        [self performSegueWithIdentifier:@"LoginSegue" sender:self];
    }
}

-(void)bringUpLoginViewController {

    NSLog(@"No current user, loading login screen.");


}

@end
