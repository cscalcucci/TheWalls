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

@interface Splat : PFObject<PFSubclassing>

+ (NSString *)parseClassName;

@property NSString *objectID;
@property NSString *caption;
@property PFFile *splatFile;
@property PFUser *createdBy;
@property MKPointAnnotation *annotation;
@property double latitude;
@property double longitude;



@end
