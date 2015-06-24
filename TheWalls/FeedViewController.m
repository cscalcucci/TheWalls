//
//  FeedViewController.m
//  TheWalls
//
//  Created by Bryon Finke on 6/22/15.
//  Copyright (c) 2015 machine^n. All rights reserved.
//

#import "FeedViewController.h"
#import "Object.h"
#import "SplatTableViewCell.h"
#import "Activity.h"

@interface FeedViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSArray *splats;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property NSArray *votes;
@end

@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self checkVotes];
    self.headerView.backgroundColor = [UIColor
                                         colorWithRed:0.369
                                         green:0.498
                                         blue:0.918
                                         alpha:1];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 450.0;

    PFQuery *splatsQuery = [Object query];
    [splatsQuery orderByDescending:@"createdAt"];
    [splatsQuery findObjectsInBackgroundWithBlock:^(NSArray *splatsResponse, NSError *error) {
        if (!error) {
            NSLog(@"Successfully retrieved %lu posts.", splatsResponse.count);
            self.splats = [[NSArray alloc] initWithArray:splatsResponse];
        }
        [self.tableView reloadData];
    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Object *object = [self.splats objectAtIndex:indexPath.row];
    SplatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    [[cell.downvoteButton layer] setBorderWidth:1.0f];
    [[cell.downvoteButton layer] setCornerRadius:4.0f];
    [[cell.downvoteButton layer] setBorderColor:[UIColor
                                             colorWithRed:0.38
                                             green:0.38
                                             blue:0.38
                                             alpha:1].CGColor];
    [[cell.upvoteButton layer] setBorderWidth:1.0f];
    [[cell.upvoteButton layer] setCornerRadius:4.0f];
    [[cell.upvoteButton layer] setBorderColor:[UIColor
                                             colorWithRed:0.38
                                             green:0.38
                                             blue:0.38
                                             alpha:1].CGColor];
    for (Activity *vote in self.votes) {
        if ((object.createdBy == vote.toUser) && ([vote.type isEqualToString:@"upvote"])) {
            cell.upvoteButton.selected = YES;
            cell.upvoteButton.enabled = NO;
        } else if ((object.createdBy == vote.toUser) && ([vote.type isEqualToString:@"downvote"])) {
            cell.downvoteButton.selected = YES;
            cell.downvoteButton.enabled = NO;
        }
    }
    cell.indexPath = indexPath.row;
    cell.delegate = self;
    Object *splat = [[Object alloc]init];
    splat = [self.splats objectAtIndex:indexPath.row];
    cell.splatImageView.file = splat.file;
    cell.splatImageView.frame = CGRectMake(
                                 cell.frame.origin.x,
                                 cell.frame.origin.y, cell.frame.size.width, cell.frame.size.width);
    cell.splatImageView.clipsToBounds = YES;
    [cell.splatImageView loadInBackground];
    cell.votesCount.text = [NSString stringWithFormat:@"%d", splat.upVotes];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.splats.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 450;
}

-(void)checkVotes {
    PFQuery *query = [PFQuery queryWithClassName:@"Activity"];
    [query whereKey:@"fromUser" equalTo:[PFUser currentUser]];
    [query whereKey:@"type" equalTo:@"upvote"];
    [query whereKey:@"type" equalTo:@"downvote"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *activities, NSError *error) {
        if (!error) {
            self.votes = activities;
        }
    }];
}

-(void)ActivityCell:(id)cell didTapButton:(UIButton *)button ofType:(NSString *)type atIndex:(NSInteger)indexPath {

    NSLog(@"Vote Tapped");

    Object *photo = [self.splats objectAtIndex:indexPath];
    int amt = 0;

    for (Activity *vote in self.votes) {
        if ((photo.createdBy == vote.toUser) && (![vote.type isEqualToString:type])) {
            if ([type isEqualToString:@"upvote"]) {
                amt = 2;
                vote.type = @"downvote";
            } else if ([type isEqualToString:@"downvote"]){
                amt = -2;
                vote.type = @"upvote";
            }
            [vote saveInBackground];
            button.enabled = NO;
            button.selected = YES;
        } else {
            if ([type isEqualToString:@"upvote"]) amt = 1;
            if ([type isEqualToString:@"downvote"]) amt = -1;

            Activity *newActivity = [[Activity alloc] initWithType:type andContent:photo];
            [newActivity saveInBackground];
            button.enabled = NO;
            button.selected = YES;
        }
        [photo incrementKey:@"upVotes" byAmount:[NSNumber numberWithInt:amt]];
        [photo saveInBackground];
    }
}

@end
