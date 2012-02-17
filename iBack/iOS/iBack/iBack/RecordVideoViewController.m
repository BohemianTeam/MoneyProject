//
//  RecordVideoViewController.m
//  iBack
//
//  Created by bohemian on 2/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RecordVideoViewController.h"
#import "AlertManager.h"
#import "FileHelper.h"
#import "PCMMixer.h"

@interface RecordVideoViewController(private)
- (void)CompileFilesToMakeMovie;
- (CVPixelBufferRef)newPixelBufferFromCGImage:(CGImageRef)image;
- (void)writeImagesToMovieAtPath:(NSString *)path withSize:(CGSize)size;
- (void)startCameraCapture;
- (void)stopCameraCapture;
- (void)revertVideoWithPath:(NSString*)path;
@end

@implementation RecordVideoViewController
@synthesize btnSaveRecord;
@synthesize cameraView;

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
    
    NSString *movTempPath = [FileHelper documentsPath:VIDEO_FOLDER_TEMP];
    [FileHelper deleteAllFileAtDirectoryPath:movTempPath];
    
    NSString *imgTempPath = [FileHelper documentsPath:IMG_FOLDER_TEMP];
    [FileHelper deleteAllFileAtDirectoryPath:imgTempPath];
    [self startCameraCapture];
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
    [session release];
    [audioRecorder release];
    [lblTimer release];
    //[timer release];
    [super dealloc];
}
#pragma mark - Button Events
- (IBAction)pressedCancel:(id)sender
{
    [audioRecorder stop];
    [audioRecorder release];
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    audioRecorder = nil;
    
    [self stopCameraCapture];
    [self dismissModalViewControllerAnimated:YES];
}
- (IBAction)pressedRecord:(id)sender
{
   if(!isRecording)
   {
       [btnSaveRecord setEnabled:NO];
       [self setupRecordAudio];
       // Set the output
       AVCaptureVideoDataOutput* videoOutput = [[AVCaptureVideoDataOutput alloc] init];
       
       // create a queue to run the capture on
       dispatch_queue_t captureQueue=dispatch_queue_create("catpureQueue", NULL);
       
       // setup our delegate
       [videoOutput setSampleBufferDelegate:self queue:captureQueue];
       
       // configure the pixel format
       videoOutput.videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA], (id)kCVPixelBufferPixelFormatTypeKey,
                                    nil];

       [session addOutput:videoOutput];
       
       // start recording
       [audioRecorder record];
       timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(handleTimer) userInfo:nil repeats:YES];
       secRecord = 0;
       lblTimer.hidden = NO;
   }else
   {
       
       [audioRecorder stop];
       [audioRecorder release];
       AVAudioSession *audioSession = [AVAudioSession sharedInstance];
       [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
       audioRecorder = nil;
       
       NSLog(@"Stop Recording");
       [self stopCameraCapture];
       [btnSaveRecord setEnabled:YES];
       [timer invalidate];
       secRecord = 0;
       
       
   }
    isRecording = !isRecording;
}
- (IBAction)pressedSave:(id)sender
{
    AlertManager *alert = [AlertManager sharedManager]; 
    alert.fileSelectionDelegate = self;
    alert.type = aPickName;
    [alert showAlert];
    
    
}
- (void)revertAudio
{
    NSString *newpath = [FileHelper documentsPath:[VIDEO_FOLDER_TEMP stringByAppendingFormat:@"/%@",AUDIO_FILENAME_TEMP1]];
    CFURLRef desPath = (CFURLRef)[NSURL fileURLWithPath:newpath]; 
    NSString *oldPath = [FileHelper documentsPath:[VIDEO_FOLDER_TEMP stringByAppendingFormat:@"/%@",AUDIO_FILENAME_TEMP]];
    CFURLRef srcPath = (CFURLRef)[NSURL fileURLWithPath:oldPath];
    
    [PCMMixer reverseAudioFrom:srcPath To:desPath];
}
-(void) revertVideoWithPath:(NSString*)path
{
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    [self revertAudio];
    [self writeImagesToMovieAtPath:path withSize:CGSizeMake(iwidth, iheight)];
    
    [pool release];
}

