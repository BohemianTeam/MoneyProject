//
//  PCMMixer.M
//  Combine two audio files
//
//  Created by Cuc Nguyen Elisoft on 12/22/11.
//  Copyright (c) 2011 Elisoft. All rights reserved.
//

#import "PCMMixer.h"

#import <unistd.h>
#import <AudioToolbox/ExtendedAudioFile.h>

// Mix sample data from two buffers, if clipping is detected
// then we have to exit the mix operation.

static
inline
BOOL mix_buffers(const int16_t *buffer1,
				 const int16_t *buffer2,
				 int16_t *mixbuffer,
				 int mixbufferNumSamples)
{
	BOOL clipping = FALSE;
	for (int i = 0 ; i < mixbufferNumSamples; i++) {
		int32_t s1 = buffer1[i];
		int32_t s2 = buffer2[i];
		int32_t mixed = s1 + s2;

		if ((mixed < -32768) || (mixed > 32767)) {
			clipping = TRUE;
			break;
		} else {
			mixbuffer[i] = (int16_t) mixed;
		}
	}

	return clipping;
}

@implementation PCMMixer	

+ (void) _setDefaultAudioFormatFlags:(AudioStreamBasicDescription*)audioFormatPtr
						 numChannels:(NSUInteger)numChannels
{
    
	bzero(audioFormatPtr, sizeof(AudioStreamBasicDescription));
	
	audioFormatPtr->mFormatID = kAudioFormatLinearPCM;
	audioFormatPtr->mSampleRate = 44100.0;
	audioFormatPtr->mChannelsPerFrame = numChannels;
	audioFormatPtr->mBytesPerPacket = 2 * numChannels;
	audioFormatPtr->mFramesPerPacket = 1;
	audioFormatPtr->mBytesPerFrame = 2 * numChannels;
	audioFormatPtr->mBitsPerChannel = 16;
	audioFormatPtr->mFormatFlags = kAudioFormatFlagsNativeEndian |
	kAudioFormatFlagIsPacked | kAudioFormatFlagIsSignedInteger;	
}
int countTest =1;
+ (OSStatus) mix:(NSString*)file1 file2:(NSString*)file2 mixfile:(NSString*)mixfile startTime:(int)startTime delayTime:(int)delayTime endTime:(int)endTime
{
   
	OSStatus status, close_status;

	NSURL *url1 = [NSURL fileURLWithPath:file1];
	NSURL *url2 = [NSURL fileURLWithPath:file2];
	NSURL *mixURL = [NSURL fileURLWithPath:mixfile];

	AudioFileID inAudioFile1 = NULL;
	AudioFileID inAudioFile2 = NULL;
	AudioFileID mixAudioFile = NULL;

#ifndef TARGET_OS_IPHONE
	// Why is this constant missing under Mac OS X?
# define kAudioFileReadPermission fsRdPerm
#endif
	
#define BUFFER_SIZE 4096
	char *buffer1 = NULL;
	char *buffer2 = NULL;
	char *mixbuffer = NULL;	

	status = AudioFileOpenURL((CFURLRef)url1, kAudioFileReadPermission, 0, &inAudioFile1);
    if (status)
	{
		goto reterr;
	}	

	status = AudioFileOpenURL((CFURLRef)url2, kAudioFileReadPermission, 0, &inAudioFile2);
    if (status)
	{
		goto reterr;
	}

	// Verify that file contains pcm data at 44 kHz

    AudioStreamBasicDescription inputDataFormat;
	UInt32 propSize = sizeof(inputDataFormat);

	bzero(&inputDataFormat, sizeof(inputDataFormat));
    status = AudioFileGetProperty(inAudioFile1, kAudioFilePropertyDataFormat,
								  &propSize, &inputDataFormat);

    if (status)
	{
		goto reterr;
	}

	if ((inputDataFormat.mFormatID == kAudioFormatLinearPCM) &&
		(inputDataFormat.mSampleRate == 44100.0) &&
		(inputDataFormat.mChannelsPerFrame == 2) &&
		(inputDataFormat.mChannelsPerFrame == 2) &&
		(inputDataFormat.mBitsPerChannel == 16) &&
		(inputDataFormat.mFormatFlags == (kAudioFormatFlagsNativeEndian |
										  kAudioFormatFlagIsPacked | kAudioFormatFlagIsSignedInteger))
		) {
		// no-op when the expected data format is found
	} else {
		status = kAudioFileUnsupportedFileTypeError;
		goto reterr;
	}

	// Do the same for file2

	propSize = sizeof(inputDataFormat);

	bzero(&inputDataFormat, sizeof(inputDataFormat));
    status = AudioFileGetProperty(inAudioFile2, kAudioFilePropertyDataFormat,
								  &propSize, &inputDataFormat);

    if (status)
	{
		goto reterr;
	}
	
	if ((inputDataFormat.mFormatID == kAudioFormatLinearPCM) &&
		(inputDataFormat.mSampleRate == 44100.0) &&
		(inputDataFormat.mChannelsPerFrame == 2) &&
		(inputDataFormat.mChannelsPerFrame == 2) &&
		(inputDataFormat.mBitsPerChannel == 16) &&
		(inputDataFormat.mFormatFlags == (kAudioFormatFlagsNativeEndian |
										  kAudioFormatFlagIsPacked | kAudioFormatFlagIsSignedInteger))
		) {
		// no-op when the expected data format is found
	} else {
		status = kAudioFileUnsupportedFileTypeError;
		goto reterr;
	}

	// Both input files validated, open output (mix) file

	[self _setDefaultAudioFormatFlags:&inputDataFormat numChannels:2];

	status = AudioFileCreateWithURL((CFURLRef)mixURL, kAudioFileCAFType, &inputDataFormat,
									kAudioFileFlags_EraseFile, &mixAudioFile);
    if (status)
	{
		goto reterr;
	}

	// Read buffer of data from each file

	buffer1 = malloc(BUFFER_SIZE);
	assert(buffer1);
	buffer2 = malloc(BUFFER_SIZE);
	assert(buffer2);
	mixbuffer = malloc(BUFFER_SIZE);
	assert(mixbuffer);

	SInt64 packetNum1 = 0;
	SInt64 packetNum2 = 0;
	SInt64 mixpacketNum = 0;

	UInt32 numPackets1;
	UInt32 numPackets2;
    //delay first
    
    
    //process file 1
	while (TRUE) {
		// Read a chunk of input
        countTest ++;
        
		UInt32 bytesRead;
		numPackets1 = BUFFER_SIZE / inputDataFormat.mBytesPerPacket;        
		status = AudioFileReadPackets(inAudioFile1,
									  false,
									  &bytesRead,
									  NULL,
									  packetNum1,
									  &numPackets1,
									  buffer1);

		if (status) {
			goto reterr;
		}
        //fill zero for first silence sound
        if (startTime != -1) {
            if (countTest < startTime) {
                bzero(buffer1 + bytesRead, (BUFFER_SIZE - bytesRead));
            }            
        }
		// if buffer was not filled, fill with zeros
		if (bytesRead < BUFFER_SIZE) {
			bzero(buffer1 + bytesRead, (BUFFER_SIZE - bytesRead));
		}

		packetNum1 += numPackets1;
        NSLog(@"Count : %i",countTest);
       
      	// If no frames were returned, conversion is finished
		if (numPackets1 == 0 )
        {
            NSLog(@"Breakk");
			break;
        }

		// Write pcm data to output file

		int maxNumPackets;
        maxNumPackets = numPackets1;        
		// write the mixed packets to the output file
    
		UInt32 packetsWritten = maxNumPackets;
		status = AudioFileWritePackets(mixAudioFile,
										FALSE,
										(maxNumPackets * inputDataFormat.mBytesPerPacket),
										NULL,
										mixpacketNum,
										&packetsWritten,
										buffer1);
    

		if (status) {
			goto reterr;
		}
		
		if (packetsWritten != maxNumPackets) {
			status = kAudioFileInvalidPacketOffsetError;
			goto reterr;
		}
        if ((countTest != -1)&&(countTest < startTime)) {                      
            //don' write anything
        }
        else
        {
            //write next frame
            mixpacketNum += packetsWritten;
        }
	}	
    //process delay midle
    int maxDelayTime = delayTime +countTest;
    while (TRUE) {
        countTest ++;
        if (countTest > maxDelayTime) {
            NSLog(@"Break delay");
            break;
        }
        NSLog(@"Count : %i",countTest);
        UInt32 bytesRead = 0;
        if (bytesRead < BUFFER_SIZE) {
			bzero(buffer1 + bytesRead, (BUFFER_SIZE - bytesRead));
		}
        numPackets1 = BUFFER_SIZE / inputDataFormat.mBytesPerPacket;
        status = AudioFileWritePackets(mixAudioFile,
                                       FALSE,
                                       (numPackets1 * inputDataFormat.mBytesPerPacket),
                                       NULL,
                                       mixpacketNum,
                                       &numPackets1,
                                       buffer1);
        
        mixpacketNum += numPackets1;
    }
//process file 2
    int maxTime2 = countTest + endTime;
    while (TRUE) {
		// Read a chunk of input
        countTest ++;
        
		UInt32 bytesRead;
		numPackets2 = BUFFER_SIZE / inputDataFormat.mBytesPerPacket;        
		status = AudioFileReadPackets(inAudioFile2,
									  false,
									  &bytesRead,
									  NULL,
									  packetNum2,
									  &numPackets2,
									  buffer2);
        
		if (status) {
			goto reterr;
		}
        
		// if buffer was not filled, fill with zeros
        
		if (bytesRead < BUFFER_SIZE) {
			bzero(buffer2 + bytesRead, (BUFFER_SIZE - bytesRead));
		}
        
		packetNum2 += numPackets2;
        NSLog(@"Count : %i",countTest);
        
      	// If no frames were returned, conversion is finished
        
		if (numPackets2 == 0 )
        {
            NSLog(@"Breakk");
			break;
        }
        
		// Write pcm data to output file
        
		int maxNumPackets;
        //	if (numPackets1 > numPackets2) {
        maxNumPackets = numPackets2; 
      
     
		UInt32 packetsWritten = maxNumPackets;
        
        if ((endTime != -1) && (countTest > endTime)) {
            NSLog(@"Break soon");
            break;
        }
		status = AudioFileWritePackets(mixAudioFile,
                                       FALSE,
                                       (maxNumPackets * inputDataFormat.mBytesPerPacket),
                                       NULL,
                                       mixpacketNum,
                                       &packetsWritten,
                                       buffer2);
        
		if (status) {
			goto reterr;
		}
		
		if (packetsWritten != maxNumPackets) {
			status = kAudioFileInvalidPacketOffsetError;
			goto reterr;
		}
        
		mixpacketNum += packetsWritten;
	}	
reterr:
	if (inAudioFile1 != NULL) {
		close_status = AudioFileClose(inAudioFile1);
		assert(close_status == 0);
	}
	if (inAudioFile2 != NULL) {
		close_status = AudioFileClose(inAudioFile2);
		assert(close_status == 0);
	}
	if (mixAudioFile != NULL) {
		close_status = AudioFileClose(mixAudioFile);
		assert(close_status == 0);
	}
	if (status == OSSTATUS_MIX_WOULD_CLIP) {
		char *mixfile_str = (char*) [mixfile UTF8String];
		close_status = unlink(mixfile_str);
		assert(close_status == 0);
	}
	if (buffer1 != NULL) {
		free(buffer1);
	}
	if (buffer2 != NULL) {
		free(buffer2);
	}
	if (mixbuffer != NULL) {
		free(mixbuffer);
	}

	return status;
}

