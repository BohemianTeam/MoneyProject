//
//  FileHelper.m
//  iBack
//
//  Created by bohemian on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FileHelper.h"
#import "AppConstant.h"

@implementation FileHelper
@synthesize saveFolderPath;

//create singleton object
static FileHelper * __sharedHelper = nil;
+ (FileHelper*) sharedFileHelper
{
	if (__sharedHelper == nil) {
		[[self alloc] init];
        [__sharedHelper initFileHelper];
	}
    return __sharedHelper;
}
+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (__sharedHelper == nil) {
            __sharedHelper = [super allocWithZone:zone];
            return __sharedHelper;
        }
    }
    return nil;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)retain {
    return self;
}

- (id)autorelease {
    return self;
}
- (void)dealloc
{
    [saveFolderPath release];
    [super dealloc];
}
- (void)initFileHelper
{
    saveFolderPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
                                                          NSUserDomainMask, YES) lastObject] retain];
}
- (NSArray*)getFilesInFolder
{
    NSFileManager *fileManager = [NSFileManager defaultManager];

    return [fileManager contentsOfDirectoryAtPath:saveFolderPath error:nil];
    
}
- (NSString*)createFullFilePath:(NSString*)file
{
    NSString *filePath = [NSString stringWithString:saveFolderPath];
    filePath = [filePath stringByAppendingString:@"/"];
    filePath = [filePath stringByAppendingString:file];
    
    return filePath;
}
- (void)deleteFileAtPaths:(NSArray*)paths
{
    for(NSString* path in paths)
        [self deleteFileAtPath:path];
}
- (BOOL)deleteFileAtPath:(NSString*)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    if ([fileManager removeItemAtPath:path error:&error] != YES)
    {
        NSLog(@"Unable to delete file: %@", [error localizedDescription]);
        return NO;
    }
    return YES;
}
- (BOOL)renameFileAtPath:(NSString*)path withName:(NSString*)name withType:(NSInteger)type;
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    // Rename the file, by moving the file
    if(type == 0)
        name = [name stringByAppendingString:MOV_FILE];
    else
        name = [name stringByAppendingString:CAF_FILE];
    NSString *newFile = [saveFolderPath stringByAppendingPathComponent:name];
    
    // Attempt the move
    if ([fileManager moveItemAtPath:path toPath:newFile error:&error] != YES)
    {
        NSLog(@"Unable rename file: %@", [error localizedDescription]);
        return NO;
    }
    return YES;
}
@end
