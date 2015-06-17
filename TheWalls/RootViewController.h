//
//  ViewController.h
//  TheWalls
//
//  Created by John McClelland on 6/13/15.
//  Copyright (c) 2015 machine^n. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#import "UIColor+CustomColors.h"
#import "Photo.h"
#import "Splat.h"
#import "CameraViewController.h"
#import "DetailViewController.h"

//Notification center - will probably have to refactor instead of passing location throughout the application
static NSString * const currentLocationDidChangeNotification = @"currentLocationDidChangeNotification";

@interface RootViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>

//Location properties
@property CLLocationManager *locationManager;
@property CLLocation *userLocation;
@property MKMapView *primaryMapView;
@property MKAnnotationView *splatAnnotationView;
@property Splat *splat;


//Photo properties
@property UIImage *imageDidSelected;

//Button properties
@property UIDynamicAnimator *dynamicAnimator;
@property UIButton *soundButton;
@property UIButton *photoButton;
@property UIButton *drawButton;
@property UIButton *mainButton;
@property BOOL areButtonsFanned;
@property int diameter;
@property int gap;

@end

