//
//  CameraViewController.h
//  TheWalls
//
//  Created by John McClelland on 6/15/15.
//  Copyright (c) 2015 machine^n. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#import "Object.h"
#import "SelectLocationViewController.h"
#import "FoursquareAPI.h"
#import "UIColor+CustomColors.h"

@interface CameraViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property CLLocation *userLocation;
@property UIImage *imageDidSelected;
@property UIImageView *imagePreview;
@property UIButton *cameraButton;
@property UIButton *importButton;
@property UIButton *saveButton;
@property UIButton *locationButton;

@property Object *object;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property BOOL tableIsHidden;
@property BOOL photoTaken;
@property (weak, nonatomic) IBOutlet UILabel *venueLabel;

@end
