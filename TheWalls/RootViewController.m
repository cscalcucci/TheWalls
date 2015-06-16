//
//  ViewController.m
//  TheWalls
//
//  Created by John McClelland on 6/13/15.
//  Copyright (c) 2015 machine^n. All rights reserved.
//

#import "RootViewController.h"
#import "UIColor+CustomColors.h"
#import "Photo.h"

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface RootViewController () <MKMapViewDelegate, CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

//Location properties
@property CLLocationManager *locationManager;
@property CLLocation *userLocation;
@property MKMapView *primaryMapView;

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

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //UI setup
    self.view.backgroundColor = [UIColor paperColor];

    //Map
    [self locationManagerInit];
    [self initializeMap];

    //Buttons - to subclass
    self.areButtonsFanned = NO;
    self.dynamicAnimator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
    self.soundButton = [self createButtonWithTitle:@"S" chooseColor:[UIColor hamlindigoColor]];
    self.photoButton = [self createButtonWithTitle:@"P" chooseColor:[UIColor limeColor]];
    self.drawButton =  [self createButtonWithTitle:@"D" chooseColor:[UIColor peonyColor]];
    self.mainButton =  [self createButtonWithTitle:@"M" chooseColor:[UIColor peonyColor]];
    [self.mainButton addTarget:self action:@selector(fanButtons:) forControlEvents:UIControlEventTouchUpInside];
    [self.photoButton addTarget:self action:@selector(onPhotoButtonPressed) forControlEvents:UIControlEventTouchUpInside];

    //Future gestures stuff
    [self leftSwipeGestureInitialization];
    [self upSwipeGestureInitialization];
    [self downSwipeGestureInitialization];
    [self deviceOrientationNotificationInitialization];
}

- (void) viewDidAppear:(BOOL)animated {

}

#pragma mark - Map & Locations

- (void)locationManagerInit {
    self.locationManager = [CLLocationManager new];
    [self.locationManager requestWhenInUseAuthorization];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.delegate = self;

    [self.locationManager startUpdatingLocation];
}

- (void)initializeMap {
    self.primaryMapView = [[MKMapView alloc]initWithFrame:self.view.frame];
    self.primaryMapView.showsUserLocation = YES;
    self.primaryMapView.delegate = self;

    [self.view addSubview:self.primaryMapView];
}


-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"%@",error);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    for (CLLocation *location in locations) {
        if (location.verticalAccuracy < 1000 && location.horizontalAccuracy < 1000) {
            [self.locationManager stopUpdatingLocation];
            NSLog(@"3");
        }
        NSLog(@"2");
    }
    NSLog(@"1");
}

-(void)reverseGeoCode:(CLLocation *)location {
    CLGeocoder *geoCoder = [CLGeocoder new];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = placemarks.firstObject;
        self.userLocation = placemark.location;
    }];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    CLLocationCoordinate2D location = [userLocation coordinate];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location, 1000, 1000);
    [self.primaryMapView setRegion:region animated:YES];
}

#pragma mark - Swipe Gestures

//Initializations
- (void)rightSwipeGestureInitialization {
    UISwipeGestureRecognizer *rightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipeHandle:)];
    rightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [rightRecognizer setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:rightRecognizer];
}

- (void)leftSwipeGestureInitialization {
    UISwipeGestureRecognizer *leftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipeHandle:)];
    leftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [leftRecognizer setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:leftRecognizer];
}

- (void)upSwipeGestureInitialization {
    UISwipeGestureRecognizer *upRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(upSwipeHandle:)];
    upRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    [upRecognizer setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:upRecognizer];
}

- (void)downSwipeGestureInitialization {
    UISwipeGestureRecognizer *downRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(downSwipeHandle:)];
    downRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [downRecognizer setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:downRecognizer];
}

//Methods
- (void)rightSwipeHandle:(UISwipeGestureRecognizer*)gestureRecognizer {
    NSLog(@"rightSwipe");
}

- (void)leftSwipeHandle:(UISwipeGestureRecognizer*)gestureRecognizer {
    NSLog(@"leftSwipe");
}

- (void)upSwipeHandle:(UISwipeGestureRecognizer*)gestureRecognizer {
    NSLog(@"upSwipe");
}

- (void)downSwipeHandle:(UISwipeGestureRecognizer*)gestureRecognizer {
    NSLog(@"downSwipe");
}

#pragma mark - Device Orientation

//Initializations

- (void)deviceOrientationNotificationInitialization {
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(orientationChanged) name:UIDeviceOrientationDidChangeNotification object: nil];

}

