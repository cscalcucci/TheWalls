//
//  SelectedSplatViewController.h
//  TheWalls
//
//  Created by Christopher Scalcucci on 6/22/15.
//  Copyright (c) 2015 machine^n. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectedSplatViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *commentView;

@property UIButton *commentButton;
@property UIButton *upvoteButton;
@property UIButton *downvoteButton;
@property UIButton *backButton;

@end
