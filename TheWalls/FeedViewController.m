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
@property (weak, nonatomic) IBOutlet UILabel *header;
@property NSArray *splats;
@end

@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.header.backgroundColor = [UIColor
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
    SplatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    cell.upButton.backgroundColor = [UIColor
                                     colorWithRed:0.518
                                     green:0.894
                                     blue:0.345
                                     alpha:1];
    cell.downButton.backgroundColor = [UIColor
                                       colorWithRed:0.890
                                       green:0.376
                                       blue:0.494
                                       alpha:1];
    cell.upButton.tag = indexPath.row;
    [cell.upButton addTarget:self action:@selector(onUpButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    cell.downButton.tag = indexPath.row;
    [cell.downButton addTarget:self action:@selector(onDownButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    Object *splat = [[Object alloc]init];
    splat = [self.splats objectAtIndex:indexPath.row];
    cell.splatImageView.file = splat.file;
    cell.splatImageView.image = [UIImage imageNamed:@"triad"];
    [cell.splatImageView loadInBackground];
    cell.splatImageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.splatImageView.clipsToBounds = YES;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.splats.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 450;
}

- (IBAction)onDownButtonTapped:(id)sender {
    NSLog(@"DOWN button tapped");
}

-(void)onUpButtonTapped:(UIButton*)sender {
    NSLog(@"UP button tapped");
}

@end
