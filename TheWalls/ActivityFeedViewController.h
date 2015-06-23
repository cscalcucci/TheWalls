//
//  ActivityFeedViewController.h
//  TheWalls
//
//  Created by Christopher Scalcucci on 6/22/15.
//  Copyright (c) 2015 machine^n. All rights reserved.
//

#import <ParseUI/ParseUI.h>
#import "ActivityCell.h"

@interface ActivityFeedViewController : PFQueryTableViewController <UITableViewDataSource, UITableViewDelegate, ActivityCellDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerView;



@end
