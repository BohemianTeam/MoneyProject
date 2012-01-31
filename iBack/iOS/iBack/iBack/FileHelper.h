//
//  FileHelper.h
//  iBack
//
//  Created by bohemian on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileHelper : NSObject
{
    NSString        *saveFolderPath;
}
@property(nonatomic, retain)NSString        *saveFolderPath;

+ (FileHelper*) sharedFileHelper;
- (void)initFileHelper;
- (NSArray*)getFilesInFolder;
- (NSString*)createFullFilePath:(NSString*)file;
- (BOOL)deleteFileAtPath:(NSString*)path;
- (void)deleteFileAtPaths:(NSArray*)paths;
- (BOOL)renameFileAtPath:(NSString*)path withName:(NSString*)name withType:(NSInteger)type;
@end