#pragma mark Revert Video
- (void)handleTimer
{
    secRecord++;
    NSLog(@"Time record: %d", secRecord);
    
    int hours =  secRecord / 3600;
    int minutes = ( secRecord - hours * 3600 ) / 60; 
    int seconds = secRecord - hours * 3600 - minutes * 60;
    lblTimer.text = [NSString stringWithFormat:@"%.2d:%.2d:%.2d", hours, minutes, seconds];
}
- (void)setupRecordAudio
{
    //NSLog(@"Start Recording");
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
    
    NSString *audioTempPath = [FileHelper documentsPath:[VIDEO_FOLDER_TEMP stringByAppendingFormat:@"/%@",AUDIO_FILENAME_TEMP]];

    NSLog(@"recorderFilePath: %@",audioTempPath);
    
    NSURL *url = [NSURL fileURLWithPath:audioTempPath];
    
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
    
    
    
    //timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(handleTimer) userInfo:nil repeats:YES];
}
- (void)revertDone
{
    [loadingView removeFromSuperview];
    [loadingView release];
    loadingView = nil;
    [self dismissModalViewControllerAnimated:YES];
}
-(void)CompileFilesToMakeMovie: (NSString*)path{
    NSLog(@"Compile File at %@", path);
    AVMutableComposition* mixComposition = [AVMutableComposition composition];
    
    NSString* audio_inputFilePath = [FileHelper documentsPath:[VIDEO_FOLDER_TEMP stringByAppendingFormat:@"/%@",AUDIO_FILENAME_TEMP1]];
    //NSString* audio_inputFileName = [FileHelper bundlePath:@"audioTest.caf"];
    //NSString* audio_inputFilePath = [FileHelper bundlePath:audio_inputFileName];
    NSURL*    audio_inputFileUrl = [NSURL fileURLWithPath:audio_inputFilePath];
    NSLog(@"Audio File at %@", audio_inputFilePath);
    
    NSString* video_inputFilePath = [FileHelper documentsPath:[VIDEO_FOLDER_TEMP stringByAppendingFormat:@"/%@",VIDEO_FILENAME_TEMP]];
    NSURL*    video_inputFileUrl = [NSURL fileURLWithPath:video_inputFilePath];
    
    NSURL*    outputFileUrl = [NSURL fileURLWithPath:path];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) 
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    
    
    
    CMTime nextClipStartTime = kCMTimeZero;
    
    AVURLAsset* videoAsset = [[AVURLAsset alloc]initWithURL:video_inputFileUrl options:nil];
    CMTimeRange video_timeRange = CMTimeRangeMake(kCMTimeZero,videoAsset.duration);
    AVMutableCompositionTrack *a_compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    [a_compositionVideoTrack insertTimeRange:video_timeRange ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:nextClipStartTime error:nil];
    
    //nextClipStartTime = CMTimeAdd(nextClipStartTime, a_timeRange.duration);
    
    AVURLAsset* audioAsset = [[AVURLAsset alloc]initWithURL:audio_inputFileUrl options:nil];
    CMTimeRange audio_timeRange = CMTimeRangeMake(kCMTimeZero, audioAsset.duration);
    AVMutableCompositionTrack *b_compositionAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    [b_compositionAudioTrack insertTimeRange:audio_timeRange ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:nextClipStartTime error:nil];
    
    
    AVAssetExportSession* _assetExport = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];   
    _assetExport.outputFileType = @"com.apple.quicktime-movie";
    _assetExport.outputURL = outputFileUrl;
    
    [_assetExport exportAsynchronouslyWithCompletionHandler:
     ^(void ) {
         //[self saveVideoToAlbum:outputFilePath];
         
     }       
     ];
    
    //done
    [self performSelectorOnMainThread:@selector(revertDone) withObject:nil waitUntilDone:YES];
    
}
- (CVPixelBufferRef) newPixelBufferFromCGImage: (CGImageRef) image
{
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGImageCompatibilityKey,
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGBitmapContextCompatibilityKey,
                             nil];
    CVPixelBufferRef pxbuffer = NULL;
    
    
    
    
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault, iwidth,
                                          iheight, kCVPixelFormatType_32ARGB, (CFDictionaryRef) options, 
                                          &pxbuffer);
    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
    
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    NSParameterAssert(pxdata != NULL);
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pxdata, iwidth,
                                                 iheight, 8, 4*iwidth, rgbColorSpace, 
                                                 kCGImageAlphaNoneSkipFirst);
    NSParameterAssert(context);
