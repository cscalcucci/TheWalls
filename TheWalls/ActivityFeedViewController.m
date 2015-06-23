//
//  ActivityFeedViewController.m
//  TheWalls
//
//  Created by Christopher Scalcucci on 6/22/15.
//  Copyright (c) 2015 machine^n. All rights reserved.
//

#import "ActivityFeedViewController.h"
#import <Parse/Parse.h>
#import "Activity.h"

@interface ActivityFeedViewController ()

@end

@implementation ActivityFeedViewController

-(id)initWithCoder:(NSCoder *)aDecoder {

    self = [super initWithCoder:aDecoder];
    if (self) {
        self.parseClassName = @"Object";
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = YES;
//        self.objectsPerPage = ;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.containerView.hidden = YES;

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self loadObjects];
    [self.tableView reloadData];
}

#pragma mark - TableView DataSource & Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {

    Object *photo = (Object*)object;

    static NSString *CellIdentifier = @"ActivityCell";

    ActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (!cell) {
        cell = [[ActivityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    UIGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureRecognizerShouldBegin:)];
    tapRecognizer.delegate = self;
    [cell.tapLabel addGestureRecognizer:tapRecognizer];

    cell.timeAgo.text = [self relativeDate:photo.createdAt];
    cell.venueName.text = photo.venueName;
    cell.indexPath = indexPath.row;
    cell.thumbnail.file = photo.file;
    [cell.thumbnail loadInBackground];
    cell.delegate =self;


    return cell;
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([[gestureRecognizer view] isKindOfClass:[UILabel class]]) {
        return YES;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.containerView.hidden = NO;
}

- (PFQuery *)queryForTable {

    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    [query includeKey:@"Owner"];
    [query orderByDescending:@"createdAt"];
    return query;
}

#pragma mark - Cell Delegates (For Now)

-(void)ActivityCell:(id)cell didTapButton:(UIButton *)button ofType:(NSString *)type atIndex:(NSInteger)indexPath {

    Object *photo = [self.objects objectAtIndex:indexPath];

    NSLog(@"Button Tapped");
    button.selected = !button.selected;

    if (button.selected) {
        button.enabled = NO;
    } else {
        button.enabled = YES;
    }

    if ([type isEqualToString:@"upvote"]) {
        [self upvotePhoto:photo];
    } else {
        [self downvotePhoto:photo];
    }
}

-(void)upvotePhoto:(Object *)photo {

    [photo incrementKey:@"upvotes" byAmount:[NSNumber numberWithInt:1]];
    [photo saveInBackground];
    Activity *activity = [[Activity alloc] initWithType:@"upvote" andContent:photo];
    [activity saveInBackground];
    NSLog(@"Splat Upvoted");
}

-(void)downvotePhoto:(Object *)photo {
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

-(void)commentButtonTappedAtPhoto:(Object *)photo {
    NSLog(@"Comment Tapped");
    //    Activity *activity = [[Activity alloc] initWithType:@"comment" andContent:photo];
    
}

#pragma mark - Other Methods

- (NSString *)relativeDate:(NSDate *)dateCreated {
    NSCalendarUnit units = NSCalendarUnitSecond |
    NSCalendarUnitMinute | NSCalendarUnitHour |
    NSCalendarUnitDay | NSCalendarUnitWeekOfYear |
    NSCalendarUnitMonth | NSCalendarUnitYear;

    // if `date` is before "now" (i.e. in the past) then the components will be positive
    NSDateComponents *components = [[NSCalendar currentCalendar] components:units
                                                                   fromDate:dateCreated
                                                                     toDate:[NSDate date]
                                                                    options:0];
    NSLog(@"%ld year, %ld month, %ld day, %ld hour, %ld minute, %ld second", components.year, components.month, components.day, components.hour, components.minute, (long)components.second);
    if (components.year > 0) {
        return [NSString stringWithFormat:@"%ld years ago", (long)components.year];
    } else if (components.month > 0) {
        return [NSString stringWithFormat:@"%ld months ago", (long)components.month];
    } else if (components.weekOfYear > 0) {
        return [NSString stringWithFormat:@"%ld weeks ago", (long)components.weekOfYear];
    } else if (components.day > 0) {
        return [NSString stringWithFormat:@"%ld days ago", (long)components.day];
    } else if (components.hour > 0) {
        return [NSString stringWithFormat:@"%ld hours ago", (long)components.hour];
    } else if (components.minute > 0) {
        return [NSString stringWithFormat:@"%ld minutes ago", (long)components.minute];
    } else if (components.second > 0) {
        return [NSString stringWithFormat:@"%ld seconds ago", (long)components.second];
    } else {
        return [NSString stringWithFormat:@"Time Traveller"];
    }
}

@end
