//
//  Activity.m
//  TheWalls
//
//  Created by Christopher Scalcucci on 6/19/15.
//  Copyright (c) 2015 machine^n. All rights reserved.
//

#import "Activity.h"
#import <Parse/PFObject+Subclass.h>

@implementation Activity

@dynamic fromUser;
@dynamic toUser;
@dynamic type;
@dynamic content;

+ (void)load {
    [self registerSubclass];
}

//Type @"comment", @"upvote", @"downvote"
-(instancetype)initWithType:(NSString *)type andContent:(Object *)object {
    self = [super init];
    if (self) {
        self.fromUser = [PFUser currentUser];
        self.toUser = object.createdBy;
        self.type = type;
        self.content = object;
    }
    return self;
}

+ (NSString *)parseClassName {
    return @"Activity";
}

-(void)voteButtonTapped:(UIButton *)button atPhoto:(Object *)photo {

    NSLog(@"Button Tapped");
    button.selected = !button.selected;

    if (button.selected) {
        button.enabled = NO;
    } else {
        button.enabled = YES;
    }

    if ([button.titleLabel.text isEqualToString:@"upvote"]) {

        [photo incrementKey:@"upvotes" byAmount:[NSNumber numberWithInt:1]];
        [photo saveInBackground];
        Activity *activity = [[Activity alloc] initWithType:@"upvote" andContent:photo];
        [activity saveInBackground];
        NSLog(@"Splat Upvoted");

    } else {
        [photo incrementKey:@"upvotes" byAmount:[NSNumber numberWithInt:-1]];
        [photo saveInBackground];

        PFQuery *query = [PFQuery queryWithClassName:@"Activity"];
        [query whereKey:@"fromUser" equalTo:[PFUser currentUser]];
        [query whereKey:@"toUser" equalTo:photo.createdBy];
        [query whereKey:@"type" equalTo:@"upvote"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *activities, NSError *error) {
            if (!error) {
                for (PFObject *activity in activities) {
                    [activity deleteInBackground];
                    NSLog(@"Upvote Deleted");
                }
                NSLog(@"Splat downvoted");
            }
        }];
    }

}

-(void)commentButtonTappedAtPhoto:(Object *)photo {
    NSLog(@"Comment Tapped");
//    Activity *activity = [[Activity alloc] initWithType:@"comment" andContent:photo];

}


@end
