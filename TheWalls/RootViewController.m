//
//  ViewController.m
//  TheWalls
//
//  Created by John McClelland on 6/13/15.
//  Copyright (c) 2015 machine^n. All rights reserved.
//

#import "RootViewController.h"

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //UI setup
    self.view.backgroundColor = [UIColor paperColor];

    //Map
    [self locationManagerInit];
    [self initializeMap];
    [self letThereBeMKAnnotation];

    //Buttons - to subclass
    self.areButtonsFanned = NO;
    self.dynamicAnimator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
    self.soundButton =  [self createButtonWithTitle:@"S" chooseColor:[UIColor hamlindigoColor]];
    self.photoButton =  [self createButtonWithTitle:@"P" chooseColor:[UIColor limeColor]];
    self.drawButton =   [self createButtonWithTitle:@"D" chooseColor:[UIColor peonyColor]];
    self.mainButton =   [self createButtonWithTitle:@"M" chooseColor:[UIColor peonyColor]];
    self.logoutButton = [self createLogoutButton];
    [self.mainButton addTarget:self action:@selector(fanButtons:) forControlEvents:UIControlEventTouchUpInside];
    [self.photoButton addTarget:self action:@selector(onCameraButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.logoutButton addTarget:self action:@selector(userLogout) forControlEvents:UIControlEventTouchUpInside];

    //Future gestures stuff
    [self leftSwipeGestureInitialization];
}

- (void) viewDidAppear:(BOOL)animated {

}

#pragma mark - Map & user location

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
            [self reverseGeoCode:locations.firstObject];
            [self.locationManager stopUpdatingLocation];
        }
    }
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

#pragma mark - Content location plots

- (void)letThereBeMKAnnotation {
    PFQuery *query = [Photo query];
    [query whereKey:@"createdBy" equalTo:[PFUser currentUser]];

    query.limit = 20;
    [query findObjectsInBackgroundWithBlock:^(NSArray *pictures, NSError *error) {
        if (!error) {
        }
        NSArray *array = [[NSArray alloc]initWithArray:pictures];
        for (Photo *photo in array) {
            Splat *annotation = [Splat new];
            annotation.coordinate = CLLocationCoordinate2DMake(photo.latitude, photo.longitude);
            [self.primaryMapView addAnnotation:annotation];
        }
    }];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isEqual:self.primaryMapView.userLocation]) {
        return nil;
    }
    MKAnnotationView *pin = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:nil];
    UIImage *image = [UIImage imageNamed:@"shape2"];
    CGSize scaleSize = CGSizeMake(48.0, 48.0);
    UIGraphicsBeginImageContextWithOptions(scaleSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, scaleSize.width, scaleSize.height)];
    UIImage * resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    pin.image = resizedImage;
    pin.canShowCallout =  NO;
    pin.userInteractionEnabled = YES;
//    pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    return pin;
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    [mapView deselectAnnotation:view.annotation animated:YES];
    self.splat = [Splat new];
    self.splat = view.annotation;
    [self performSegueWithIdentifier:@"RootToDetail" sender:self];
    NSLog(@"%@", self.splat);
}

#pragma mark - Swipe Gestures

//Initializations
- (void)leftSwipeGestureInitialization {
    UISwipeGestureRecognizer *leftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipeHandle:)];
    leftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [leftRecognizer setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:leftRecognizer];
}

//Methods
- (void)leftSwipeHandle:(UISwipeGestureRecognizer*)gestureRecognizer {
    NSLog(@"leftSwipe");
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

- (UIButton *)createLogoutButton {
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 100, 50, 100, 25)];
    button.backgroundColor = [UIColor redColor];
    button.tintColor = [UIColor whiteColor];
    button.userInteractionEnabled = YES;
    button.hidden = YES;
    [button setTitle:@"Logout" forState:UIControlStateNormal];
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

    self.logoutButton.hidden = NO;
}

- (void)fanIn {
    UISnapBehavior *snapBehavior;
    snapBehavior = [[UISnapBehavior alloc]initWithItem:self.soundButton snapToPoint:self.mainButton.center];
    [self.dynamicAnimator addBehavior:snapBehavior];
    snapBehavior = [[UISnapBehavior alloc]initWithItem:self.photoButton snapToPoint:self.mainButton.center];
    [self.dynamicAnimator addBehavior:snapBehavior];
    snapBehavior = [[UISnapBehavior alloc]initWithItem:self.drawButton snapToPoint:self.mainButton.center];
    [self.dynamicAnimator addBehavior:snapBehavior];

    self.logoutButton.hidden = YES;
}

#pragma mark - Logout;

- (void)userLogout {
    [PFUser logOutInBackground];
    [self refreshView];
}

-(void)refreshView {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Onboarding" bundle:[NSBundle mainBundle]];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
    [self presentViewController:viewController animated:NO completion:NULL];
//    [self viewDidLoad];
//    [self viewWillAppear:YES];

}

#pragma mark - Photo button & segue

- (void)onCameraButtonPressed {
    [self performSegueWithIdentifier:@"RootToCamera" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"RootToCamera"]) {
        CameraViewController *cameraVC = segue.destinationViewController;
        cameraVC.userLocation = self.userLocation;
        NSLog(@"%@", self.userLocation);
    } else if ([segue.identifier isEqualToString:@"RootToDetail"]) {
        DetailViewController *detailVC = segue.destinationViewController;
        detailVC.splat = self.splat;
    }
}

#pragma mark - Unwind methods

-(IBAction)unwindToRoot:(UIStoryboardSegue *)segue {
}

/*
//Size image with button
CGSize size = self.photoButton.frame.size;
UIGraphicsBeginImageContext(size);
[self.imageDidSelected drawInRect:CGRectMake(0, 0, size.width, size.height)];
UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
UIGraphicsEndImageContext();
self.photoButton.backgroundColor = [UIColor colorWithPatternImage:newImage];
//
*/





@end
