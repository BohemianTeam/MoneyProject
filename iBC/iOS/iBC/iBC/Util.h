//
//  Util.h
//  VideoApplication
//
//  Created by Cuong Tran on 1/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Util : NSObject {
    
}
+ (CGFloat) calculateHeightOfTextFromWidth:(NSString* )text 
                                  withFont:(UIFont*)font 
                                 withWidth:(CGFloat)width 
                         withLineBreakMode:(UILineBreakMode)lineBreakMode;

+ (NSString *)URLEncode:(NSString *)value;

+ (NSString *)URLDecode:(NSString *)value;

//+ (VideoData *) postVideo:(NSData *) dataReply;

+ (void) createResourcesDir;
+ (void) deleteDir:(NSString *) dir;
+ (void) createDirectoryAtPath:(NSString *) path;
+ (NSString *) getCacheDir;
+ (NSString *) getResourcesDir;
+ (NSString *) getVideoDir;
+ (NSString *) getSubDir;
+ (NSString *) getTimeLineDir;
+ (void) clearAllVideo;
+ (void) clearAllSub;
+ (void) clearAllTimeLine;
+ (NSString *)calcMD5:(NSString*)text;
+ (BOOL) checkFileExits:(NSString *) path;

+ (NSString *) getCurrentTimeString;
+ (NSString *) getRequestParameterString;
+ (NSString *) generateHashedString:(NSString *) data;
+ (NSString *) base64StringFromData:(NSData *)data length:(int)length;
+ (NSData *) base64DataFromString:(NSString *)string;
@end
