//
//  Photo.m
//  TheWalls
//
//  Created by John McClelland on 6/15/15.
//  Copyright (c) 2015 machine^n. All rights reserved.
//

#import "Photo.h"
#import <Parse/PFObject+Subclass.h>

@implementation Photo
@dynamic caption;
@dynamic imagePhoto;
@dynamic createdBy;
@dynamic latitude;
@dynamic longitude;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Photo";
}

@end
