//
//  ViewController.m
//  testCamera
//
//  Created by John McClelland on 6/20/15.
//  Copyright (c) 2015 machine^n. All rights reserved.
//

#import "HybridCameraViewController.h"

@interface HybridCameraViewController () <AVCaptureFileOutputRecordingDelegate>

@end

@implementation HybridCameraViewController
AVCaptureSession *session;
AVCaptureStillImageOutput *imageOutput;
AVCaptureMovieFileOutput *movieOutput;
AVCaptureConnection *videoConnection;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self testDevices];
    self.view.backgroundColor = [UIColor blackColor];

    //Image preview
    self.previewView = [[UIImageView alloc]initWithFrame:self.view.frame];
    self.previewView.backgroundColor = [UIColor whiteColor];
    self.previewView.contentMode = UIViewContentModeScaleAspectFill;
    self.previewView.hidden = YES;
    [self.view addSubview:self.previewView];

    //Buttons
    self.button = [self createButtonWithTitle:@"REC" chooseColor:[UIColor redColor]];
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPressGesture:)];
    [self.button addGestureRecognizer:longPressRecognizer];
    [self.button addTarget:self action:@selector(captureImage) forControlEvents:UIControlEventTouchUpInside];

    self.saveButton = [self createSaveButton];
    [self.saveButton addTarget:self action:@selector(saveActions) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated {
    //Tests
    [self initializeAVItems];
    NSLog(@"%@", videoConnection);
    NSLog(@"%@", imageOutput.connections);
    NSLog(@"%@", imageOutput.description.debugDescription);
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
            self.previewView.image = image;
            self.previewView.hidden = NO;
        }
    }];
    [self saveButtonFlyIn:self.saveButton];
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

#pragma mark - Buttons

- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"Press");
        self.button.backgroundColor = [UIColor greenColor];
        [self captureVideo];
    }
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"Unpress");
        self.button.backgroundColor = [UIColor redColor];
        [movieOutput stopRecording];
    }
}

- (UIButton *)createButtonWithTitle:(NSString *)title chooseColor:(UIColor *)color {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(self.view.center.x, self.view.frame.size.height - 100, 85, 85)];
    button.layer.cornerRadius = button.bounds.size.width / 2;
    button.backgroundColor = color;
    button.tintColor = [UIColor whiteColor];
    [self.view addSubview:button];
    return button;
}

- (UIButton *)createSaveButton {
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width, self.view.frame.size.height - 100, 85, 85)];
    button.layer.cornerRadius = button.bounds.size.width / 2;
    button.backgroundColor = [UIColor greenColor];
    button.tintColor = [UIColor whiteColor];
    button.userInteractionEnabled = YES;
    [button setTitle:@"save" forState:UIControlStateNormal];
    [self.view addSubview:button];
    return button;
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
    [self saveButtonFlyOut:self.saveButton];
    self.previewView.image = nil;
    self.previewView.hidden = YES;
}

@end
