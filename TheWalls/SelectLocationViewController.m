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
    [self rightSwipeGestureInitialization];
    self.userLocation = [[SharedLocation sharedLocation] getLocation];
    NSLog(@"%@", self.userLocation);

    //Foursquare API
    self.venueUrlCall = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?ll=%f,%f&oauth_token=N5Z3YJNLEWD4KIBIOB1C22YOPTPSJSL3NAEXVUMYGJC35FMP&v=20150617", self.userLocation.coordinate.latitude, self.userLocation.coordinate.longitude]];
    self.foursquareResults = [NSMutableArray new];
    [self retrieveFoursquareResults];
}

- (void)retrieveFoursquareResults {
    [FoursquareAPI retrieveFoursquareResults:self.venueUrlCall completion:^(NSArray *array) {
        self.foursquareResults = array;
        NSLog(@"%@", array);
        for (FoursquareAPI *item in self.foursquareResults) {
            NSLog(@"%@", item.venueName);
        }
        [self.tableView reloadData];
    }];
}

- (void)setFoursquareResults:(NSArray *)foursquareResults {
    _foursquareResults = foursquareResults;
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
    return self.foursquareResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    FoursquareAPI *item = [self.foursquareResults objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", item.venueName];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"selectedLocation" object:[self.foursquareResults objectAtIndex:indexPath.row]];
}

@end
