//
//  RecordAudioViewController.m
//  iBack
//
//  Created by bohemian on 1/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RecordAudioViewController.h"
#import "AlertManager.h"
#import "FileHelper.h"
#import "PCMMixer.h"

@implementation RecordAudioViewController
@synthesize btnSave;
@synthesize btnCancel;
@synthesize btnRecord;
@synthesize lbTimer;
@synthesize lbStatus;
@synthesize isRecording;
@synthesize secRecord;
@synthesize filePath;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    btnCancel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnCancel setFrame:CGRectMake(5, 410, 72, 37)];
    [btnCancel setTitle:@"Cancel" forState:UIControlStateNormal];
    [btnCancel addTarget:self action:@selector(btnCancelPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnCancel];
    
    btnRecord = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnRecord setFrame:CGRectMake(125, 410, 72, 37)];
    [btnRecord setTitle:@"Record" forState:UIControlStateNormal];
    [btnRecord setImage:[UIImage imageNamed:@"Record"] forState:UIControlStateNormal];
    [btnRecord addTarget:self action:@selector(btnRecordPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnRecord];
    
    btnSave = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnSave setFrame:CGRectMake(242, 410, 72, 37)];
    [btnSave setTitle:@"Save" forState:UIControlStateNormal];
    [btnSave setImage:[UIImage imageNamed:@"Save"] forState:UIControlStateNormal];
    [btnSave addTarget:self action:@selector(btnSavePressed) forControlEvents:UIControlEventTouchUpInside];
    [btnSave setEnabled:NO];
    [self.view addSubview:btnSave];
    
    lbTimer.text = @"00:00:00";
    lbStatus.text = @"Stopped";
    isRecording = false;
    secRecord = 0;
}
- (void)handleTimer
{
    secRecord++;
    NSLog(@"Time record: %d", secRecord);
    
    int hours =  secRecord / 3600;
    int minutes = ( secRecord - hours * 3600 ) / 60; 
    int seconds = secRecord - hours * 3600 - minutes * 60;
    lbTimer.text = [NSString stringWithFormat:@"%.2d:%.2d:%.2d", hours, minutes, seconds];
}
- (void)btnSavePressed
{
    if(filePath != nil)
    {
        AlertManager *alert = [AlertManager sharedManager]; 
        alert.fileSelectionDelegate = self;
        alert.type = aPickName;
        [alert showAlert];
    }else{
        [self dismissModalViewControllerAnimated:YES];
    }
}
- (void)btnCancelPressed
{
    if(filePath != nil){
        NSError *err = nil;
        NSURL *url = [NSURL fileURLWithPath:filePath];
        
        NSData *audioData = [NSData dataWithContentsOfFile:[url path] options: 0 error:&err];
        if(audioData)
        {
            NSFileManager *fm = [NSFileManager defaultManager];
            [fm removeItemAtPath:[url path] error:&err];
        }
        
        [filePath release];
        filePath = nil;
    }
    [self dismissModalViewControllerAnimated:YES];
}
- (void)btnRecordPressed
{
   
    if (isRecording) {
         NSLog(@"Stop Recording");
        [audioRecorder stop];
        [audioRecorder release];
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        
        audioRecorder = nil;
        lbStatus.text = @"Stopped";
        [timer invalidate];
        secRecord = 0;
        [btnSave setEnabled:YES];
    }else{
         NSLog(@"Start Recording");
        if(audioRecorder!=nil)
        {
            [audioRecorder release];
            audioRecorder = nil;
        }
        
        //init audio with record capability
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryRecord error:nil];
        
        NSMutableDictionary *recordSettings = [[[NSMutableDictionary alloc] initWithCapacity:10] autorelease];
        
        
        // We can use kAudioFormatAppleIMA4 (4:1 compression) or kAudioFormatLinearPCM for nocompression
        [recordSettings setValue :[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
        
        // We can use 44100, 32000, 24000, 16000 or 12000 depending on sound quality
        [recordSettings setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
        
        // We can use 2(if using additional h/w) or 1 (iPhone only has one microphone)
        [recordSettings setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
        
        //create file record
        NSError *err = nil;
        NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
                                                                            NSUserDomainMask, YES) lastObject];
        
        NSTimeInterval milisecondedDate = ([[NSDate date] timeIntervalSince1970]);
        NSString *fileName =[NSString stringWithFormat:@"%.0f.caf", milisecondedDate];
        filePath = [[NSString alloc] initWithString:[documentsDirectory stringByAppendingPathComponent:fileName]];
        NSLog(@"recorderFilePath: %@",filePath);
        
        NSURL *url = [NSURL fileURLWithPath:filePath];
        
        err = nil;
        
        NSData *audioData = [NSData dataWithContentsOfFile:[url path] options: 0 error:&err];
        if(audioData)
        {
            NSFileManager *fm = [NSFileManager defaultManager];
            [fm removeItemAtPath:[url path] error:&err];
        }
        
        err = nil;
        audioRecorder = [[ AVAudioRecorder alloc] initWithURL:url settings:recordSettings error:&err];
        if(!audioRecorder){
            NSLog(@"recorder: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
            UIAlertView *alert =
            [[UIAlertView alloc] initWithTitle: @"Warning"
                                       message: [err localizedDescription]
                                      delegate: nil
                             cancelButtonTitle:@"OK"
                             otherButtonTitles:nil];
            [alert show];
            [alert release];
            return;
        }
        
        //prepare to record
        [audioRecorder setDelegate:self];
        [audioRecorder prepareToRecord];
        audioRecorder.meteringEnabled = YES;
        
        BOOL audioHWAvailable = audioSession.inputIsAvailable;
        if (! audioHWAvailable) {
            UIAlertView *cantRecordAlert =
            [[UIAlertView alloc] initWithTitle: @"Warning"
                                       message: @"Audio input hardware not available"
                                      delegate: nil
                             cancelButtonTitle:@"OK"
                             otherButtonTitles:nil];
            [cantRecordAlert show];
            [cantRecordAlert release]; 
            return;
        }
        
        // start recording
        [audioRecorder record];
        
        lbStatus.text = @"Recording...";
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(handleTimer) userInfo:nil repeats:YES];
    }
    
    isRecording = !isRecording;
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (void)dealloc
{
    [lbTimer release];
    [lbStatus release];
    [audioRecorder release];
    [filePath release];
}
#pragma mark - FileSelectionAlert Delegate
- (void)revertDone
{
    [loadingView removeFromSuperview];
    [loadingView release];
    loadingView = nil;
    
    NSFileManager *fm = [NSFileManager defaultManager];
    [fm removeItemAtPath:filePath error:nil];
    [self dismissModalViewControllerAnimated:YES];
    
    [filePath release];
    filePath = nil;
}
- (void)revertAudio:(NSString*)name
{
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    NSString *newpath = [FileHelper documentsPath:[name stringByAppendingString:@".caf"]];
    CFURLRef desPath = (CFURLRef)[NSURL fileURLWithPath:newpath];       
    CFURLRef srcPath = (CFURLRef)[NSURL fileURLWithPath:filePath];
    
    [PCMMixer reverseAudioFrom:srcPath To:desPath];
    
    [self performSelectorOnMainThread:@selector(revertDone) withObject:nil waitUntilDone:YES];
    [pool release];
}
- (void)pickName:(NSString*)name
{
    if(filePath != nil)
    {
        loadingView = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:loadingView];
        loadingView.labelText = @"Processing...";
        [loadingView show:YES];
        
        
        
        [NSThread detachNewThreadSelector:@selector(revertAudio:) toTarget:self withObject:name];

        
    }else
        [self dismissModalViewControllerAnimated:YES];
}
@end
