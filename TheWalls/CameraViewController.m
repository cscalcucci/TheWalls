//
//  CameraViewController.m
//  TheWalls
//
//  Created by John McClelland on 6/15/15.
//  Copyright (c) 2015 machine^n. All rights reserved.
//

#import "CameraViewController.h"

@implementation CameraViewController
AVCaptureSession *session;
AVCaptureStillImageOutput *imageOutput;
AVCaptureMovieFileOutput *movieOutput;
AVCaptureConnection *videoConnection;

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter]
                                    addObserver:self
                                       selector:@selector(updateLocation:) name:@"selectedLocation"
                                         object:nil];



    //Setup background and imageview
    self.view.backgroundColor = [UIColor blackColor];
    self.view.backgroundColor = [UIColor paperColor];
    self.imagePreview = [[UIImageView alloc]initWithFrame:self.view.frame];
    self.imagePreview.contentMode = UIViewContentModeScaleAspectFill;
    self.imagePreview.hidden = YES;
    [self.view addSubview:self.imagePreview];

    //Setup container and table
    self.tableIsHidden = YES;
    self.containerView.hidden = YES;

    //Initialize preview layer and AV functions
    [self initializeAVItems];
    [self testDevices];

    //Setup UI buttons;
    self.cameraButton = [self createButtonWithTitle:@"photo" chooseColor:[UIColor limeColor] andPosition:200];
        UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPressGesture:)];
    [self.cameraButton addGestureRecognizer:longPressRecognizer];
    [self.cameraButton addTarget:self action:@selector(captureImage) forControlEvents:UIControlEventTouchUpInside];

//    self.saveButton = [self createButtonWithTitle:@"save" chooseColor:[UIColor peonyColor] andPosition:100];
//    [self.saveButton addTarget:self action:@selector(saveActions) forControlEvents:UIControlEventTouchUpInside];

    self.saveButton = [self createButtonWithTitle:@"cancel" chooseColor:[UIColor peonyColor] andPosition:100];
    [self.saveButton addTarget:self action:@selector(saveActions) forControlEvents:UIControlEventTouchUpInside];

    self.locationButton = [self createButtonWithTitle:@"loc" chooseColor:[UIColor hamlindigoColor] andPosition:300];
    self.locationButton.userInteractionEnabled = YES;
    [self.locationButton addTarget:self action:@selector(segueToLocationTable) forControlEvents:UIControlEventTouchUpInside];

    //Track if a picture has been taken, automatically call camera first time
    self.photoTaken = NO;
//    [self takePhoto];
    if (!self.object) {
        self.object = [Object new];

    }
}

-(void)updateLocation:(NSNotification *)notification {
    if ([notification.object isKindOfClass:[FoursquareAPI class]]) {
        FoursquareAPI *item = [notification object];

        self.selectedVenue = [FoursquareAPI new];
        self.selectedVenue = item;

//        self.venueLabel.text = item.venueName;

//        self.object.latitude = self.selectedVenue.latitude;
//        self.object.longitude = self.selectedVenue.longitude;
//        self.object.venueName = self.selectedVeue.venueName;
//        [self.object saveInBackground];

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
    [self.view bringSubviewToFront:self.containerView];
    [self.view bringSubviewToFront:self.cameraButton];
    [self.view bringSubviewToFront:self.locationButton];
    [self.view bringSubviewToFront:self.saveButton];

//    [self performSegueWithIdentifier:@"CameraToSelectLocation" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"CameraToSelectLocation"]) {
        SelectLocationViewController *selectedLocationVC = segue.destinationViewController;
        CLLocation *location = self.userLocation;
        selectedLocationVC.userLocation = location;
    }
}

#pragma mark - AV initialization

- (void)initializeAVItems {
    //Start session, input
    session = [AVCaptureSession new];
    if ([session canSetSessionPreset:AVCaptureSessionPresetHigh]) {
        session.sessionPreset = AVCaptureSessionPresetHigh;
    }
    AVCaptureDevice *inputDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];

    NSError *error;
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:inputDevice error:&error];
    if ([session canAddInput:deviceInput]) {
        [session addInput:deviceInput];
    } else {
        NSLog(@"%@", error);
    }

    AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:session];
    [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];

    //Layer preview
    CALayer *viewLayer = [[self view] layer];
    [viewLayer setMasksToBounds:YES];

    CGRect frame = self.view.frame;
    [previewLayer setFrame:frame];
    [viewLayer insertSublayer:previewLayer atIndex:0];

    //Image Output
    imageOutput = [AVCaptureStillImageOutput new];
    NSDictionary *imageOutputSettings = [[NSDictionary alloc]initWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey, nil];
    imageOutput.outputSettings = imageOutputSettings;

    //Video Output
    movieOutput = [AVCaptureMovieFileOutput new];

    [session addOutput:movieOutput];
    [session addOutput:imageOutput];
    [session startRunning];
}

