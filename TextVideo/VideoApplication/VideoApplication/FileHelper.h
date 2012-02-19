//
//  FileHelper.h
//  VideoApplication
//
//  Created by bohemian on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileHelper : NSObject

+(NSString*)documentsPath;
+(NSString *)bundlePath:(NSString *)fileName;
+(NSString *)documentsPath:(NSString *)fileName;
+(void)deleteAllFileAtDirectoryPath:(NSString*)path;
+(BOOL)createFolder:(NSString*)folderName withPath:(NSString*)path;
+(BOOL)checkFile:(NSString*)file isType:(NSString*)type;
@end
