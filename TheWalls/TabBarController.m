//
//  TabBarController.m
//  TheWalls
//
//  Created by John McClelland on 6/23/15.
//  Copyright (c) 2015 machine^n. All rights reserved.
//

#import "TabBarController.h"

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];

    FeedViewController *feedView              = [FeedViewController new];
    RootViewController *rootView              = [RootViewController new];
    CameraViewController *cameraView          = [CameraViewController new];
    ActivityFeedViewController *activityView  = [ActivityFeedViewController new];
    ProfileSettingViewController *profileView = [ProfileSettingViewController new];

    self.tabViewControllers = [NSMutableArray new];
    [self.tabViewControllers addObject:feedView];
    [self.tabViewControllers addObject:rootView];
    [self.tabViewControllers addObject:cameraView];
    [self.tabViewControllers addObject:activityView];
    [self.tabViewControllers addObject:profileView];

    [self setViewControllers:self.tabViewControllers];

    feedView.tabBarItem     = [[UITabBarItem alloc] initWithTitle:@"feed" image:[UIImage imageNamed:@"shape1"] tag:1];
    rootView.tabBarItem     = [[UITabBarItem alloc] initWithTitle:@"feed" image:[UIImage imageNamed:@"shape1"] tag:2];
    cameraView.tabBarItem   = [[UITabBarItem alloc] initWithTitle:@"feed" image:[UIImage imageNamed:@"shape1"] tag:3];
    activityView.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"feed" image:[UIImage imageNamed:@"shape1"] tag:4];
    profileView.tabBarItem  = [[UITabBarItem alloc] initWithTitle:@"feed" image:[UIImage imageNamed:@"shape1"] tag:5];
}


@end
