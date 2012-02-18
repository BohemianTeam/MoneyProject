//
//  Util.m
//  VideoApplication
//
//  Created by Cuong Tran on 1/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Util.h"
#import "VideoData.h"
#import "ListVideoData.h"
#import "CJSONDeserializer.h"
#import <CommonCrypto/CommonDigest.h>
@implementation Util

+ (CGFloat) calculateHeightOfTextFromWidth:(NSString* )text 
                                  withFont:(UIFont*)font 
                                 withWidth:(CGFloat)width 
                         withLineBreakMode:(UILineBreakMode)lineBreakMode
{
    [text retain];
    [font retain];
    CGFloat ret = 0;
    NSArray *array = [text componentsSeparatedByString:@"\n"];
    CGSize singleSize = [@"A" sizeWithFont:font constrainedToSize:CGSizeMake(FLT_MAX, FLT_MAX) lineBreakMode:lineBreakMode];
    
    CGSize size;
    for (int i = 0; i < [array count]; i++) {
        NSString *tmp = [array objectAtIndex:i];
        if ([tmp length] == 0) {
            ret += singleSize.height;
        } else {
            size = [tmp sizeWithFont:font constrainedToSize:CGSizeMake(width, FLT_MAX) lineBreakMode:lineBreakMode];
            ret += size.height;
        }
    }
    
    [text release];
    [font release];
    
    return ret;
}


+ (NSString *)URLEncode:(NSString *)value {
    if (!value)
		return @"";
    value = [value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    value = [value stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    value = [value stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
    value = [value stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"];    
    value = [value stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];    
    value = [value stringByReplacingOccurrencesOfString:@"\"" withString:@"%22"];
    value = [value stringByReplacingOccurrencesOfString:@"[" withString:@"%5B"];
    value = [value stringByReplacingOccurrencesOfString:@"]" withString:@"%5D"];
    value = [value stringByReplacingOccurrencesOfString:@"," withString:@"%2C"];
    
    return value;
}


+ (NSString *)URLDecode:(NSString *)value {
    if (!value)
		return @"";
    value = [value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    value = [value stringByReplacingOccurrencesOfString:@"%2B" withString:@"+"];
    value = [value stringByReplacingOccurrencesOfString:@"%26" withString:@"&"];
    value = [value stringByReplacingOccurrencesOfString:@"%2F" withString:@"/"];    
    value = [value stringByReplacingOccurrencesOfString:@"%3D" withString:@"="];    
    value = [value stringByReplacingOccurrencesOfString:@"%22" withString:@"\""];
    return value;
}


+ (ListVideoData *) postVideo:(NSData *)dataReply {
    ListVideoData *list = [[[ListVideoData alloc] init] autorelease];
    NSError *error;
    CJSONDeserializer *jsonDeserializer = [CJSONDeserializer deserializer];
    NSDictionary *resultsDictionary = (NSDictionary*)[jsonDeserializer deserializeAsDictionary:dataReply error:&error];
    if(resultsDictionary == nil){
		list.status = @"failure";
    }
	else {
		if ([resultsDictionary objectForKey:@"status"]) {
			if ([[resultsDictionary objectForKey:@"status"] isEqualToString:@"success"]) {
				list.status = @"success";
            }
			else {
				list.status = @"failure";
            }
		}
        if ([list.status isEqualToString:@"success"]) {
            NSArray *items = (NSArray *) [resultsDictionary objectForKey:@"videos"];
            for(NSDictionary *video in items) {
                VideoData *response = [[VideoData alloc] init];
                response.mid = [video objectForKey:@"id"];
                response.title = [video objectForKey:@"title"];
                response.desc = [video objectForKey:@"desc"];
                response.url = [video objectForKey:@"videourl"];
                response.subUrl = [video objectForKey:@"suburl"];
                response.timelineUrl = [video objectForKey:@"timelineurl"];
                
                [list.videos addObject:response];
            }
        } else {
            return nil;
        }
    }
    return list;
}

+ (NSString *)calcMD5:(NSString*)text {
    CC_MD5_CTX md5;
    CC_MD5_Init(&md5);
    CC_MD5_Update(&md5, [text UTF8String], [text lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);
    
    NSString *s = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
				   digest[0], digest[1], 
				   digest[2], digest[3],
				   digest[4], digest[5],
				   digest[6], digest[7],
				   digest[8], digest[9],
				   digest[10], digest[11],
				   digest[12], digest[13],
				   digest[14], digest[15]];
    return s;
}

+ (NSString *) getCacheDir {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *cacheDir = [paths objectAtIndex:0];
    return cacheDir;
}

+ (void) createDirectoryAtPath:(NSString *)path {
    NSFileManager *fm = [NSFileManager defaultManager];
    [fm createDirectoryAtPath:path attributes:nil];
}

+ (void) createResourcesDir {
    NSFileManager *fm = [NSFileManager defaultManager];
    
    NSString *videoDir = [Util getVideoDir];
    if (![fm fileExistsAtPath:videoDir]) {
        [Util createDirectoryAtPath:videoDir];
    }
    
    NSString *subDir = [Util getSubDir];
    if (![fm fileExistsAtPath:subDir]) {
        [Util createDirectoryAtPath:subDir];
    }
    
    NSString *timelineDir = [Util getTimeLineDir];
    if (![fm fileExistsAtPath:timelineDir]) {
        [Util createDirectoryAtPath:timelineDir];
    }
}

+ (NSString *) getVideoDir {
    NSString *dir = [Util getCacheDir];
    return [dir stringByAppendingString:@"/videos"];
}

+ (NSString *) getTimeLineDir {
    NSString *dir = [Util getCacheDir];
    return [dir stringByAppendingString:@"/timelines"];
}

+ (NSString *) getSubDir {
    NSString *dir = [Util getCacheDir];
    return [dir stringByAppendingString:@"/subs"];
}

+ (BOOL) checkFileExits:(NSString *)path {
    NSFileManager *fm = [NSFileManager defaultManager];
    return [fm fileExistsAtPath:path];
}

@end
