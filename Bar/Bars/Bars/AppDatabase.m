//
//  AppDatabase.m
//  Bars
//
//  Created by bohemian on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDatabase.h"
#import "Config.h"
#import "CityObj.h"
#import "Bar.h"

@interface AppDatabase (private)
- (sqlite3_stmt*) setupAndCompileStatement: (NSString*) stringQuery;
- (BOOL)updateCity:(NSInteger)cityID column:(NSString*)column value:(int)val;
@end
@implementation AppDatabase
@synthesize dbPath;

///////
static AppDatabase *__sharedDatabase = nil;
+ (AppDatabase*) sharedDatabase
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
	}
}
/// open DB
- (BOOL) openDB
{
	if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
	{
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
#pragma - Looking database method
//looking states
- (NSInteger)lookingSumStates
{
    NSString *stringQuery = [NSString stringWithFormat:@"Select count(*) From %@", STATE_TABLE];
	sqlite3_stmt *statement = [self setupAndCompileStatement: stringQuery];
	NSInteger sumStates = 0;
    
	if (statement)
		if (sqlite3_step(statement) == SQLITE_ROW)
			sumStates = sqlite3_column_int(statement, 0);
	
	sqlite3_finalize(statement);
    
    return sumStates;
}
- (NSString*)lookingStateByStateID: (NSInteger)stateID
{
    NSString *query = [NSString stringWithFormat:@"Select name From %@ Where id = %i", STATE_TABLE, stateID];
	sqlite3_stmt *statement = [self setupAndCompileStatement: query];
	NSString *stateName = nil;
	
	if (statement)
		if (sqlite3_step(statement) == SQLITE_ROW)
		{
			stateName = [[NSString alloc] initWithUTF8String:(char*) sqlite3_column_text(statement, 0)];
		}
	sqlite3_finalize(statement);
	
	return [stateName autorelease];
}

//looking city
- (NSInteger)lookingSumCitysInState: (NSInteger)stateID
{
    NSString *stringQuery = [NSString stringWithFormat:@"Select count(*) From %@ where state_id = %d", STATE_TABLE, stateID];
	sqlite3_stmt *statement = [self setupAndCompileStatement: stringQuery];
	NSInteger sumCitys = 0;
    
	if (statement)
		if (sqlite3_step(statement) == SQLITE_ROW)
			sumCitys = sqlite3_column_int(statement, 0);
	
	sqlite3_finalize(statement);
    
    return sumCitys;
}
- (NSArray*)lookingCitysByStateID:(NSInteger)stateID
{
    NSMutableArray *citys = [[NSMutableArray alloc] init];
    NSString *stringQuery = [NSString stringWithFormat:@"Select id From %@ Where state_id = %d", CITY_TABLE, stateID];
	sqlite3_stmt *statement = [self setupAndCompileStatement: stringQuery];
	
	if (statement){
		while (sqlite3_step(statement) == SQLITE_ROW)
		{
			NSInteger cityID = sqlite3_column_int(statement, 0);
            [citys addObject:[NSNumber numberWithInt: cityID]];
		}
	}
	sqlite3_finalize(statement);
    
    
    return [citys autorelease];
}
- (NSArray*)lookingCitysByWish
{
    NSMutableArray *citys = [[NSMutableArray alloc] init];
    NSString *stringQuery = [NSString stringWithFormat:@"Select id From %@ Where %@ = %d", CITY_TABLE, WISHLIST_COLUMN, TRUE];
	sqlite3_stmt *statement = [self setupAndCompileStatement: stringQuery];
	
	if (statement){
		while (sqlite3_step(statement) == SQLITE_ROW)
		{
			NSInteger cityID = sqlite3_column_int(statement, 0);
            [citys addObject:[NSNumber numberWithInt: cityID]];
		}
	}
	sqlite3_finalize(statement);
    
    
    return [citys autorelease];
}
- (CityObj*)lookingCityByCityID: (NSInteger)cityID
{
    NSString *query = [NSString stringWithFormat:@"Select * From %@ Where id = %i", CITY_TABLE, cityID];
	sqlite3_stmt *statement = [self setupAndCompileStatement: query];
	CityObj *city = nil;
	if (statement)
		if (sqlite3_step(statement) == SQLITE_ROW)
		{
            NSString  *name = [[NSString alloc] initWithUTF8String:(char*) sqlite3_column_text(statement, 1)];
            NSString  *price = [[NSString alloc] initWithUTF8String:(char*) sqlite3_column_text(statement, 2)];
            BOOL       isComplete = sqlite3_column_int(statement, 3);
            BOOL       isWish = sqlite3_column_int(statement, 4);
            NSInteger stateID = sqlite3_column_int(statement, 6);
			city = [[CityObj alloc] initWithID:cityID 
                                       stateID:stateID 
                                          name:name 
                                         price:price 
                                      complete:isComplete 
                                          wish:isWish];
            
            [price release];
            [name release];
		}
	sqlite3_finalize(statement);
	
	return [city autorelease];
}
//looking bars
- (NSInteger)lookingSumBarsInCity:(NSInteger)cityID
{
    NSString *stringQuery = [NSString stringWithFormat:@"Select count(*) From %@ where city_id = %d", BAR_TABLE, cityID];
	sqlite3_stmt *statement = [self setupAndCompileStatement: stringQuery];
	NSInteger sumBars = 0;
    
	if (statement)
		if (sqlite3_step(statement) == SQLITE_ROW)
			sumBars = sqlite3_column_int(statement, 0);
	
	sqlite3_finalize(statement);
    
    return sumBars;
}
- (NSArray*)lookingBarsByCityID:(NSInteger)cityID
{
    NSMutableArray *bars = [[NSMutableArray alloc] init];
    NSString *stringQuery = [NSString stringWithFormat:@"Select id From %@ Where city_id = %d", BAR_TABLE, cityID];
	sqlite3_stmt *statement = [self setupAndCompileStatement: stringQuery];
	
	if (statement){
		while (sqlite3_step(statement) == SQLITE_ROW)
		{
			NSInteger barID = sqlite3_column_int(statement, 0);
            [bars addObject:[NSNumber numberWithInt: barID]];
		}
	}
	sqlite3_finalize(statement);
    
    
    return [bars autorelease];
}
- (Bar*)lookingBarByBarID:(NSInteger)barID
{
    NSString *query = [NSString stringWithFormat:@"Select * From %@ Where id = %i", BAR_TABLE, barID];
	sqlite3_stmt *statement = [self setupAndCompileStatement: query];
	Bar *bar = nil;
	if (statement)
		if (sqlite3_step(statement) == SQLITE_ROW)
		{
            NSString  *name = [[NSString alloc] initWithUTF8String:(char*) sqlite3_column_text(statement, 1)];
            NSString  *address = [[NSString alloc] initWithUTF8String:(char*) sqlite3_column_text(statement, 2)];
            NSString  *info = [[NSString alloc] initWithUTF8String:(char*) sqlite3_column_text(statement, 3)];
            NSInteger cityID = sqlite3_column_int(statement, 4);
            NSString  *loca = [[NSString alloc] initWithUTF8String:(char*) sqlite3_column_text(statement, 5)];
            
			bar = [[Bar alloc] initWithID:barID cityID:cityID name:name address:address info:info location:loca];
            
            [loca release];
            [info release];
            [address release];
            [name release];
		}
	sqlite3_finalize(statement);
	
	return [bar autorelease];
}

//update database method
- (BOOL)updateCity:(NSInteger)cityID column:(NSString*)column value:(int)val
{
    NSString *stringQuery = [NSString stringWithFormat:@"Update %@ Set %@ = %d Where id = %d", CITY_TABLE, column, val, cityID];
	sqlite3_stmt *statement = [self setupAndCompileStatement: stringQuery];
	BOOL result = NO;
    
	if (statement)
		if (sqlite3_step(statement) == SQLITE_ROW)
			result = YES;
	
	sqlite3_finalize(statement);
    
    return result;
}
- (BOOL)updateCity:(NSInteger)cityID withWish:(BOOL)isWish
{
    return [self updateCity:cityID column:WISHLIST_COLUMN value:isWish];
}
//- (NSArray*) lookingDataByIndexPath: (NSInteger) index
//{
//    NSInteger videoID = [[videoIDArray objectAtIndex:index] integerValue];
//	return [self lookingDataByVideoID: videoID];
//}
//- (NSArray*) lookingDataByVideoID: (NSInteger) videoID
//{
//    NSString *query = [NSString stringWithFormat:@"Select * From %@ Where ID = %i", DBNAME, videoID];
//	sqlite3_stmt *statement;
//	NSMutableArray *datas = [[[NSMutableArray alloc] init] autorelease];
//	
//	if (statement = [self setupAndCompileStatement: query])
//		if (sqlite3_step(statement) == SQLITE_ROW)
//		{
//            //video ID
//            [datas addObject:[NSNumber numberWithInt:videoID]];
//            //filename
//			[datas addObject:[NSString stringWithUTF8String:(char*) sqlite3_column_text(statement, 1)]];
//            //duration
//            [datas addObject:[NSString stringWithUTF8String:(char*) sqlite3_column_text(statement, 2)]];
//		}
//	sqlite3_finalize(statement);
//	
//	return datas;
//}
//#pragma - Insert database method
//- (BOOL) checkExistVideoID: (NSInteger)videoID
//{
//	NSString *existed = [self lookingVideoByVideoID:videoID];
//    
//    if(existed != nil)
//        return TRUE;
//    
//    return FALSE;
//}
//
////////
//- (void) addNewVideo:(NSString*)fileName videoID: (NSInteger)videoID duration: (NSString*)duration
//{
//	//NSString *parserWord = [ParserData parserStringBeforeSearchInDatabase: word];
//	//checking exist of newWord
//	if ([self checkExistVideoID:videoID] == NO)
//	{
//		NSString *query = [[NSString alloc] initWithFormat:@"Insert Into %@(ID, FileName, Duration) values(?,?,?)", DBNAME];
//		sqlite3_stmt *statement;		
//		if ((statement = [self setupAndCompileStatement: query]))
//		{
//			sqlite3_bind_int(statement, 1, videoID);
//			sqlite3_bind_text(statement, 2, [fileName UTF8String], -1, SQLITE_TRANSIENT);
//			sqlite3_bind_text(statement, 3, [duration UTF8String], -1, SQLITE_TRANSIENT);
//			if (sqlite3_step(statement) == SQLITE_DONE)
//                NSLog(@"insert into DB successful with id = %lld", sqlite3_last_insert_rowid(database));
//		}
//		sqlite3_finalize(statement);
//		
//		[query release];
//        
//        //update video ID array
//		[videoIDArray addObject:[NSNumber numberWithInt:videoID]];
//        sumOfRow = [videoIDArray count];
//	}
//}

@end