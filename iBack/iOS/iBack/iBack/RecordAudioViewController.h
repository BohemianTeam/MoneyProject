//
//  RecordAudioViewController.h
//  iBack
//
//  Created by bohemian on 1/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface RecordAudioViewController : UIViewController<AVAudioRecorderDelegate>
{
    UIButton    *btnCancel;
    UIButton    *btnRecord;
    UIButton    *btnSave;
    UILabel     *lbStatus;
    UILabel     *lbTimer;
    
    AVAudioRecorder *audioRecorder;
    NSTimer         *timer;
    NSString        *filePath;
    BOOL            isRecording;
    NSInteger       secRecord;
}
@property(nonatomic, retain)UIButton    *btnCancel;
@property(nonatomic, retain)UIButton    *btnRecord;
@property(nonatomic, retain)UIButton    *btnSave;
@property(nonatomic, retain)NSString        *filePath;
@property(nonatomic, retain)IBOutlet UILabel     *lbTimer;
@property(nonatomic, retain)IBOutlet UILabel     *lbStatus;
@property(nonatomic, assign)BOOL            isRecording;
@property(nonatomic, assign)NSInteger       secRecord;

- (void)btnSavePressed;
- (void)btnRecordPressed;
- (void)btnCancelPressed;
@end
