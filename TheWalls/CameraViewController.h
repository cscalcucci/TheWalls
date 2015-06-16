//
//  CameraViewController.h
//  TheWalls
//
//  Created by John McClelland on 6/15/15.
//  Copyright (c) 2015 machine^n. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#import "Photo.h"
#import "UIColor+CustomColors.h"

@interface CameraViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property CLLocation *userLocation;
@property UIImage *imageDidSelected;
@property UIImageView *imagePreview;
@property UIButton *cameraButton;
@property UIButton *importButton;
@property UIButton *saveButton;

@end
