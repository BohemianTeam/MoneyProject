//
//  VideoDatabase.h
//  VideoApplication
//
//  Created by bohemian on 2/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"

@interface VideoDatabase : NSObject
{
    sqlite3                 *database;
    NSString                *dbPath;
    NSMutableArray          *videoIDArray;  //using looking up video data by indexPath
    
    NSInteger               sumOfRow;
}
@property(nonatomic, assign) NSInteger          sumOfRow;
@property(nonatomic, retain) NSString           *dbPath;

+(VideoDatabase*)sharedDatabase;
- (void) openDB: (NSString*)path;

//looking database
- (NSString*) lookingVideoByIndexPath: (NSInteger)index;
- (NSString*) lookingVideoByVideoID: (NSInteger) videoID;

//insert database
- (BOOL) checkExistVideoID: (NSInteger)videoID;
- (void) addNewVideo:(NSString*)fileName videoID: (NSInteger)videoID duration: (NSString*)duration;
@end
