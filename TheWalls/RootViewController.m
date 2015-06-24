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

    //Tab bar item setup
    self.tabBarItem.image = [[UIImage imageNamed:@"shape1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.tabBarItem.selectedImage = [[UIImage imageNamed:@"shape2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.tabBarItem.imageInsets = UIEdgeInsetsMake(-6, 0, 6, 0);

    //Map
    [self locationManagerInit];
    [self initializeMap];
    [self letThereBeMKAnnotation];


    //Future gestures stuff
    [self leftSwipeGestureInitialization];
}

- (void)viewDidAppear:(BOOL)animated {
    //Buttons - to subclass
    [self initializeButtons];
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
    if (self.locationCallAmt == 1) {
    CLLocationCoordinate2D location = [userLocation coordinate];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location, 1000, 1000);
    [self.primaryMapView setRegion:region animated:YES];
    }
    self.locationCallAmt++;
}

-(void)didTapCenterMapButton:(id)sender{
    CLLocationCoordinate2D location = self.userLocation.coordinate;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location, 1000, 1000);
    [self.primaryMapView setRegion:region animated:YES];
}

#pragma mark - Content location plots

- (void)letThereBeMKAnnotation {
    PFQuery *query = [Object query];
    [query orderByDescending:@"createdAt"];
    query.limit = 50;
    [query findObjectsInBackgroundWithBlock:^(NSArray *pictures, NSError *error) {
        if (!error) {
        }
        self.annotationArray = [[NSMutableArray alloc] init];
        self.objectArray = [[NSArray alloc]initWithArray:pictures];
        for (int i; i < self.objectArray.count; i++) {
            Object *object = self.objectArray[i];
            [object setObject:[NSString stringWithFormat:@"%i", i] forKey:@"indexPath" ];
            MKPointAnnotation *annotation = [MKPointAnnotation new];
            annotation.coordinate = CLLocationCoordinate2DMake(object.latitude, object.longitude);
            [self.annotationArray addObject:annotation];
            [self.primaryMapView addAnnotation:annotation];
        }
    }];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isEqual:self.primaryMapView.userLocation]) {
        return nil;
    }
    MKAnnotationView *pin = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:nil];
    int randomNumber = arc4random_uniform(3)+1;
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"shape%i",randomNumber]];

    CGSize scaleSize = CGSizeMake(24.0, 24.0);
    UIGraphicsBeginImageContextWithOptions(scaleSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, scaleSize.width, scaleSize.height)];
    UIImage * resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    pin.image = resizedImage;
    pin.canShowCallout =  NO;
    pin.userInteractionEnabled = YES;
    return pin;
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    if (![view.annotation isEqual:self.primaryMapView.userLocation]) {
        [mapView deselectAnnotation:view.annotation animated:YES];
        self.indexPath = [self.annotationArray indexOfObject:view.annotation];
        [self performSegueWithIdentifier:@"RootToDetail" sender:self];
    }
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

#pragma mark - Buttons to remain with Root

-(UIButton *)createCenterMapButton {

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 87, self.view.frame.size.height - 137, 45, 45)];
    button.layer.cornerRadius = button.bounds.size.width / 2;
    button.backgroundColor = [UIColor hamlindigoColor];
    button.layer.borderColor = button.titleLabel.textColor.CGColor;
    [button setImage:[UIImage imageNamed:@"icon-location"] forState:UIControlStateNormal];

    [self.view addSubview:button];
    return button;
}

- (UIButton *)createLogoutButton {
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width, 20, 65, 65)];
//    button.layer.cornerRadius = button.bounds.size.width / 2;
//    button.backgroundColor = [UIColor peonyColor];
//    button.tintColor = [UIColor paperColor];
//    button.userInteractionEnabled = YES;
//    [button setTitle:@"logout" forState:UIControlStateNormal];
//    [self.view addSubview:button];
    return button;
}

#pragma mark - Buttons and methods to subclass
//Need to subclass each button - draw, photo, audio

- (void)initializeButtons {
//    self.areButtonsFanned = NO;
//    self.dynamicAnimator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];

//    self.feedButton = [self createButtonWithTitle:@"feed" chooseColor:[UIColor peonyColor] andSize:45 andPositionX:-2];
//    self.mapButton = [self createButtonWithTitle:@"map" chooseColor:[UIColor marigoldColor] andSize:45 andPositionX:-1];
//    self.cameraButton = [self createButtonWithTitle:@"cam" chooseColor:[UIColor limeColor] andSize:65 andPositionX:0];
//    self.activityButton = [self createButtonWithTitle:@"act" chooseColor:[UIColor hamlindigoColor] andSize:45 andPositionX:1];
//    self.profileButton = [self createButtonWithTitle:@"pro" chooseColor:[UIColor peonyColor] andSize:45 andPositionX:2];
//
//
//    self.centerMapButton = [self createCenterMapButton];

//    self.logoutButton = [self createLogoutButton];
//    [self.mainButton addTarget:self action:@selector(fanButtons:) forControlEvents:UIControlEventTouchUpInside];
//    [self.photoButton addTarget:self action:@selector(onCameraButtonPressed) forControlEvents:UIControlEventTouchUpInside];
////    [self.logoutButton addTarget:self action:@selector(userLogout) forControlEvents:UIControlEventTouchUpInside];
//    [self.centerMapButton addTarget:self action:@selector(didTapCenterMapButton:) forControlEvents:UIControlEventTouchUpInside];
//    [self.feedButton addTarget:self action:@selector(onLeftButtonPressed) forControlEvents:UIControlEventTouchUpInside];
}

