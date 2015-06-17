//
//  Photo.m
//  TheWalls
//
//  Created by John McClelland on 6/15/15.
//  Copyright (c) 2015 machine^n. All rights reserved.
//

#import "Splat.h"
#import <Parse/PFObject+Subclass.h>

@implementation Splat

@dynamic objectID;
@dynamic caption;
@dynamic splatFile;
@dynamic createdBy;
@dynamic annotation;
@dynamic latitude;
@dynamic longitude;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Splat";
}

@end
