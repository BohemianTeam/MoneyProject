//
//  FilesHelper.m
//  iEssenceMapPDF
//
//  Created by bohemian on 2/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FilesHelper.h"
@interface FilesHelper (private)
- (void)initFileHelper;
@end

@implementation FilesHelper
@synthesize pdfFiles;

#pragma mark - FilesHelper singleton
static FilesHelper * __sharedHelper = nil;
+ (FilesHelper*) sharedFileHelper
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
    [pdfFiles release];
    [super dealloc];
}

- (void)initFileHelper
{
    //pdfFiles = [[NSMutableArray alloc] init];
}
#pragma mark - ...
+ (NSString*)documentsPath
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}
+ (NSString *)bundlePath:(NSString *)fileName {
	return [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:fileName];
}

+ (NSString *)documentsPathWithFileName:(NSString *)fileName {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	return [documentsDirectory stringByAppendingPathComponent:fileName];
}
+ (BOOL)copyFileFrom:(NSString*)pathRes toDes:(NSString*)pathDes
{
    NSFileManager *fileManager = [NSFileManager defaultManager];

    BOOL isExistFile = [fileManager fileExistsAtPath:pathDes];
    if(!isExistFile){
        NSError *error;
        BOOL success = [fileManager copyItemAtPath:pathRes toPath:pathDes error:&error];
        
        if(!success){
            NSAssert1(0, @"Failed to save file with message'%@'.", [error localizedDescription]);
            return TRUE;
        }else{
            NSLog(@"save success with path: %@", pathDes);
        }
    }
    
    return FALSE;
}
- (BOOL)loadFilesToArrayWithType: (NSString*)type
{
    if(pdfFiles){
        [pdfFiles release];
        pdfFiles = nil;
    }
    NSError *error = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *files = [fileManager contentsOfDirectoryAtPath:[FilesHelper documentsPath] error:&error];
    
    if(!error){
        pdfFiles = [[NSMutableArray alloc] init];
        for(NSString* file in files){
            if([file rangeOfString:PDF].location > 0)
                [pdfFiles addObject:file]; 
        }
        
        return TRUE;
    }
    
    return FALSE;
}
@end
