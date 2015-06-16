//
//  Photo.h
//  TheWalls
//
//  Created by John McClelland on 6/15/15.
//  Copyright (c) 2015 machine^n. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Photo : PFObject<PFSubclassing>

+ (NSString *)parseClassName;

//@property NSString *caption;
@property PFFile *imagePhoto;
@property PFUser *createdBy;
@property NSInteger latitude;
@property NSInteger longitude;


@end
