//
//  RevertMedia.m
//  iBack
//
//  Created by bohemian on 2/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RevertMedia.h"
#import "FileHelper.h"

@interface RevertMedia(private)
- (void)CompileFilesToMakeMovie;
- (CVPixelBufferRef)newPixelBufferFromCGImage:(CGImageRef)image;
- (void)writeImagesToMovieAtPath:(NSString *)path withSize:(CGSize)size;
@end
@implementation RevertMedia

#pragma mark Revert Video
-(void) revertVideoWithPath:(NSString*)path
{
    [self writeImagesToMovieAtPath:path withSize:CGSizeMake(iwidth, iheight)];
}

-(void)CompileFilesToMakeMovie: (NSString*)path{
    NSLog(@"Compile File at %@", path);
    AVMutableComposition* mixComposition = [AVMutableComposition composition];
    
    NSString* audio_inputFileName = @"audioTest.caf";
    NSString* audio_inputFilePath = [FileHelper bundlePath:audio_inputFileName];
    NSURL*    audio_inputFileUrl = [NSURL fileURLWithPath:audio_inputFilePath];
    
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

	// Get the default camera device
    NSError *error = nil;
	AVCaptureDevice* camera = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
	
	// Create a AVCaptureInput with the camera device
    
	AVCaptureInput* cameraInput = [[AVCaptureDeviceInput alloc] initWithDevice:camera error:&error];
	if (cameraInput == nil) {
		NSLog(@"Error to create camera capture:%@",error);
	}
	
	// Set the output
	AVCaptureVideoDataOutput* videoOutput = [[AVCaptureVideoDataOutput alloc] init];
	
	// create a queue to run the capture on
	dispatch_queue_t captureQueue=dispatch_queue_create("catpureQueue", NULL);
	
	// setup our delegate
	[videoOutput setSampleBufferDelegate:self queue:captureQueue];
    
	// configure the pixel format
	videoOutput.videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA], (id)kCVPixelBufferPixelFormatTypeKey,
                                 nil];
    
	// and the size of the frames we want
	[session setSessionPreset:AVCaptureSessionPresetMedium];
    
	// Add the input and output
	[session addInput:cameraInput];
	[session addOutput:videoOutput];
	
	// Start the session
	[session startRunning];		
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
    UIImage *image = [[UIImage alloc] initWithCGImage:quartzImage];
    NSString  *pngPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@%d.jpg", IMG_FOLDER_TEMP,IMG_FILENAME_TEMP,_index]];
    NSLog(@"Index finish: %i",_index);

    //save image to directorry document
    [UIImageJPEGRepresentation(image, 0.9f) writeToFile:pngPath atomically:YES];

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

@end
