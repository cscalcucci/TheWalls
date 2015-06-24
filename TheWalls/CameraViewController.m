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

    //Location
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
//    [self testDevices];

    //Setup UI buttons;
    [self setupUIButtons];

    //Track if a picture has been taken, automatically call camera first time
    self.photoTaken = NO;

    //Swipe gesture initialization
    [self rightSwipeGestureInitialization];
    if (!self.object) {
        self.object = [Object new];

    }
}

- (void)setupUIButtons {
    self.cameraButton = [self createButtonWithTitle:@"" chooseColor:[UIColor limeColor] andPosition: 0];
    [self.cameraButton setImage:[UIImage imageNamed:@"icon-shutter"] forState:UIControlStateNormal];
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPressGesture:)];
    [self.cameraButton addGestureRecognizer:longPressRecognizer];
    [self.cameraButton addTarget:self action:@selector(captureImage) forControlEvents:UIControlEventTouchUpInside];

    self.saveButton = [self createButtonWithTitle:@"" chooseColor:[UIColor peonyColor] andPosition: 100];
    [self.saveButton setImage:[UIImage imageNamed:@"icon-exit"] forState:UIControlStateNormal];
    [self.saveButton addTarget:self action:@selector(saveActions) forControlEvents:UIControlEventTouchUpInside];

    self.locationButton = [self createButtonWithTitle:@"" chooseColor:[UIColor hamlindigoColor] andPosition:-100];
    [self.locationButton setImage:[UIImage imageNamed:@"icon-world"] forState:UIControlStateNormal];
    self.locationButton.userInteractionEnabled = YES;
    [self.locationButton addTarget:self action:@selector(segueToLocationTable) forControlEvents:UIControlEventTouchUpInside];

}

-(void)updateLocation:(NSNotification *)notification {
    if ([notification.object isKindOfClass:[FoursquareAPI class]]) {
        FoursquareAPI *item = [notification object];
        self.selectedVenue = [FoursquareAPI new];
        self.selectedVenue = item;
        self.venueLabel.text = item.venueName;
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
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"CameraToSelectLocation"]) {
        SelectLocationViewController *selectedLocationVC = segue.destinationViewController;
        CLLocation *location = self.userLocation;
        selectedLocationVC.userLocation = location;
    }
    if ([segue.identifier isEqualToString:@"CameraToRoot"]) {
    }
}

#pragma mark - Swipe Gesture and segue

//Initializations
- (void)rightSwipeGestureInitialization {
    UISwipeGestureRecognizer *rightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipeHandle:)];
    rightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [rightRecognizer setNumberOfTouchesRequired:1];
    [self.imagePreview addGestureRecognizer:rightRecognizer];
    [self.view addGestureRecognizer:rightRecognizer];

}

//Methods
- (void)rightSwipeHandle:(UISwipeGestureRecognizer*)gestureRecognizer {
    NSLog(@"rightSwipe");
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Feed" bundle:[NSBundle mainBundle]];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"FeedViewController"];
    [self presentViewController:viewController animated:YES completion:NULL];
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
    [self.saveButton setTitle:@"" forState:UIControlStateNormal];
    [self.saveButton setImage:[UIImage imageNamed:@"icon-save"] forState:UIControlStateNormal];

//    [self saveButtonFlyIn:self.saveButton];
    [self.view bringSubviewToFront:self.venueLabel];
}

#pragma mark - Video capture

- (void)captureVideo {
    NSLog(@"%@", movieOutput.connections);
    [[NSFileManager defaultManager] removeItemAtURL:[self outputURL] error:nil];

    videoConnection = [self connectionWithMediaType:AVMediaTypeVideo fromConnections:movieOutput.connections];

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
                [self performSegueWithIdentifier:@"CameraToRoot" sender:self];
            }
        }];
    } else {
        [self performSegueWithIdentifier:@"CameraToRoot" sender:self];
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
    [self performSegueWithIdentifier:@"CameraToRoot" sender:self];

}

-(void)reset {
    self.imagePreview.image = nil;
    self.imagePreview.hidden = YES;
}

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

- (UIButton *)createButtonWithTitle:(NSString *)title chooseColor:(UIColor *)color andPosition:(int)position {
    CGPoint center = self.view.center;
    int diameter = 65;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, diameter, diameter)];
    button.center = CGPointMake(center.x + position, self.view.frame.size.height - 100);
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
