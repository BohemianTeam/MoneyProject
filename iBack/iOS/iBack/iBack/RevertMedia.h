//
//  RevertMedia.h
//  iBack
//
//  Created by bohemian on 2/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface RevertMedia : NSObject<AVCaptureVideoDataOutputSampleBufferDelegate>
{
    AVCaptureSession *session;

    int _index;
    
    size_t iwidth;
    size_t iheight;
}
-(void) startCameraCapture;
-(void) stopCameraCapture;
-(void) revertVideoWithPath:(NSString*)path;
@end
