//
//  FileHelper.h
//  iBack
//
//  Created by bohemian on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#define IMG_FOLDER_TEMP         @"imgFolder"
#define IMG_FILENAME_TEMP       @"img"
#define VIDEO_FILENAME_TEMP     @"test.mp4"
#define AUDIO_FILENAME_TEMP     @"test.caf"
#define AUDIO_FILENAME_TEMP1     @"test1.caf"

#define VIDEO_FOLDER_TEMP       @"movFolder"

@interface FileHelper : NSObject
{
    NSString        *saveFolderPath;
}
@property(nonatomic, retain)NSString        *saveFolderPath;

+ (FileHelper*) sharedFileHelper;
+(NSString*)documentsPath;
+(NSString *)bundlePath:(NSString *)fileName;
+(NSString *)documentsPath:(NSString *)fileName;
+(void)deleteAllFileAtDirectoryPath:(NSString*)path;
+(BOOL)createFolder:(NSString*)folderName withPath:(NSString*)path;
+(BOOL)checkFile:(NSString*)file isType:(NSString*)type;

- (void)initFileHelper;
- (NSArray*)getFilesInFolder;
- (NSString*)createFullFilePath:(NSString*)file;
- (BOOL)deleteFileAtPath:(NSString*)path;
- (void)deleteFileAtPaths:(NSArray*)paths;
- (BOOL)renameFileAtPath:(NSString*)path withName:(NSString*)name withType:(NSInteger)type;
@end
