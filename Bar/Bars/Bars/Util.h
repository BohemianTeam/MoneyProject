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

+(NSString*)documentsPath;
+(NSString *)bundlePath:(NSString *)fileName;
+(NSString *)documentsPath:(NSString *)fileName;
+ (void) createResourcesDir;
+ (void) deleteDir:(NSString *) dir;
+ (void) createDirectoryAtPath:(NSString *) path;
+ (NSString*)createEditableCopyOfDatabaseIfNeeded: (NSString*)nameDB;

+ (NSString *) getCacheDir;
+ (NSString *) getResourcesDir;
+ (NSString *) getVideoDir;
+ (NSString *) getSubDir;
+ (NSString *) getTimeLineDir;
+ (NSString *) getImageBarDir:(NSString *) barName;
+ (NSString *) getPlatform;
+ (NSString *) getPlatformVer;
+ (NSString *) getScreenResolution;
+ (NSString *) getAppVer;
+ (NSString *) getInstID;

+ (void) clearAllVideo;
+ (void) clearAllSub;
+ (void) clearAllTimeLine;
+ (NSString *)calcMD5:(NSString*)text;
+ (BOOL) checkFileExits:(NSString *) path;

//+ (NSString *) getCurrentTimeString;
//+ (NSString *) getRequestParameterString;
//+ (NSString *) getRequestParameterString:(NSString*)str;
//+ (NSString *) generateHashedString:(NSString *) data;
//+ (NSString *) base64StringFromData:(NSData *)data length:(int)length;
//+ (NSData *) base64DataFromString:(NSString *)string;
//#pragma response
//+ (NSMutableArray *) postVenues:(NSData *) value;

+ (void)showLoading:(UIView*)view;
+ (void)showLoading:(NSString*)content view:(UIView*)view;
+ (void)hideLoading;

+ (NSString*)convertDateToString:(NSDate*)date;
//utils for string
+ (CGSize)sizeOfText: (NSString*)text withFont:(UIFont*)font constrainedToSize:(CGSize)constrainedSize lineBreakMode:(UILineBreakMode)mode;


@end
