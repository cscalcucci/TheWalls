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

@interface FeedViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSArray *splats;
@end

@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];

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

    Object *splat = [[Object alloc]init];
    splat = [self.splats objectAtIndex:indexPath.row];
    cell.imageView.file = splat.file;
    cell.imageView.image = [UIImage imageNamed:@"triad"];
    [cell.imageView loadInBackground];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.backgroundColor = [UIColor blueColor];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.splats.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(598, 598);
}

@end
