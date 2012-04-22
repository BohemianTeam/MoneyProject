//
//  CaptureSessionManager.m
//  Bars
//
//  Created by Trinh Hung on 3/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CaptureSessionManager.h"
#import <ImageIO/ImageIO.h>

@implementation CaptureSessionManager
@synthesize previewLayer;
@synthesize captureSession;
@synthesize stillImage;
@synthesize stillImageOutput;

- (id) init {
    self = [super init];
    if (self) {
        [self setCaptureSession:[[AVCaptureSession alloc] init]];
    }
    
    return self;
}

- (void)addStillImageOutput
{
    [self setStillImageOutput:[[[AVCaptureStillImageOutput alloc] init] autorelease]];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil];
    [[self stillImageOutput] setOutputSettings:outputSettings];
    
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in [[self stillImageOutput] connections]) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) {
            break;
        }
    }
    
    [[self captureSession] addOutput:[self stillImageOutput]];
}

- (void)captureStillImage
{
	AVCaptureConnection *videoConnection = nil;
	for (AVCaptureConnection *connection in [[self stillImageOutput] connections]) {
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
    
	NSLog(@"about to request a capture from: %@", [self stillImageOutput]);
	[[self stillImageOutput] captureStillImageAsynchronouslyFromConnection:videoConnection
                                                         completionHandler:^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
                                                             CFDictionaryRef exifAttachments = CMGetAttachment(imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
                                                             if (exifAttachments) {
                                                                 NSLog(@"attachements: %@", exifAttachments);
                                                             } else {
                                                                 NSLog(@"no attachments");
                                                             }
                                                             NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
                                                             UIImage *image = [[UIImage alloc] initWithData:imageData];
                                                             [self setStillImage:image];
                                                             [image release];
                                                             [[NSNotificationCenter defaultCenter] postNotificationName:kImageCapturedSuccessfully object:nil];
                                                         }];
}

- (void) addVideoPreviewLayer {
    [self setPreviewLayer:[[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession]];
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
}

- (void) addVideoInput {
    AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if (videoDevice) {
        
        NSError *error = nil;
        AVCaptureDeviceInput *videoIn = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
        if (!error) {
            if ([self.captureSession canAddInput:videoIn]) {
                [self.captureSession addInput:videoIn];
            } else {
                NSLog(@"Couldn't add video input");
            }
        } else {
            NSLog(@"Couldn't create video input");
        }
    } else {
        NSLog(@"Couldn't create video capture device");
    }
}

- (void) addVideoMultipleInput {
    NSArray *devices = [AVCaptureDevice devices];
    
    AVCaptureDevice *frontCamera;
    AVCaptureDevice *backCamera;
    
    for (AVCaptureDevice *device in devices) {
        NSLog(@"Device name: %@", [device localizedName]);
        
        if ([device hasMediaType:AVMediaTypeVideo]) {
            
            if ([device position] == AVCaptureDevicePositionBack) {
                NSLog(@"Device position : back");
                backCamera = device;
            }
            else {
                NSLog(@"Device position : front");
                frontCamera = device;
            }
        }
    }
    
    NSError *error;
    
    AVCaptureDeviceInput *frontFacingCameraDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:frontCamera error:&error];
    if (!error) {
        if ([[self captureSession] canAddInput:frontFacingCameraDeviceInput])
            [[self captureSession] addInput:frontFacingCameraDeviceInput];
        else {
            NSLog(@"Couldn't add front facing video input");
        }
    }
}

- (void) dealloc {
    [[self captureSession] stopRunning];
    
    [self.previewLayer release];
    self.previewLayer = nil;
    
    [self.captureSession release];
    self.captureSession = nil;
    
    [self.stillImage release];
    self.stillImage = nil;
    
    [self.stillImageOutput release];
    self.stillImageOutput = nil;
    
    [super dealloc];
}

@end
