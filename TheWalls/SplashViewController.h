//
//  SplashViewController.h
//  TheWalls
//
//  Created by John McClelland on 6/14/15.
//  Copyright (c) 2015 machine^n. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

#import "LoginViewController.h"
#import "SessionViewController.h"

@interface SplashViewController : UIViewController

@property UIImageView *firstShape;
@property UIImageView *secondShape;
@property UIImageView *thirdShape;
@property UIImageView *fourthShape;
@property PFUser *currentUser;

@end
