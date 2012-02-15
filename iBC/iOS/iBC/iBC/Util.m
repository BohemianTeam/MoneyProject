//
//  Util.m
//  VideoApplication
//
//  Created by Cuong Tran on 1/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Util.h"
#import "CJSONDeserializer.h"
#import "VenuesResponse.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
@implementation Util

+ (NSString *) getCurrentTimeString {
    NSDateFormatter *formater;
    NSString *dateString;
    
    formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyyMMddHHmm"];
    dateString = [formater stringFromDate:[NSDate date]];
    [formater release];
    return dateString;
}

+ (NSString *) getRequestParameterString {
    NSString* str = [NSString stringWithFormat:@"%@%@", KinectiaAppId,[self getCurrentTimeString]];
    return [self generateHashedString:str];
}

+ (NSString *) generateHashedString:(NSString *)data {
    NSString *key = SECRET_KEY;
    const char *cKey = [key cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [data cStringUsingEncoding:NSUTF8StringEncoding];
    
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSData *hashMAC = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    
    return [self base64StringFromData:hashMAC length:sizeof(hashMAC)];
}

+ (NSString *) base64StringFromData:(NSData *)data length:(int)length {
    static char base64EncodingTable[64] = {
        'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
        'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
        'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
        'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/'
    };
    
    unsigned long ixtext, lentext;
    long ctremaining;
    unsigned char input[3], output[4];
    short i, charsonline = 0, ctcopy;
    const unsigned char *raw;
    NSMutableString *result;
    
    lentext = [data length]; 
    if (lentext < 1)
        return @"";
    result = [NSMutableString stringWithCapacity: lentext];
    raw = [data bytes];
    ixtext = 0; 
    
    while (true) {
        ctremaining = lentext - ixtext;
        if (ctremaining <= 0) 
            break;        
        for (i = 0; i < 3; i++) { 
            unsigned long ix = ixtext + i;
            if (ix < lentext)
                input[i] = raw[ix];
            else
                input[i] = 0;
        }
        output[0] = (input[0] & 0xFC) >> 2;
        output[1] = ((input[0] & 0x03) << 4) | ((input[1] & 0xF0) >> 4);
        output[2] = ((input[1] & 0x0F) << 2) | ((input[2] & 0xC0) >> 6);
        output[3] = input[2] & 0x3F;
        ctcopy = 4;
        switch (ctremaining) {
            case 1: 
                ctcopy = 2; 
                break;
            case 2: 
                ctcopy = 3; 
                break;
        }
        
        for (i = 0; i < ctcopy; i++)
            [result appendString: [NSString stringWithFormat: @"%c", base64EncodingTable[output[i]]]];
        
        for (i = ctcopy; i < 4; i++)
            [result appendString: @"="];
        
        ixtext += 3;
        charsonline += 4;
        
        if ((length > 0) && (charsonline >= length))
            charsonline = 0;
    }     
    return result;
}

+ (NSData *)base64DataFromString: (NSString *)string
{
    unsigned long ixtext, lentext;
    unsigned char ch, inbuf[4], outbuf[3];
    short i, ixinbuf;
    Boolean flignore, flendtext = false;
    const unsigned char *tempcstring;
    NSMutableData *theData;
    
    if (string == nil)
    {
        return [NSData data];
    }
    
    ixtext = 0;
    
    tempcstring = (const unsigned char *)[string UTF8String];
    
    lentext = [string length];
    
    theData = [NSMutableData dataWithCapacity: lentext];
    
    ixinbuf = 0;
    
    while (true)
    {
        if (ixtext >= lentext)
        {
            break;
        }
        
        ch = tempcstring [ixtext++];
        
        flignore = false;
        
        if ((ch >= 'A') && (ch <= 'Z'))
        {
            ch = ch - 'A';
        }
        else if ((ch >= 'a') && (ch <= 'z'))
        {
            ch = ch - 'a' + 26;
        }
        else if ((ch >= '0') && (ch <= '9'))
        {
            ch = ch - '0' + 52;
        }
        else if (ch == '+')
        {
            ch = 62;
        }
        else if (ch == '=')
        {
            flendtext = true;
        }
        else if (ch == '/')
        {
            ch = 63;
        }
        else
        {
            flignore = true; 
        }
        
        if (!flignore)
        {
            short ctcharsinbuf = 3;
            Boolean flbreak = false;
            
            if (flendtext)
            {
                if (ixinbuf == 0)
                {
                    break;
                }
                
                if ((ixinbuf == 1) || (ixinbuf == 2))
                {
                    ctcharsinbuf = 1;
                }
                else
                {
                    ctcharsinbuf = 2;
                }
                
                ixinbuf = 3;
                
                flbreak = true;
            }
            
            inbuf [ixinbuf++] = ch;
            
            if (ixinbuf == 4)
            {
                ixinbuf = 0;
                
                outbuf[0] = (inbuf[0] << 2) | ((inbuf[1] & 0x30) >> 4);
                outbuf[1] = ((inbuf[1] & 0x0F) << 4) | ((inbuf[2] & 0x3C) >> 2);
                outbuf[2] = ((inbuf[2] & 0x03) << 6) | (inbuf[3] & 0x3F);
                
                for (i = 0; i < ctcharsinbuf; i++)
                {
                    [theData appendBytes: &outbuf[i] length: 1];
                }
            }
            
            if (flbreak)
            {
                break;
            }
        }
    }
    
    return theData;
}

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


//+ (ListVideoData *) postVideo:(NSData *)dataReply {
//    ListVideoData *list = [[[ListVideoData alloc] init] autorelease];
//    NSError *error;
//    CJSONDeserializer *jsonDeserializer = [CJSONDeserializer deserializer];
//    NSDictionary *resultsDictionary = (NSDictionary*)[jsonDeserializer deserializeAsDictionary:dataReply error:&error];
//    if(resultsDictionary == nil){
//		list.status = @"failure";
//    }
//	else {
//		if ([resultsDictionary objectForKey:@"status"]) {
//			if ([[resultsDictionary objectForKey:@"status"] isEqualToString:@"success"]) {
//				list.status = @"success";
//            }
//			else {
//				list.status = @"failure";
//            }
//		}
//        if ([list.status isEqualToString:@"success"]) {
//            NSArray *items = (NSArray *) [resultsDictionary objectForKey:@"videos"];
//            for(NSDictionary *video in items) {
//                VideoData *response = [[VideoData alloc] init];
//                response.mid = [video objectForKey:@"id"];
//                response.title = [video objectForKey:@"title"];
//                response.desc = [video objectForKey:@"desc"];
//                response.url = [video objectForKey:@"videourl"];
//                response.subUrl = [video objectForKey:@"suburl"];
//                response.timelineUrl = [video objectForKey:@"timelineurl"];
//                
//                [list.videos addObject:response];
//            }
//        } else {
//            return nil;
//        }
//    }
//    return list;
//}

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
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
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

#pragma reponse methods
+ (NSMutableArray *) postVenues:(NSData *)value {
    NSMutableArray * list = [[NSMutableArray alloc] init];
    NSError *error;
    CJSONDeserializer *jsonDeserializer = [CJSONDeserializer deserializer];
    NSDictionary *resultsDictionary = (NSDictionary*)[jsonDeserializer deserializeAsDictionary:value error:&error];
    if(resultsDictionary == nil) {
        
    }
	else {
        
    }
    return list;
}

@end
