//
//  CommentTableViewController.h
//  TheWalls
//
//  Created by Christopher Scalcucci on 6/22/15.
//  Copyright (c) 2015 machine^n. All rights reserved.
//

#import <ParseUI/ParseUI.h>

@interface CommentTableViewController : PFQueryTableViewController
@property (weak, nonatomic) IBOutlet UITextField *enterCommentTextField;
@property (weak, nonatomic) IBOutlet UIButton *postButton;

@property (weak, nonatomic) IBOutlet UIView *enterCommentView;
@end