- (UIButton *)createButtonWithTitle:(NSString *)title chooseColor:(UIColor *)color andSize:(int)size andPositionX:(int)position {
//    int gap = 45;
//    int coefficient = (self.view.frame.size.width / 5) * position;
//    CGPoint center = self.view.center;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, size, size)];
//    button.center = CGPointMake(center.x + coefficient, self.view.frame.size.height - gap);
//    button.layer.cornerRadius = button.bounds.size.width / 2;
//    button.backgroundColor = color;
//    button.tintColor = [UIColor paperColor];
//    [button setTitle:title forState:UIControlStateNormal];
//    [self.view addSubview:button];
    return button;
}

- (void)fanButtons:(id)sender{
//    [self.dynamicAnimator removeAllBehaviors];
//    if (self.areButtonsFanned) {
//        [self fanIn];
//    } else {
//        [self fanOut];
//        [self switchMainButtonState];
//    }
//    self.areButtonsFanned = !self.areButtonsFanned;
}

- (void)switchMainButtonState {
    //trying to change the state when pressed
//    [self.mainButton.layer setBorderColor:(__bridge CGColorRef)([UIColor peonyColor])];
//    [self.mainButton.layer setBorderWidth:5.0];
}

- (void)fanOut {
//    UISnapBehavior *snapBehavior;
//    CGPoint point;
//    point = CGPointMake(self.mainButton.frame.origin.x - (_diameter * 0.75), self.mainButton.frame.origin.y + (_diameter/2));
//    snapBehavior = [[UISnapBehavior alloc]initWithItem:self.soundButton snapToPoint:point];
//    [self.dynamicAnimator addBehavior:snapBehavior];
//    point = CGPointMake(self.mainButton.frame.origin.x - (_diameter * 2), self.mainButton.frame.origin.y + (_diameter/2));
//    snapBehavior = [[UISnapBehavior alloc]initWithItem:self.photoButton snapToPoint:point];
//    [self.dynamicAnimator addBehavior:snapBehavior];
//    point = CGPointMake(self.mainButton.frame.origin.x - (_diameter * 3.25), self.mainButton.frame.origin.y + (_diameter/2));
//    snapBehavior = [[UISnapBehavior alloc]initWithItem:self.feedButton snapToPoint:point];
//    [self.dynamicAnimator addBehavior:snapBehavior];

//    [self loginButtonFlyIn:self.logoutButton];
}

//- (void)loginButtonFlyIn:(UIButton *)button {
//    CGRect movement = button.frame;
//    movement.origin.x = self.view.frame.size.width - 97;
//
//    [UIView animateWithDuration:0.2 animations:^{
//        button.frame = movement;
//    }];
//}
//
//- (void)loginButtonFlyOut:(UIButton *)button {
//    CGRect movement = button.frame;
//    movement.origin.x = self.view.frame.size.width;
//
//    [UIView animateWithDuration:0.2 animations:^{
//        button.frame = movement;
//    }];
//}

- (void)fanIn {
//    UISnapBehavior *snapBehavior;
//    snapBehavior = [[UISnapBehavior alloc]initWithItem:self.soundButton snapToPoint:self.mainButton.center];
//    [self.dynamicAnimator addBehavior:snapBehavior];
//    snapBehavior = [[UISnapBehavior alloc]initWithItem:self.photoButton snapToPoint:self.mainButton.center];
//    [self.dynamicAnimator addBehavior:snapBehavior];
//    snapBehavior = [[UISnapBehavior alloc]initWithItem:self.feedButton snapToPoint:self.mainButton.center];
//    [self.dynamicAnimator addBehavior:snapBehavior];

//    [self loginButtonFlyOut:self.logoutButton];
}

- (void)onCameraButtonPressed {

    [self performSegueWithIdentifier:@"RootToCamera" sender:self];
}

- (void)onLeftButtonPressed {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Feed" bundle:[NSBundle mainBundle]];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"FeedViewController"];
    [self presentViewController:viewController animated:YES completion:NULL];
}

#pragma mark - Logout;

- (void)userLogout {
    NSLog(@"pressed");
    [self refreshView];
    [PFUser logOutInBackground];
    [self performSegueWithIdentifier:@"UnwindToSelection" sender:self];
}

-(void)refreshView {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Onboarding" bundle:[NSBundle mainBundle]];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"SplashViewController"];
    [self presentViewController:viewController animated:NO completion:NULL];
}

#pragma mark - Photo button & segues

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"RootToCamera"]) {
        CameraViewController *cameraVC = segue.destinationViewController;
        cameraVC.userLocation = self.userLocation;
    } else if ([segue.identifier isEqualToString:@"RootToDetail"]) {
        DetailViewController *detailVC = segue.destinationViewController;
        detailVC.objectArray = self.objectArray;
        detailVC.indexPath = self.indexPath;
    }
}



#pragma mark - Unwind methods

-(IBAction)unwindToRoot:(UIStoryboardSegue *)segue {
}

@end
