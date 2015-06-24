//
//  SharedLocation.h
//  TheWalls
//
//  Created by John McClelland on 6/24/15.
//  Copyright (c) 2015 machine^n. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>



@interface SharedLocation : NSObject {
    CLLocation *userLocation;
}

+ (SharedLocation *)sharedLocation;
- (void)setLocation:(CLLocation *)newLocation;
- (CLLocation *)getLocation;

@end
