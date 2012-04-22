//
//  ImageCaptureViewController.h
//  Bars
//
//  Created by Trinh Hung on 3/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CaptureSessionManager.h"
#import "CoreLocationController.h"

@protocol ImageCaptureViewControllerDelegate
- (void) didFinishCaptureImage:(UIImage *) img;
@end


@interface ImageCaptureViewController : UIViewController <AVCaptureVideoDataOutputSampleBufferDelegate>{
    id          _delegate;
    CLLocation  *_barLocation;
}
@property (retain) CaptureSessionManager *captureManager;
@property (retain) UILabel  *scanningLabel;
@property (retain) UIButton *captureButton;
@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) CoreLocationController *coreLocationManager;

- (id) initWithBarLocation:(CLLocation *) location;

@end
