//
//  VideoDatabase.m
//  VideoApplication
//
//  Created by bohemian on 2/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VideoDatabase.h"


@interface VideoDatabase (private)
- (void)updateSumOfRow;
- (void)createvideoIDArray;
- (sqlite3_stmt*) setupAndCompileStatement: (NSString*) stringQuery;
@end
@implementation VideoDatabase
@synthesize sumOfRow;
@synthesize dbPath;

///////
static VideoDatabase *__sharedDatabase = nil;
+ (VideoDatabase*) sharedDatabase
{
	if (__sharedDatabase == nil) {
		[[self alloc] init];
	}
    return __sharedDatabase;
}
+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (__sharedDatabase == nil) {
            __sharedDatabase = [super allocWithZone:zone];
            return __sharedDatabase;
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
/// open DB
- (void) openDB: (NSString*)path
{
    dbPath = path;
	if (sqlite3_open([path UTF8String], &database) == SQLITE_OK)
	{
		NSLog(@"open %@ successful..!", path);
        [self updateSumOfRow];
        [self createvideoIDArray];
	}
}
/// open DB
- (BOOL) openDB
{
	if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
	{
		[self updateSumOfRow];
		return TRUE;
	}
	return FALSE;
}

/// close DB
- (void) closeDB
{
	if (database)
		sqlite3_close(database);
}

// Setup the SQL Statement and compile it
- (sqlite3_stmt*) setupAndCompileStatement: (NSString*) stringQuery
{
	const char* query= [stringQuery UTF8String];
	sqlite3_stmt* statement;
	
	if (sqlite3_prepare_v2(database, query, -1, &statement, NULL) == SQLITE_OK)
		return statement;
	
	return 0;
}
/// updateSumOfRow
- (void) updateSumOfRow
{
	NSString *stringQuery = [NSString stringWithFormat:@"Select count(*) From %@", DBNAME];
	sqlite3_stmt *statement;
	sumOfRow = 0;
    
	if ((statement = [self setupAndCompileStatement: stringQuery]))
		if (sqlite3_step(statement) == SQLITE_ROW)
			sumOfRow = sqlite3_column_int(statement, 0);
    
	sqlite3_finalize(statement);
}
- (void)createvideoIDArray
{
    if(videoIDArray != nil)
        [videoIDArray release];
    videoIDArray = [[NSMutableArray alloc] init];
    NSString *stringQuery = [NSString stringWithFormat:@"Select id From %@", DBNAME];
	sqlite3_stmt *statement;
	
	if (statement = [self setupAndCompileStatement: stringQuery])
		while (sqlite3_step(statement) == SQLITE_ROW)
		{
			NSInteger videoID = sqlite3_column_int(statement, 0);
            [videoIDArray addObject:[NSNumber numberWithInt: videoID]];
		}
	
	sqlite3_finalize(statement);
    
    //update sumOfRow
    sumOfRow = [videoIDArray count];
}
#pragma - Looking database method
//////
- (NSString*) lookingVideoByIndexPath: (NSInteger)index
{
	NSInteger videoID = [[videoIDArray objectAtIndex:index] integerValue];
	return [self lookingVideoByVideoID: videoID];
}
//
- (NSString*) lookingVideoByVideoID: (NSInteger) videoID
{
	NSString *query = [NSString stringWithFormat:@"Select FileName From %@ Where ID = %i", DBNAME, videoID];
	sqlite3_stmt *statement;
	NSString *fileName = nil;
	
	if (statement = [self setupAndCompileStatement: query])
		if (sqlite3_step(statement) == SQLITE_ROW)
		{
			fileName = [[NSString alloc] initWithUTF8String:(char*) sqlite3_column_text(statement, 0)];
		}
	sqlite3_finalize(statement);
	
	return [fileName autorelease];
}
#pragma - Insert database method
- (BOOL) checkExistVideoID: (NSInteger)videoID
{
	NSString *existed = [self lookingVideoByVideoID:videoID];
    
    if(existed != nil)
        return TRUE;
    
    return FALSE;
}

//////
- (void) addNewVideo:(NSString*)fileName videoID: (NSInteger)videoID duration: (NSString*)duration
{
	//NSString *parserWord = [ParserData parserStringBeforeSearchInDatabase: word];
	//checking exist of newWord
	if ([self checkExistVideoID:videoID] == NO)
	{
		NSString *query = [[NSString alloc] initWithFormat:@"Insert Into %@(ID, FileName, Duration) values(?,?,?)", DBNAME];
		sqlite3_stmt *statement;		
		if ((statement = [self setupAndCompileStatement: query]))
		{
			sqlite3_bind_int(statement, 1, videoID);
			sqlite3_bind_text(statement, 2, [fileName UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(statement, 3, [duration UTF8String], -1, SQLITE_TRANSIENT);
			if (sqlite3_step(statement) == SQLITE_DONE)
                NSLog(@"insert into DB successful with id = %lld", sqlite3_last_insert_rowid(database));
		}
		sqlite3_finalize(statement);
		
		[query release];
        
        //update video ID array
		[videoIDArray addObject:[NSNumber numberWithInt:videoID]];
        sumOfRow = [videoIDArray count];
	}
}

@end
