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
    self.tabBar.tintColor = [UIColor peonyColor];
    [self.tabBar setTranslucent:YES];

}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//- (void)assignTabColors {
//    switch (self.selectedIndex) {
//        case 0:
//            self.tabBar.tintColor = [UIColor peonyColor];
//            break;
//
//        case 1:
//            self.tabBar.tintColor = [UIColor limeColor];
//            break;
//
//        case 2:
//            self.tabBar.tintColor = [UIColor hamlindigoColor];
//            break;
//
//        case 3:
//            self.tabBar.tintColor = [UIColor marigoldColor];
//            break;
//
//        case 4:
//            self.tabBar.tintColor = [UIColor paperColor];
//            break;
//            
//        default:
//            break;
//    }
//}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
//    [self assignTabColors];
    NSLog(@"%li", self.selectedIndex);

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self assignTabColors];
}

@end
