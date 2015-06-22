//
//  Photo.h
//  TheWalls
//
//  Created by John McClelland on 6/15/15.
//  Copyright (c) 2015 machine^n. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>

@interface Object : PFObject<PFSubclassing>

+ (NSString *)parseClassName;

//@property NSString *objectID;
@property NSString *caption;
@property PFFile *file;
@property PFUser *createdBy;
@property PFGeoPoint *location; //fucked
@property MKPointAnnotation *annotation; //fucked
@property NSString *venueName;
@property double latitude; //fucked
@property double longitude; //fucked

@end
