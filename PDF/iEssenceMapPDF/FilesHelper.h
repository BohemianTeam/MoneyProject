//
//  FilesHelper.h
//  iEssenceMapPDF
//
//  Created by bohemian on 2/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#define PDF @".pdf"

@interface FilesHelper : NSObject
{
    NSMutableArray *pdfFiles;
}
@property(nonatomic, retain)NSMutableArray *pdfFiles;
+ (FilesHelper*) sharedFileHelper;
+ (NSString *)bundlePath:(NSString *)fileName;
+ (NSString*)documentsPath;
+ (NSString *)documentsPathWithFileName:(NSString *)fileName;

- (BOOL)loadFilesToArrayWithType: (NSString*)type;
+ (BOOL)copyFileFrom:(NSString*)pathRes toDes:(NSString*)pathDes;
@end
