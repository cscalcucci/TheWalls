//
//  SharedLocation.m
//  TheWalls
//
//  Created by John McClelland on 6/24/15.
//  Copyright (c) 2015 machine^n. All rights reserved.
//

#import "SharedLocation.h"

static SharedLocation *sharedLocation;

@implementation SharedLocation

- (id)init {
    self = [super init];
    userLocation = [CLLocation new];
    return self;
}

+ (SharedLocation *)sharedLocation {
    if (!sharedLocation) {
        sharedLocation = [SharedLocation new];
    }
    return sharedLocation;
}

- (void)setLocation:(CLLocation *)newLocation {
    userLocation = newLocation;
}

- (CLLocation *)getLocation {
    return userLocation;
}

@end
