//
//  SelectedSplatViewController.m
//  TheWalls
//
//  Created by Christopher Scalcucci on 6/22/15.
//  Copyright (c) 2015 machine^n. All rights reserved.
//

#import "SelectedSplatViewController.h"
#import "UIColor+CustomColors.h"
#import <UIKit/UIKit.h>

@implementation SelectedSplatViewController

-(void)viewDidLoad {
    [super viewDidLoad];

    self.commentView.hidden = YES;

    self.downvoteButton = [self createButtonWithTitle:@"down" chooseColor:[UIColor peonyColor] andPosition:100];
    [self.downvoteButton addTarget:self action:@selector(downvote) forControlEvents:UIControlEventTouchUpInside];

    self.upvoteButton = [self createButtonWithTitle:@"up" chooseColor:[UIColor limeColor] andPosition:200];
    [self.upvoteButton addTarget:self action:@selector(upvote) forControlEvents:UIControlEventTouchUpInside];

    self.commentButton = [self createButtonWithTitle:@"comm" chooseColor:[UIColor hamlindigoColor] andPosition:300];
    [self.commentButton addTarget:self action:@selector(commentOpen) forControlEvents:UIControlEventTouchUpInside];

    self.downvoteButton = [self createButtonWithTitle:@"back" chooseColor:[UIColor peonyColor] andPosition:400];
    [self.downvoteButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];

}

-(void)upvote {

}

-(void)downvote {

}

-(void)voteWithAction:(NSString *)action {

}

-(void)back {
    
}

-(void)commentOpen {
    self.commentView.hidden = NO;
}

- (UIButton *)createButtonWithTitle:(NSString *)title chooseColor:(UIColor *)color andPosition:(int)xPosition {
    CGRect frame = self.view.frame;
    int diameter = 65;
    int gap = 20;

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width - xPosition,frame.size.height - (diameter + gap), diameter, diameter)];
    button.layer.cornerRadius = button.bounds.size.width / 2;
    button.backgroundColor = color;
    button.layer.borderColor = button.titleLabel.textColor.CGColor;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];

    [self.view addSubview:button];
    return button;
}


@end
