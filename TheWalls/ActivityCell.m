//
//  ActivityCell.m
//  TheWalls
//
//  Created by Christopher Scalcucci on 6/22/15.
//  Copyright (c) 2015 machine^n. All rights reserved.
//

#import "ActivityCell.h"

@implementation ActivityCell


- (IBAction)upvoteTapped:(UIButton *)sender {
    [self.delegate ActivityCell:self didTapButton:sender ofType:@"upvote" atIndex:self.indexPath];
}

- (IBAction)downvoteTapped:(UIButton *)sender {
    [self.delegate ActivityCell:self didTapButton:sender ofType:@"downvote" atIndex:self.indexPath];
}

@end
