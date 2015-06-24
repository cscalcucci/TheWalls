//
//  TabBarController.m
//  TheWalls
//
//  Created by John McClelland on 6/23/15.
//  Copyright (c) 2015 machine^n. All rights reserved.
//

#import "TabBarController.h"

@implementation TabBarController

- (instancetype)init {
    self = [super init];
    if (self) {
        [self assignTabColors];
    
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self assignTabColors];

    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self assignTabColors];

    }
    return self;
}


- (void)assignTabColors {
    switch (self.selectedIndex) {
        case 0:
            self.view.tintColor = [UIColor peonyColor];
            break;

        case 1:
            self.view.tintColor = [UIColor limeColor];
            break;

        case 2:
            self.view.tintColor = [UIColor hamlindigoColor];
            break;

        case 3:
            self.view.tintColor = [UIColor marigoldColor];
            break;

        case 4:
            self.view.tintColor = [UIColor paperColor];
            break;
            
        default:
            break;
    }
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    [self assignTabColors];
    NSLog(@"%li", self.selectedIndex);

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self assignTabColors];
}

@end
