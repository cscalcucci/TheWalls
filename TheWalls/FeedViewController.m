//
//  FeedViewController.m
//  TheWalls
//
//  Created by Bryon Finke on 6/22/15.
//  Copyright (c) 2015 machine^n. All rights reserved.
//

#import "FeedViewController.h"
#import "Object.h"
#import "SplatCollectionViewCell.h"

@interface FeedViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *splatsCollectionView;
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
        [self.splatsCollectionView reloadData];
    }];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SplatCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];

    Object *splat = [[Object alloc]init];
    splat = [self.splats objectAtIndex:indexPath.row];
    cell.imageView.file = splat.file;
    cell.imageView.image = [UIImage imageNamed:@"triad"];
    [cell.imageView loadInBackground];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.splats.count;
}

@end
