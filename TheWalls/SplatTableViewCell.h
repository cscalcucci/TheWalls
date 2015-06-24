//
//  SplatTableViewCell.h
//  TheWalls
//
//  Created by Bryon Finke on 6/22/15.
//  Copyright (c) 2015 machine^n. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>
#import "Object.h"

@protocol ActivityCellDelegate <NSObject>
-(void)ActivityCell:(id)cell didTapButton:(UIButton *)button ofType:(NSString *)type atIndex:(NSInteger)indexPath;
@end

@interface SplatTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet PFImageView *splatImageView;
@property (weak, nonatomic) IBOutlet UIButton *downvoteButton;
@property (weak, nonatomic) IBOutlet UIButton *upvoteButton;
@property (nonatomic, assign) id <ActivityCellDelegate> delegate;
@property NSInteger indexPath;
@property Object *photo;
@property (weak, nonatomic) IBOutlet UILabel *votesCount;
@end
