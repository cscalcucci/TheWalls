//
//  ViewController.h
//  testCamera
//
//  Created by John McClelland on 6/20/15.
//  Copyright (c) 2015 machine^n. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface HybridCameraViewController : UIViewController 

@property UIButton *button;
@property UIButton *saveButton;
@property UIImageView *previewView;

#define VIDEO_FILE @"test.mov"

@end

