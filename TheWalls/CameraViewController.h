//
//  CameraViewController.h
//  TheWalls
//
//  Created by John McClelland on 6/15/15.
//  Copyright (c) 2015 machine^n. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AVFoundation/AVFoundation.h>

#import "FoursquareAPI.h"
#import "Object.h"
#import "SelectLocationViewController.h"
#import "RootViewController.h"
#import "UIColor+CustomColors.h"

@interface CameraViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVCaptureFileOutputRecordingDelegate, UITabBarControllerDelegate>

@property CLLocation *userLocation;
@property UIImage *imageDidSelected;
@property UIImageView *imagePreview;
@property UIButton *cameraButton;
@property UIButton *importButton;
@property UIButton *saveButton;
@property UIButton *locationButton;

@property Object *object;
@property BOOL tableIsHidden;
@property BOOL photoTaken;
@property FoursquareAPI *selectedVenue;


@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UILabel *venueLabel;

#define VIDEO_FILE @"test.mov"

@end
