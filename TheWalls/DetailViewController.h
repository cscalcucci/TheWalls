//
//  DetailViewController.h
//  TheWalls
//
//  Created by John McClelland on 6/17/15.
//  Copyright (c) 2015 machine^n. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Object.h"
#import <ParseUI/ParseUI.h>

@interface DetailViewController : UIViewController
@property PFImageView *imageView;
@property Object *object;
@property NSArray *objectArray;
@property NSInteger indexPath;

@end