- (void)testDevices {
    NSArray *devices = [AVCaptureDevice devices];
    for (AVCaptureDevice *device in devices) {
        NSLog(@"Device name: %@", [device localizedName]);
        if ([device hasMediaType:AVMediaTypeVideo]) {
            if ([device position] == AVCaptureDevicePositionBack) {
                NSLog(@"Device position : back");
            }
            else {
                NSLog(@"Device position : front");
            }
        }
    }
}

#pragma mark - Image capture

- (void)captureImage {
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in imageOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo]) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) {
            break;
        }
    }
    NSLog(@"Requesting capture from: %@", imageOutput);
    [imageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer != NULL) {
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            UIImage *image = [UIImage imageWithData:imageData];
            self.imageDidSelected = image;
            self.imagePreview.image = image;
            self.imagePreview.hidden = NO;
        }
    }];
    self.photoTaken = YES;
    [self.saveButton setTitle:@"Save" forState:UIControlStateNormal];
//    [self saveButtonFlyIn:self.saveButton];
    [self.view bringSubviewToFront:self.venueLabel];
}

#pragma mark - Video capture

- (void)captureVideo {
    NSLog(@"%@", movieOutput.connections);
    [[NSFileManager defaultManager] removeItemAtURL:[self outputURL] error:nil];

    videoConnection = [self connectionWithMediaType:AVMediaTypeVideo fromConnections:movieOutput.connections];

    /* This is where I'm having issues, I think... */
    [movieOutput startRecordingToOutputFileURL:[self outputURL] recordingDelegate:self];
}

- (AVCaptureConnection *)connectionWithMediaType:(NSString *)mediaType fromConnections:(NSArray *)connections {
    for (AVCaptureConnection *connection in connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:mediaType]) {
                return connection;
            }
        }
    }
    return nil;
}

#pragma mark - AVCaptureFileOutputRecordingDelegate

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error {
    if (!error) {
        //Do something
    } else {
        NSLog(@"Error: %@", [error localizedDescription]);
    }
}

#pragma mark - Recoding Destination URL

- (NSURL *)outputURL {
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:VIDEO_FILE];
    return [NSURL fileURLWithPath:filePath];
}

- (void)saveButtonFlyIn:(UIButton *)button {
    CGRect movement = button.frame;
    movement.origin.x = self.view.frame.size.width - 100;

    [UIView animateWithDuration:0.2 animations:^{
        button.frame = movement;
    }];
}

- (void)saveButtonFlyOut:(UIButton *)button {
    CGRect movement = button.frame;
    movement.origin.x = self.view.frame.size.width;

    [UIView animateWithDuration:0.2 animations:^{
        button.frame = movement;
    }];
}

#pragma mark - Save actions

- (void)saveActions {
    if (self.photoTaken) {

        NSData *imageData = UIImagePNGRepresentation(self.imageDidSelected);
        self.object.file = [PFFile fileWithName:@"image.png" data:imageData];
        self.object.latitude = self.selectedVenue.latitude;
        self.object.longitude = self.selectedVenue.longitude;
        self.object.venueName = self.selectedVenue.venueName;
        self.object.createdBy = [PFUser currentUser];

        [self.object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!succeeded) {
                [self uploadAlertWithTitle:@"Error" andMessage:@"Error Uploading Splat"];
            } else {
                [self uploadAlertWithTitle:@"Success" andMessage:@"Uploaded Splat"];

            }
        }];
    } else {
        [self dismissViewControllerAnimated:self completion:nil];
    }

}

-(void)uploadAlertWithTitle:(NSString *)title andMessage:(NSString *)message {

    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"OK", @"Cancel action")
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
//                                       if ([message isEqualToString:@"Uploaded Splat"]) {
//                                           [self reset];
//                                       }
                                       [self reset];
                                       NSLog(@"Cancel action");
                                   }];
    [alertVC addAction:cancelAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

-(void)reset {
    self.imagePreview.image = nil;
    self.imagePreview.hidden = YES;
}

/*
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
*/
#pragma mark - Gesture recognizer

- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"Press");
        self.cameraButton.backgroundColor = [UIColor greenColor];
//        [self captureVideo];
    }
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"Unpress");
        self.cameraButton.backgroundColor = [UIColor redColor];
//        [movieOutput stopRecording];
    }
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
