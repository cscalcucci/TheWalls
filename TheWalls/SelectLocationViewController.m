//
//  SelectLocationViewController.m
//  TheWalls
//
//  Created by John McClelland on 6/18/15.
//  Copyright (c) 2015 machine^n. All rights reserved.
//

#import "SelectLocationViewController.h"

@implementation SelectLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@", self.foursquareLocations);
    [self rightSwipeGestureInitialization];
}

#pragma mark - Swipe Gestures

//Initializations
- (void)rightSwipeGestureInitialization {
    UISwipeGestureRecognizer *rightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipeHandle:)];
    rightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [rightRecognizer setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:rightRecognizer];
}

//Methods
- (void)rightSwipeHandle:(UISwipeGestureRecognizer*)gestureRecognizer {
    NSLog(@"downSwipe");
    [self performSegueWithIdentifier:@"UnwindToCamera" sender:self];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    FoursquareAPI *item = [self.foursquareLocations objectAtIndex:indexPath.row];
    cell.textLabel.text = item.venueName;
    return cell;
}



@end
