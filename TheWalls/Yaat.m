//
//  Photo.m
//  TheWalls
//
//  Created by John McClelland on 6/15/15.
//  Copyright (c) 2015 machine^n. All rights reserved.
//

#import "Yaat.h"
#import <Parse/PFObject+Subclass.h>

@implementation Yaat

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
    return @"Yaat";
}

@end
