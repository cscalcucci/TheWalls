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

    //Foursquare API
    self.venueUrlCall = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?ll=%f,%f&oauth_token=N5Z3YJNLEWD4KIBIOB1C22YOPTPSJSL3NAEXVUMYGJC35FMP&v=20150617", self.userLocation.coordinate.latitude, self.userLocation.coordinate.longitude]];
    self.foursquareResults = [NSMutableArray new];
    [self retrieveFoursquareResults];

    //Setup background and imageview
    self.view.backgroundColor = [UIColor paperColor];
    self.imagePreview = [[UIImageView alloc]initWithFrame:self.view.frame];
    self.imagePreview.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.imagePreview];

    //Setup UI buttons;
    self.cameraButton = [self createButtonWithTitle:@"P" chooseColor:[UIColor limeColor] andPosition:250];
    [self.cameraButton addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];

    self.saveButton = [self createButtonWithTitle:@"S" chooseColor:[UIColor peonyColor] andPosition:100];
    [self.saveButton addTarget:self action:@selector(savePhoto:) forControlEvents:UIControlEventTouchUpInside];

    self.locationButton = [self createButtonWithTitle:@"L" chooseColor:[UIColor hamlindigoColor] andPosition:300];
    [self.locationButton addTarget:self action:@selector(segueToLocationTable) forControlEvents:UIControlEventTouchUpInside];

    //Track if a picture has been taken, automatically call camera first time
    self.photoTaken = NO;
    [self takePhoto];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
}

#pragma mark - Foursquare API call & segue

- (void)segueToLocationTable {
    [self performSegueWithIdentifier:@"CameraToSelectLocation" sender:self];
}


- (void)retrieveFoursquareResults {
    [FoursquareAPI retrieveFoursquareResults:self.venueUrlCall completion:^(NSArray *array) {
        self.foursquareResults = array;
        NSLog(@"%@", array);
        for (FoursquareAPI *item in self.foursquareResults) {
            NSLog(@"%@", item.venueName);
        }
    }];
}

- (void)setFoursquareResults:(NSArray *)foursquareResults {
    _foursquareResults = foursquareResults;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"CameraToLocation"]) {
        SelectLocationViewController *selectedLocationVC = segue.destinationViewController;
        selectedLocationVC.foursquareLocations = self.foursquareResults;
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


        [object saveInBackground];
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
    [button setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];

    [self.view addSubview:button];
    return button;
}

- (IBAction)unwindToCamera:(UIStoryboardSegue *)segue {
}





@end
