//
//  RecordVideoViewController.h
//  iBack
//
//  Created by bohemian on 2/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RevertMedia.h"
#import "AlertManager.h"
#import "MBProgressHUD.h"

@interface RecordVideoViewController : UIViewController<FileSelectionAlertDelegate, AVCaptureVideoDataOutputSampleBufferDelegate, AVAudioRecorderDelegate>
{
    AVCaptureSession    *session;    
    AVAudioRecorder     *audioRecorder;
    
    IBOutlet UIView     *cameraView;
    MBProgressHUD       *loadingView;
    IBOutlet UIButton   *btnSaveRecord;
    UILabel             *lblTimer;
    
    NSTimer             *timer;
    NSInteger           secRecord;
    int                 _index;
    
    BOOL                isRecording;
    size_t iwidth;
    size_t iheight;
}
@property(nonatomic, retain)IBOutlet UIView              *cameraView;
@property(nonatomic, retain)IBOutlet UIButton   *btnSaveRecord;

- (IBAction)pressedRecord:(id)sender;
- (IBAction)pressedSave:(id)sender;
- (IBAction)pressedCancel:(id)sender;

- (void)setupRecordAudio;
- (void)revertAudio;
@end

@interface UIImage (Extras)
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;
@end
