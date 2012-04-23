//
//  ImageCaptureViewController.m
//  Bars
//
//  Created by Trinh Hung on 3/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ImageCaptureViewController.h"
#import "CoreLocationController.h"

@interface ImageCaptureViewController (private)
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
@end

@implementation ImageCaptureViewController
@synthesize captureManager;
@synthesize scanningLabel;
@synthesize captureButton;
@synthesize delegate = _delegate;
@synthesize coreLocationManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) initWithBarLocation:(CLLocation *)location {
    self = [super init];
    
    if (self) {
        _barLocation = [location retain];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setCaptureManager:[[[CaptureSessionManager alloc] init] autorelease]];
    
    //for video capture
	//[[self captureManager] addVideoInput];
    //for image capture
    [[self captureManager] addStillImageOutput];
    
    [[self captureManager] addVideoPreviewLayer];
    
	CGRect layerRect = [[[self view] layer] bounds];
	[[[self captureManager] previewLayer] setBounds:layerRect];
	[[[self captureManager] previewLayer] setPosition:CGPointMake(CGRectGetMidX(layerRect),
                                                                  CGRectGetMidY(layerRect))];
	[[[self view] layer] addSublayer:[[self captureManager] previewLayer]];
    /*
     UIImageView *overlayImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"overlaygraphic.png"]];
     [overlayImageView setFrame:CGRectMake(30, 100, 260, 200)];
     [[self view] addSubview:overlayImageView];
     [overlayImageView release];
     
     UIButton *overlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
     [overlayButton setImage:[UIImage imageNamed:@"scanbutton.png"] forState:UIControlStateNormal];
     [overlayButton setFrame:CGRectMake(130, 320, 60, 30)];
     [overlayButton addTarget:self action:@selector(scanButtonPressed) forControlEvents:UIControlEventTouchUpInside];
     [[self view] addSubview:overlayButton];
     
     UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 50, 120, 30)];
     [self setScanningLabel:tempLabel];
     [tempLabel release];
     [scanningLabel setBackgroundColor:[UIColor clearColor]];
     [scanningLabel setFont:[UIFont fontWithName:@"Courier" size: 18.0]];
     [scanningLabel setTextColor:[UIColor redColor]];
     [scanningLabel setText:@"Scanning..."];
     [scanningLabel setHidden:YES];
     [[self view] addSubview:scanningLabel];	
     */
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelButton.frame = CGRectMake(8, 419, 74, 37);
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(didCancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton titleLabel].font = [UIFont boldSystemFontOfSize:15];
    [[self view] addSubview:cancelButton];
    
    self.captureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.captureButton.frame = CGRectMake(109, 417, 101, 41);
    [self.captureButton setTitle:@"Capture" forState:UIControlStateNormal];
    [self.captureButton setImage:[UIImage imageNamed:@"capture.png"] forState:UIControlStateNormal];
    [self.captureButton addTarget:self action:@selector(didCaptureImage) forControlEvents:UIControlEventTouchUpInside];
    [self.captureButton titleLabel].font =[UIFont boldSystemFontOfSize:15];
    [self.view addSubview:self.captureButton];
    self.captureButton.hidden = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveImageToPhotoAlbum) name:kImageCapturedSuccessfully object:nil];
    
	[[captureManager captureSession] startRunning];
}

- (void)saveImageToPhotoAlbum
{
    UIImageWriteToSavedPhotosAlbum([[self captureManager] stillImage], self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    [_delegate didFinishCaptureImage:[[self captureManager] stillImage]];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error != NULL) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Image couldn't be saved" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else {
        [[self scanningLabel] setHidden:YES];
    }
}

- (void) scanButtonPressed {
	[[self scanningLabel] setHidden:NO];
	[self performSelector:@selector(hideLabel:) withObject:[self scanningLabel] afterDelay:2];
}

- (void)hideLabel:(UILabel *)label {
	[label setHidden:YES];
    self.captureButton.hidden = NO;
}

- (void) didCaptureImage {
    if (self.coreLocationManager != nil) {
        [coreLocationManager release];
        self.coreLocationManager = nil;
    }
    coreLocationManager = [[CoreLocationController alloc] init];
    self.coreLocationManager.delegate = self;
    [[self.coreLocationManager locMgr] startUpdatingLocation];
    
    //[[self captureManager] captureStillImage];
}

#pragma CoreLocationController delegate
- (void) locationUpdate:(CLLocation *)location {
    NSLog(@"current location : %f -- %f", location.coordinate.latitude, location.coordinate.longitude);
    CLLocationDistance distance = [location distanceFromLocation:_barLocation];
    
    if (distance <= 10) {
        [[self captureManager] captureStillImage];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bars" message:@"You must stand in bar to capture" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

- (void)locationError:(NSError *)error {
    NSString *errorString;
    NSLog(@"error : %@", [error description]);
    switch([error code]) {
        case kCLErrorDenied:
            //Access denied by user
            errorString = @"Photos will be tagged with the location where they are taken";
            //Do something...
            break;
        case kCLErrorLocationUnknown:
            //Probably temporary...
            errorString = @"Location data unavailable";
            //Do something else...
            break;
        default:
            errorString = @"An unknown error has occurred";
            break;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"\"Bars\" Would Like to Use Your Current Location" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

#pragma UIAlertDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"%d", buttonIndex);
    if (buttonIndex == 1) {
        //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs://"]];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void) didCancelButtonClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [captureManager release], captureManager = nil;
    [scanningLabel release], scanningLabel = nil;
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
