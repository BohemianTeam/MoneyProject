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

+ (NSString *) getCurrentTimeString;
+ (NSString *) getRequestParameterString;
+ (NSString *) getRequestParameterString:(NSString*)str;
+ (NSString *) generateHashedString:(NSString *) data;
+ (NSString *) base64StringFromData:(NSData *)data length:(int)length;
+ (NSData *) base64DataFromString:(NSString *)string;
#pragma response
+ (NSMutableArray *) postVenues:(NSData *) value;

+ (void)showLoading:(UIView*)view;
+ (void)showLoading:(NSString*)content view:(UIView*)view;
+ (void)hideLoading;

+ (NSString*)convertDateToString:(NSDate*)date;
+ (NSString*)convertDateToString:(NSDate*)date withFormat:(NSString*)format;
+ (NSDate*)convertStringToDate:(NSString*)dateStr withFormat:(NSString*)format;
//utils for string
+ (CGSize)sizeOfText: (NSString*)text withFont:(UIFont*)font constrainedToSize:(CGSize)constrainedSize lineBreakMode:(UILineBreakMode)mode;

//utils private for this app
+ (BOOL)isStarred:(NSString*)code;
+ (void)updateStarredList:(NSString*)code status:(NSInteger)stt;
+ (BOOL)isDate:(NSDate*)date betweenInclusiveFrom:(NSDate*)begin to:(NSDate*)end;


@end