- (void) orientationChanged {
    //Respond to changes
    NSLog(@"Shaked");
}

//Request to stop receiving acceleromator events and turn off accelerometer
- (void)deviceOrientationNotificationDemobilization {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [[UIDevice currentDevice]endGeneratingDeviceOrientationNotifications];
}

#pragma mark - Create buttons
//Need to subclass each button - draw, photo, audio

- (UIButton *)createButtonWithTitle:(NSString *)title chooseColor:(UIColor *)color {
    CGRect frame = self.view.frame;
    self.diameter = 65;
    self.gap = 20;

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width - (_diameter + (_gap * 1.6)),frame.size.height - (_diameter + _gap), _diameter, _diameter)];
    button.layer.cornerRadius = button.bounds.size.width / 2;
    button.backgroundColor = color;
    button.layer.borderColor = button.titleLabel.textColor.CGColor;
    [button setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];

    [self.view addSubview:button];
    return button;
}

#pragma mark - Main button

- (void)fanButtons:(id)sender{
    [self.dynamicAnimator removeAllBehaviors];
    if (self.areButtonsFanned) {
        [self fanIn];
    } else {
        [self fanOut];
        [self switchMainButtonState];
    }
    self.areButtonsFanned = !self.areButtonsFanned;
}

- (void)switchMainButtonState {
    //trying to change the state when pressed
    [self.mainButton.layer setBorderColor:(__bridge CGColorRef)([UIColor peonyColor])];
    [self.mainButton.layer setBorderWidth:5.0];
}

- (void)fanOut {
    UISnapBehavior *snapBehavior;
    CGPoint point;

    point = CGPointMake(self.mainButton.frame.origin.x - (_diameter * 0.75), self.mainButton.frame.origin.y + (_diameter/2));
    snapBehavior = [[UISnapBehavior alloc]initWithItem:self.soundButton snapToPoint:point];
    [self.dynamicAnimator addBehavior:snapBehavior];

    point = CGPointMake(self.mainButton.frame.origin.x - (_diameter * 2), self.mainButton.frame.origin.y + (_diameter/2));
    snapBehavior = [[UISnapBehavior alloc]initWithItem:self.photoButton snapToPoint:point];
    [self.dynamicAnimator addBehavior:snapBehavior];

    point = CGPointMake(self.mainButton.frame.origin.x - (_diameter * 3.25), self.mainButton.frame.origin.y + (_diameter/2));
    snapBehavior = [[UISnapBehavior alloc]initWithItem:self.drawButton snapToPoint:point];
    [self.dynamicAnimator addBehavior:snapBehavior];
}

- (void)fanIn {
    UISnapBehavior *snapBehavior;

    snapBehavior = [[UISnapBehavior alloc]initWithItem:self.soundButton snapToPoint:self.mainButton.center];
    [self.dynamicAnimator addBehavior:snapBehavior];

    snapBehavior = [[UISnapBehavior alloc]initWithItem:self.photoButton snapToPoint:self.mainButton.center];
    [self.dynamicAnimator addBehavior:snapBehavior];

    snapBehavior = [[UISnapBehavior alloc]initWithItem:self.drawButton snapToPoint:self.mainButton.center];
    [self.dynamicAnimator addBehavior:snapBehavior];
}

#pragma mark - Photo button

- (void)onPhotoButtonPressed {
    NSLog(@"Photo button pressed!");
    [self takePhoto];
}

- (void)takePhoto {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:^{
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    self.imageDidSelected = info[UIImagePickerControllerEditedImage];
    //Size image with button
    CGSize size = self.photoButton.frame.size;
    UIGraphicsBeginImageContext(size);
    [self.imageDidSelected drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.photoButton.backgroundColor = [UIColor colorWithPatternImage:newImage];
    //
    [picker dismissViewControllerAnimated:YES completion:^{
        NSLog(@"Woot!");
        [self savePhoto];
    }];

}

- (void) savePhoto{
    NSData *imageData = UIImagePNGRepresentation(self.imageDidSelected);
    Photo *newPhoto = [Photo new];
    newPhoto.imagePhoto = [PFFile fileWithName:@"image.png" data:imageData];
//    newPhoto.caption = @"Photo";
    newPhoto.latitude = self.userLocation.coordinate.latitude;
    newPhoto.longitude = self.userLocation.coordinate.longitude;
    [newPhoto setObject:[PFUser currentUser] forKey:@"createdBy"];
    [newPhoto saveInBackground];

    //Reset
//    self.photoPreview.image = nil;
//    self.captionText.text = nil;
}




@end
