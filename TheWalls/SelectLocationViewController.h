//
//  SelectLocationViewController.h
//  TheWalls
//
//  Created by John McClelland on 6/18/15.
//  Copyright (c) 2015 machine^n. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#import "FoursquareAPI.h"
#import "SharedLocation.h"

@interface SelectLocationViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSURL *venueUrlCall;
@property (nonatomic) NSArray *foursquareResults;
@property CLLocation *userLocation;

@end