//    CGAffineTransform flipVertical = CGAffineTransformMake(0.0, -1.0, -1.0, 0.0, iheight, iwidth);
//    CGContextConcatCTM(context, flipVertical);
    //CGContextConcatCTM(context, CGAffineTransformIdentity);
    CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(image), 
                                           CGImageGetHeight(image)), image);
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    
    return pxbuffer;
}
-(void) writeImagesToMovieAtPath:(NSString *)path withSize:(CGSize)size
{
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    NSString *documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSArray *imgFiles = [fileMgr contentsOfDirectoryAtPath:[NSString stringWithFormat:@"%@/%@", documentsDirectoryPath, IMG_FOLDER_TEMP] error:nil];
    NSString *movPathTemp = [FileHelper documentsPath:[VIDEO_FOLDER_TEMP stringByAppendingFormat:@"/%@",VIDEO_FILENAME_TEMP]];
    
    NSArray *dirContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectoryPath error:nil];
    for (NSString *tString in dirContents) {
        if ([tString isEqualToString:VIDEO_FILENAME_TEMP]) 
        {
            [[NSFileManager defaultManager]removeItemAtPath:[NSString stringWithFormat:@"%@/%@",documentsDirectoryPath,tString] error:nil];
            
        }
    }
    
    NSLog(@"Write Started");
    
    NSError *error = nil;
    
    AVAssetWriter *videoWriter = [[AVAssetWriter alloc] initWithURL:
                                  [NSURL fileURLWithPath:movPathTemp] fileType:AVFileTypeMPEG4
                                                              error:&error];    
    NSParameterAssert(videoWriter);
    
    NSDictionary *videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                   AVVideoCodecH264, AVVideoCodecKey,
                                   [NSNumber numberWithInt:size.width], AVVideoWidthKey,
                                   [NSNumber numberWithInt:size.height], AVVideoHeightKey,
                                   nil];
    
    
    AVAssetWriterInput* videoWriterInput = [[AVAssetWriterInput
                                             assetWriterInputWithMediaType:AVMediaTypeVideo
                                             outputSettings:videoSettings] retain];
    
    
    
    
    AVAssetWriterInputPixelBufferAdaptor *adaptor = [AVAssetWriterInputPixelBufferAdaptor
                                                     assetWriterInputPixelBufferAdaptorWithAssetWriterInput:videoWriterInput
                                                     sourcePixelBufferAttributes:nil];
    
    
    
    
    
    NSParameterAssert(videoWriterInput);
    
    NSParameterAssert([videoWriter canAddInput:videoWriterInput]);
    videoWriterInput.expectsMediaDataInRealTime = YES;
    [videoWriter addInput:videoWriterInput];
    //Start a session:
    [videoWriter startWriting];
    [videoWriter startSessionAtSourceTime:kCMTimeZero];
    
    
    //Video encoding
    
    CVPixelBufferRef buffer = NULL;
    
    //convert uiimage to CGImage.
    
    int frameCount = 0;
    int sumImg = [imgFiles count];
    NSLog(@"write--%d", sumImg);
    for(int i = 0; i<sumImg; i++)
    {
        //NSLog(@"%d--%d", i, [imgFiles count]);
        NSString *imgPath = [NSString stringWithFormat:[NSString stringWithFormat:@"%@/%@/%@%d.jpg", documentsDirectoryPath, IMG_FOLDER_TEMP, IMG_FILENAME_TEMP,sumImg-i-1]];
        
        UIImage *img = [UIImage imageWithContentsOfFile:imgPath];
        if(img != nil)
            NSLog(@"%d--%d", sumImg, i);
        else
            NSLog(@"%@", imgPath);
        //imageView.image = img;
        buffer = [self newPixelBufferFromCGImage:[img CGImage]];
        
        
        BOOL append_ok = NO;
        int j = 0;
        while (!append_ok && j < 30) 
        {
            if (adaptor.assetWriterInput.readyForMoreMediaData) 
            {
                printf("appending %d attemp %d\n", frameCount, j);
                
                CMTime frameTime = CMTimeMake(frameCount,(int32_t) 10);
                
                append_ok = [adaptor appendPixelBuffer:buffer withPresentationTime:frameTime];
                CVPixelBufferPoolRef bufferPool = adaptor.pixelBufferPool;
                NSParameterAssert(bufferPool != NULL);
                
                [NSThread sleepForTimeInterval:0.05];
            } 
            else 
            {
                printf("adaptor not ready %d, %d\n", frameCount, j);
                [NSThread sleepForTimeInterval:0.1];
            }
            j++;
        }
        if (!append_ok) {
            printf("error appending image %d times %d\n", frameCount, j);
        }
        frameCount++;
        CVBufferRelease(buffer);
        
        //remove img file
        //[Utilities removeFileAtPath:imgPath];
    }
    
    
    [videoWriterInput markAsFinished];
    [videoWriter finishWriting];
    
    [videoWriterInput release];
    [videoWriter release];
    
    //[m_PictArray removeAllObjects];
    
    NSLog(@"Write Ended");
    [self CompileFilesToMakeMovie:path];
    
    [pool release];
}
#pragma mark -
#pragma mark Camera Capture Control
-(void) startCameraCapture {
    //remove all file in temp directory (documents) if existed
    NSString  *directory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/imgFolder"];
    [FileHelper deleteAllFileAtDirectoryPath:directory];
    
	// start capturing frames
	// Create the AVCapture Session
	session = [[AVCaptureSession alloc] init];
    
    // create a preview layer to show the output from the camera
	AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:session];
	previewLayer.frame = CGRectMake(0, -30, 320, 460);//cameraView.frame;
	[cameraView.layer addSublayer:previewLayer];

	// Get the default camera device
    NSError *error = nil;
	AVCaptureDevice* camera = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
	
	// Create a AVCaptureInput with the camera device
    
	AVCaptureInput* cameraInput = [[AVCaptureDeviceInput alloc] initWithDevice:camera error:&error];
	if (cameraInput == nil) {
		NSLog(@"Error to create camera capture:%@",error);
	}
	    
	// and the size of the frames we want
	[session setSessionPreset:AVCaptureSessionPresetMedium];
    
	// Add the input and output
	[session addInput:cameraInput];
