//
//  CameraViewController.m
//  TheWalls
//
//  Created by John McClelland on 6/15/15.
//  Copyright (c) 2015 machine^n. All rights reserved.
//

#import "CameraViewController.h"

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter]
                                    addObserver:self
                                       selector:@selector(updateLocation:) name:@"selectedLocation"
                                         object:nil];

    self.tableIsHidden = YES;
    self.containerView.hidden = YES;

    //Setup background and imageview
    self.view.backgroundColor = [UIColor paperColor];
    self.imagePreview = [[UIImageView alloc]initWithFrame:self.view.frame];
    self.imagePreview.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.imagePreview];

    //Setup UI buttons;
    self.cameraButton = [self createButtonWithTitle:@"photo" chooseColor:[UIColor limeColor] andPosition:200];
    [self.cameraButton addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];

    self.saveButton = [self createButtonWithTitle:@"save" chooseColor:[UIColor peonyColor] andPosition:100];
    [self.saveButton addTarget:self action:@selector(savePhoto:) forControlEvents:UIControlEventTouchUpInside];

    self.locationButton = [self createButtonWithTitle:@"loc" chooseColor:[UIColor hamlindigoColor] andPosition:300];
    [self.locationButton addTarget:self action:@selector(segueToLocationTable) forControlEvents:UIControlEventTouchUpInside];

    //Track if a picture has been taken, automatically call camera first time
    self.photoTaken = NO;
    [self takePhoto];
}

-(void)updateLocation:(NSNotification *)notification {
    if ([notification.object isKindOfClass:[FoursquareAPI class]]) {
        FoursquareAPI *item = [notification object];
        self.venueLabel.text = item.venueName;
        self.object.latitude = item.latitude;
        self.object.longitude = item.longitude;
        self.object.venueName = item.venueName;
        [self.object saveInBackground];

        [self segueToLocationTable];
    } else {
        NSLog(@"Error Transferring Location Data");
    }
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLocation:) name:@"Sent Location" object:nil];

}

#pragma mark - Foursquare API call & segue

- (void)segueToLocationTable {
    self.tableIsHidden = !self.tableIsHidden;
    self.containerView.hidden = self.tableIsHidden;
//    [self performSegueWithIdentifier:@"CameraToSelectLocation" sender:self];
}




-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"CameraToSelectLocation"]) {
        SelectLocationViewController *selectedLocationVC = segue.destinationViewController;
        CLLocation *location = self.userLocation;
        selectedLocationVC.userLocation = location;
    }
}


#pragma mark - Take photo, save photo, unwind

- (void)takePhoto {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    self.imageDidSelected = info[UIImagePickerControllerEditedImage];
    self.imagePreview.image = self.imageDidSelected;
    self.photoTaken = YES;
    [picker dismissViewControllerAnimated:YES completion:NULL];

}

- (IBAction)savePhoto:(id)sender {
    if (self.photoTaken == YES) {
    //Render and save image
        NSData *imageData = UIImagePNGRepresentation(self.imageDidSelected);
        Object *object = [Object new];
        object.file = [PFFile fileWithName:@"image.png" data:imageData];
        object.caption = @"Photo";
        object.latitude = self.userLocation.coordinate.latitude;
        object.longitude = self.userLocation.coordinate.longitude;
        [object setObject:[PFUser currentUser] forKey:@"createdBy"];
        self.object = object;

        [self.object saveInBackground];
    }
    //Perform segue back to RootViewController
    [self performSegueWithIdentifier:@"UnwindToRoot" sender:self];
}

#pragma mark - Create buttons
//Need to subclass each button - draw, photo, audio

- (UIButton *)createButtonWithTitle:(NSString *)title chooseColor:(UIColor *)color andPosition:(int)xPosition {
    CGRect frame = self.view.frame;
    int diameter = 65;
    int gap = 20;

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width - xPosition,frame.size.height - (diameter + gap), diameter, diameter)];
    button.layer.cornerRadius = button.bounds.size.width / 2;
    button.backgroundColor = color;
    button.layer.borderColor = button.titleLabel.textColor.CGColor;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];

    [self.view addSubview:button];
    return button;
}

- (IBAction)unwindToCamera:(UIStoryboardSegue *)segue {
}





@end
