//
//  Activity.h
//  TheWalls
//
//  Created by Christopher Scalcucci on 6/19/15.
//  Copyright (c) 2015 machine^n. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "Object.h"

@interface Activity : PFObject<PFSubclassing>

+ (NSString *)parseClassName;

@property PFUser *fromUser;
@property PFUser *toUser;
@property NSString *type;
@property PFObject *content;

-(instancetype)initWithType:(NSString *)type andContent:(Object *)object;

@end

