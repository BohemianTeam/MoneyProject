//
//  CaptureSessionManager.h
//  Bars
//
//  Created by Trinh Hung on 3/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>
#define kImageCapturedSuccessfully @"imageCapturedSuccessfully"
@interface CaptureSessionManager : NSObject {
    
}
@property (retain) AVCaptureVideoPreviewLayer *previewLayer;
@property (retain) AVCaptureSession *captureSession;
@property (retain) AVCaptureStillImageOutput *stillImageOutput;
@property (nonatomic, retain) UIImage *stillImage;

- (void) addStillImageOutput;
- (void) captureStillImage;

- (void) addVideoPreviewLayer;
- (void) addVideoInput;
- (void) addVideoMultipleInput;

@end