+ (OSStatus) reverseAudioFrom:(CFURLRef)sourceURL To:(CFURLRef)destinationURL{
    //This function just use for linear PCM
#ifndef BUFFER_SIZE
# define BUFFER_SIZE 4096
#endif
    AudioFileID sourceFileID=NULL, dstFileID=NULL;
    OSStatus result = AudioFileOpenURL(sourceURL, kAudioFileReadPermission, 0, &sourceFileID);
    if (noErr != result) {
        return result;
    }
    //Read file OK
    
    // Verify that file contains pcm data at 44 kHz
    
    AudioStreamBasicDescription inputDataFormat;
	UInt32 propSize = sizeof(inputDataFormat);
    
	bzero(&inputDataFormat, sizeof(inputDataFormat));
    result = AudioFileGetProperty(sourceFileID, kAudioFilePropertyDataFormat,
								  &propSize, &inputDataFormat);
    
    if (result)
	{
        if (sourceFileID) AudioFileClose(sourceFileID);
		return result;
	}
    
	if ((inputDataFormat.mFormatID == kAudioFormatLinearPCM) &&
		(inputDataFormat.mSampleRate == 44100.0) &&
		(inputDataFormat.mChannelsPerFrame == 2) &&
		(inputDataFormat.mChannelsPerFrame == 2)) {
		// no-op when the expected data format is found
	} else {
        if (sourceFileID) AudioFileClose(sourceFileID);
		return !(noErr);	}
  
    //Just for test, progammer must remove ExistFile before use this function
    
    // using input format for ouput format
    
    //Create output File
	result = AudioFileCreateWithURL(destinationURL, kAudioFileCAFType, &inputDataFormat,
									kAudioFileFlags_EraseFile, &dstFileID);
    
    if (result) {
        if (dstFileID) AudioFileClose(dstFileID);
        if (sourceFileID) AudioFileClose(sourceFileID);
        return result;
    }    
	UInt32 numPackets=1;
    char * buffer=malloc(BUFFER_SIZE);
    SInt64 totalPacket=0;
    SInt64 posReadPacket=0;// position to read
    SInt64 posCurrentWritePacket=0;// position to write
    
    propSize=(sizeof(totalPacket));
    AudioFileGetProperty(sourceFileID, kAudioFilePropertyAudioDataPacketCount,
								  &propSize, &totalPacket);
    
    //if (totalPacket<1) {
        //totalPacket= [self frameCount:sourceURL];
    //}
    
    posReadPacket = totalPacket-1;
    
    while (posReadPacket>=0) {
        // Read a chunk of input
		UInt32 bytesRead;// the number of bytes
		numPackets = 1; // each time read 1 packet
        bzero(buffer, BUFFER_SIZE);
		result = AudioFileReadPackets(sourceFileID,
									  false,
									  &bytesRead,
									  NULL,
									  posReadPacket,
									  &numPackets,
									  buffer);
        //decrease posReadPacket
        posReadPacket--;
        
		if (result) {
            if (dstFileID) AudioFileClose(dstFileID);
            if (sourceFileID) AudioFileClose(sourceFileID);
			return result;
		}
		// if buffer was not filled, fill with zeros
		if (bytesRead < BUFFER_SIZE) {
			bzero(buffer + bytesRead, (BUFFER_SIZE - bytesRead));
		}
        
		if (numPackets != 1 )
        {
            // I don't know how does it happen, in mind, I think it is allway "1"
            NSLog(@"I don't know");
            //close Files before return
            if (dstFileID) AudioFileClose(dstFileID);
            if (sourceFileID) AudioFileClose(sourceFileID);
			return !(noErr);
        }
        
		// Write pcm data to output file
        
        // write the packet to the output file
        
		result = AudioFileWritePackets(dstFileID,
                                       false,
                                       bytesRead,
                                       NULL,
                                       posCurrentWritePacket,
                                       &numPackets,
                                       buffer);
        //increase posCurrentWritePacket
        posCurrentWritePacket++;
        
        
		if (result) {
            //Close file
            if (dstFileID) AudioFileClose(dstFileID);
            if (sourceFileID) AudioFileClose(sourceFileID);
			return result;
        }
	}	
    //ready success?
    if (dstFileID) AudioFileClose(dstFileID);
	if (sourceFileID) AudioFileClose(sourceFileID);
    free(buffer);
    return noErr;
}
+ (SInt64)frameCount:(CFURLRef)sourceURL
{
    AudioFileID afID = NULL;
    ExtAudioFileRef  mAudioFile=0;
    ExtAudioFileOpenURL(sourceURL, &mAudioFile);
    UInt32 size = sizeof(afID);
    ExtAudioFileGetProperty( mAudioFile, 
                                           kExtAudioFileProperty_AudioFile, &size, &afID );
    
    UInt64 packetCount = 0;
    size = sizeof(packetCount);
     AudioFileGetProperty( afID, 
                                        kAudioFilePropertyAudioDataPacketCount, &size, &packetCount ) ;
    
    // CL - In iOS 4.2.1 (and 4.2), WAV and AIF files have a packetCount of 0, 
    //whereas they did not in iOS 4.1.
    
    AudioStreamBasicDescription fileDataFormat;
    size = sizeof( fileDataFormat );
     AudioFileGetProperty( afID, kAudioFilePropertyDataFormat, 
                                        &size, &fileDataFormat ) ;
    
    AudioFilePacketTableInfo pti;
    BOOL ptiValid = NO;
    memset( &pti, 0, sizeof( AudioFilePacketTableInfo ) );
    size = sizeof(pti);
    OSStatus err = AudioFileGetProperty( afID, 
                                        kAudioFilePropertyPacketTableInfo, &size, &pti );
    if ( err == noErr ) {
        ptiValid = YES;
    } else {
        ptiValid = NO;
    }
    
    UInt64 totalFrames = 0;
    switch ( fileDataFormat.mFramesPerPacket ) {
        case 1:
            totalFrames = packetCount;
            break;
        case 0:
        {            
            AudioFramePacketTranslation afpt = { .mFrame = 0, .mPacket = 
                packetCount - 1, .mFrameOffsetInPacket = 0 };
            size = sizeof(afpt);
             AudioFileGetProperty( afID, 
                                                kAudioFilePropertyPacketToFrame, &size, &afpt );
            totalFrames = afpt.mFrame;
        }
            break;
        default:
            totalFrames = packetCount * fileDataFormat.mFramesPerPacket;
            break;
    }
    
    if ( ptiValid ) {
        totalFrames -= ( pti.mPrimingFrames + pti.mRemainderFrames );
    }
    
    return totalFrames;
}

@end
