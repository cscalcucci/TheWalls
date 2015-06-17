//
//  Splat.h
//  TheWalls
//
//  Created by John McClelland on 6/16/15.
//  Copyright (c) 2015 machine^n. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>


@interface Splat : MKPointAnnotation

@property CLLocation *location;
@property PFUser *user;
@property PFFile *contentFile;
@property NSDate *timeCreated;

-(instancetype)init;

@end
