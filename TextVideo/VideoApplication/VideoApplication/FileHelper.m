//
//  FileHelper.m
//  VideoApplication
//
//  Created by bohemian on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FileHelper.h"

@implementation FileHelper


+ (NSString*)documentsPath
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}
+ (void)deleteAllFileAtDirectoryPath:(NSString*)path
{
    //remove all file in temp directory (documents)
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSError *error = nil;
    for (NSString *file in [fileManager contentsOfDirectoryAtPath:path error:&error]) {
        BOOL success = [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%@", path, file] error:&error];
        if (!success || error) {
            // it failed.
            NSLog(@"Fail");
        }
    }
}
+(BOOL)createFolder:(NSString*)folderName withPath:(NSString*)path
{
    NSString *folderFullPath = [path stringByAppendingFormat:@"/%@", folderName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager createDirectoryAtPath:folderFullPath withIntermediateDirectories:YES attributes:nil error:nil ];
}
+(BOOL)checkFile:(NSString*)file isType:(NSString*)type
{
    NSArray *splits = [file componentsSeparatedByString:@"."];
    NSString *fileType = [splits lastObject];
    
    if([splits count] < 2)
        return FALSE;
    if([fileType isEqual:type])
        return TRUE;
    
    return FALSE;
}
@end