//	[session addOutput:videoOutput];
	
	// Start the session
	[session startRunning];	
	
    lblTimer = [[UILabel alloc] initWithFrame:CGRectMake(250, 20, 150, 30)];
    lblTimer.backgroundColor = [UIColor clearColor];
    lblTimer.text = @"00:00:00";
    lblTimer.textColor = [UIColor whiteColor];
    lblTimer.hidden = YES;
    [self.view addSubview:lblTimer];
}
// Create a UIImage from sample buffer data
- (void) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer 
{
    // Get a CMSampleBuffer's Core Video image buffer for the media data
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer); 
    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer, 0); 
    
    // Get the number of bytes per row for the pixel buffer
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer); 
    
    // Get the number of bytes per row for the pixel buffer
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer); 
    // Get the pixel buffer width and height
    iwidth = CVPixelBufferGetWidth(imageBuffer); 
    iheight = CVPixelBufferGetHeight(imageBuffer); 
    
    // Create a device-dependent RGB color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB(); 
    
    // Create a bitmap graphics context with the sample buffer data
    CGContextRef context = CGBitmapContextCreate(baseAddress, iwidth, iheight, 8, 
                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst); 
    // Create a Quartz image from the pixel data in the bitmap graphics context
    CGImageRef quartzImage = CGBitmapContextCreateImage(context); 
    // Unlock the pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    // Free up the context and color space
    CGContextRelease(context); 
    CGColorSpaceRelease(colorSpace);
    
    // Create an image object from the Quartz image
    UIImage *image = [[UIImage alloc] initWithCGImage:quartzImage scale:1.0 orientation:UIImageOrientationRight];
    UIImage *tempImg = [image imageByScalingAndCroppingForSize:CGSizeMake(image.size.height, image.size.width)];
    NSString  *pngPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@%d.jpg", IMG_FOLDER_TEMP,IMG_FILENAME_TEMP,_index]];
    NSLog(@"Index finish: %i",_index);
    
    //save image to directorry document
    [UIImageJPEGRepresentation(tempImg, 0.9f) writeToFile:pngPath atomically:YES];
    
    // Release the Quartz image
    CGImageRelease(quartzImage);
    [image release];
}
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    
    [self imageFromSampleBuffer:sampleBuffer];
    _index ++;
}


-(void) stopCameraCapture {
	[session stopRunning];
	[session release];
	session=nil;
}
#pragma mark - FileSelectionAlert Delegate
- (void)pickName:(NSString*)name
{
    loadingView = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:loadingView];
    loadingView.labelText = @"Processing...";
    [loadingView show:YES];
    
    NSString *movPath = [FileHelper documentsPath:[name stringByAppendingString:@".mov"]];
    [NSThread detachNewThreadSelector:@selector(revertVideoWithPath:) toTarget:self withObject:movPath];
    
    //[self revertVideoWithPath:movPath];
}
@end
@implementation UIImage (Extras)

#pragma mark -
#pragma mark Scale and crop image

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize
{
    UIImage *sourceImage = self;
    UIImage *newImage = nil;        
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) 
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor) 
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5; 
        }
        else 
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }       
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) 
        NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}
@end
