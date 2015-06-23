//
//  ActivityCell.h
//  TheWalls
//
//  Created by Christopher Scalcucci on 6/22/15.
//  Copyright (c) 2015 machine^n. All rights reserved.
//

#import <ParseUI/ParseUI.h>
#import "Object.h"

@protocol ActivityCellDelegate <NSObject>

-(void)ActivityCell:(id)cell didTapButton:(UIButton *)button ofType:(NSString *)type atIndex:(NSInteger)indexPath;

@end


@interface ActivityCell : PFTableViewCell


@property (weak, nonatomic) IBOutlet PFImageView *thumbnail;

//@property (weak, nonatomic) IBOutlet UIButton *upvoteButton;
//@property (weak, nonatomic) IBOutlet UIButton *downvoteButton;
@property NSInteger indexPath;
@property (weak, nonatomic) IBOutlet UILabel *distance;
@property (weak, nonatomic) IBOutlet UILabel *timeAgo;
@property (weak, nonatomic) IBOutlet UILabel *venueName;

@property (weak, nonatomic) IBOutlet UILabel *tapLabel;
@property (nonatomic, assign) id <ActivityCellDelegate> delegate;




@end
