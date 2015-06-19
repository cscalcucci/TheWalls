//
//  Photo.m
//  TheWalls
//
//  Created by John McClelland on 6/15/15.
//  Copyright (c) 2015 machine^n. All rights reserved.
//

#import "Object.h"
#import <Parse/PFObject+Subclass.h>

@implementation Object

@dynamic caption;
@dynamic file;
@dynamic createdBy;
@dynamic location;
@dynamic annotation;
@dynamic latitude;
@dynamic longitude;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Object";
}

@end
