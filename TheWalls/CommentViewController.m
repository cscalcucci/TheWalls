//
//  CommentViewController.m
//  TheWalls
//
//  Created by John McClelland on 6/19/15.
//  Copyright (c) 2015 machine^n. All rights reserved.
//

#import "CommentViewController.h"

@implementation CommentViewController

-(void)viewDidLoad {
    [super viewDidLoad];

    [self leftSwipeGestureInitialization];
    [self rightSwipeGestureInitialization];
}








#pragma mark - Swipe Gestures

//Initializations
- (void)leftSwipeGestureInitialization {
    UISwipeGestureRecognizer *leftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipeHandle:)];
    leftRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [leftRecognizer setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:leftRecognizer];
}

- (void)rightSwipeGestureInitialization {
    UISwipeGestureRecognizer *rightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipeHandle:)];
    rightRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [rightRecognizer setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:rightRecognizer];
}

//Methods
- (void)leftSwipeHandle:(UISwipeGestureRecognizer*)gestureRecognizer {
    NSLog(@"leftSwipe");
    [self performSegueWithIdentifier:@"unwindToDetail" sender:self];
}

- (void)rightSwipeHandle:(UISwipeGestureRecognizer*)gestureRecognizer {
    NSLog(@"rightSwipe");
    [self performSegueWithIdentifier:@"unwindToDetail" sender:self];
}
















@end
