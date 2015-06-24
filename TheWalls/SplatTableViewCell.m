//
//  SplatTableViewCell.m
//  TheWalls
//
//  Created by Bryon Finke on 6/22/15.
//  Copyright (c) 2015 machine^n. All rights reserved.
//

#import "SplatTableViewCell.h"
#import "Object.h"
#import "Activity.h"

@implementation SplatTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)upvotePhoto:(Object *)photo {
    [photo incrementKey:@"upvotes" byAmount:[NSNumber numberWithInt:1]];
    [photo saveInBackground];
    Activity *activity = [[Activity alloc] initWithType:@"upvote" andContent:photo];
    [activity saveInBackground];
    NSLog(@"Splat Upvoted");
}

- (IBAction)upvoteTapped:(UIButton *)sender {
    [self.delegate ActivityCell:self didTapButton:sender ofType:@"upvote" atIndex:self.indexPath];
}

- (IBAction)downvoteTapped:(UIButton *)sender {
    [self.delegate ActivityCell:self didTapButton:sender ofType:@"downvote" atIndex:self.indexPath];
}

@end
