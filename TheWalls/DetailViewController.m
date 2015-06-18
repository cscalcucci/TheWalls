//
//  DetailViewController.m
//  TheWalls
//
//  Created by John McClelland on 6/17/15.
//  Copyright (c) 2015 machine^n. All rights reserved.
//

#import "DetailViewController.h"

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@", self.object.description);
//    self.imageView.file = self.object.contentFile;
//    [self.imageView loadInBackground];
    [self downSwipeGestureInitialization];

}

#pragma mark - Swipe Gestures

//Initializations
- (void)downSwipeGestureInitialization {
    UISwipeGestureRecognizer *downRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(downSwipeHandle:)];
    downRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [downRecognizer setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:downRecognizer];
}

//Methods
- (void)downSwipeHandle:(UISwipeGestureRecognizer*)gestureRecognizer {
    NSLog(@"downSwipe");
    [self performSegueWithIdentifier:@"UnwindToRoot" sender:self];
}

@end
