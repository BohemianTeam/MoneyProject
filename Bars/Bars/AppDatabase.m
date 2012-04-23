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
		[[[self alloc] init] autorelease];
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
#pragma mark - database setup
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
#pragma mark - Looking database method
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
    NSString *query = [NSString stringWithFormat:@"Select name From %@ Where id = %d", STATE_TABLE, stateID];
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
- (NSArray*)lookingCitysByCompleted
{
    NSMutableArray *citys = [[NSMutableArray alloc] init];
    NSString *stringQuery = [NSString stringWithFormat:@"Select id From %@ Where %@ = %d", CITY_TABLE, COMPLETE_COLUMN, TRUE];
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
    NSString *query = [NSString stringWithFormat:@"Select * From %@ Where id = %d", CITY_TABLE, cityID];
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
    NSString *query = [NSString stringWithFormat:@"Select * From %@ Where id = %d", BAR_TABLE, barID];
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
            NSInteger isComplete = sqlite3_column_int(statement, 6);

            BOOL ic = (isComplete == 0 ? FALSE : TRUE);
			bar = [[Bar alloc] initWithID:barID cityID:cityID name:name address:address info:info location:loca isCompleted:ic];
            
            [loca release];
            [info release];
            [address release];
            [name release];
		}
	sqlite3_finalize(statement);
	
	return [bar autorelease];
}

#pragma mark - update database
//update database method
- (BOOL)updateBar:(NSInteger)barID column:(NSString*)column value:(id)val
{
    NSString *stringQuery = nil;
    if([val isKindOfClass:[NSString class]])
    {
        NSString *valStr = (NSString*)val;
        stringQuery = [NSString stringWithFormat:@"Update %@ Set %@ = %@ Where id = %d", BAR_TABLE, column, valStr, barID];
    }else{
        NSInteger valInt = [val intValue];
        stringQuery = [NSString stringWithFormat:@"Update %@ Set %@ = %d Where id = %d", BAR_TABLE, column, valInt, barID];
    }
	sqlite3_stmt *statement = [self setupAndCompileStatement: stringQuery];
	BOOL result = NO;
    
	if (statement)
		if (sqlite3_step(statement) == SQLITE_ROW)
			result = YES;
	
	sqlite3_finalize(statement);
    
    return result;
}
- (BOOL)updateCity:(NSInteger)cityID column:(NSString*)column value:(id)val
{
    NSString *stringQuery = nil;
    if([val isKindOfClass:[NSString class]])
    {
        NSString *valStr = (NSString*)val;
        stringQuery = [NSString stringWithFormat:@"Update %@ Set %@ = %@ Where id = %d", CITY_TABLE, column, valStr, cityID];
    }else{
        NSInteger valInt = [val intValue];
        stringQuery = [NSString stringWithFormat:@"Update %@ Set %@ = %d Where id = %d", CITY_TABLE, column, valInt, cityID];
    }
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
    return [self updateCity:cityID column:WISHLIST_COLUMN value:[NSNumber numberWithBool:isWish]];
}

- (BOOL)updateCity:(NSInteger)cityID withCompleted:(BOOL)isCompleted {
    return [self updateCity:cityID column:COMPLETE_COLUMN value:[NSNumber numberWithBool:isCompleted]];
}

- (BOOL) updateFinishTourCity:(NSInteger)cityID {
    NSArray * bars = [self lookingBarsByCityID:cityID];
    BOOL isCompleted = TRUE;
    for (NSNumber *barID in bars) {
        Bar *bar = [self lookingBarByBarID:[barID intValue]];
        if (!bar.isCompleted) {
            isCompleted =  FALSE;
            break;
        }
    }
    
    if (isCompleted) {
        return [self updateCity:cityID withCompleted:isCompleted];
    }
    
    return FALSE;
}

- (BOOL)updateBar:(NSInteger)barID isComplete:(BOOL)isComp
{
    return [self updateBar:barID column:COMPLETE_COLUMN value:[NSNumber numberWithBool:isComp]];
}
- (BOOL)updateBar:(NSInteger)barID withLocation:(NSString*)loca
{
    return [self updateBar:barID column:LOCATION_COLUMN value:loca];
}

- (BOOL)haveLocationBar:(NSInteger)barID
{
    NSString *query = [NSString stringWithFormat:@"Select location From %@ Where id = %d", BAR_TABLE, barID];
    sqlite3_stmt *statement = [self setupAndCompileStatement: query];
    NSString *loca = nil;
    if (statement)
        if (sqlite3_step(statement) == SQLITE_ROW)
        {
            loca = [[NSString alloc] initWithUTF8String:(char*) sqlite3_column_text(statement, 0)];
        }
    sqlite3_finalize(statement);
    
    if(loca == nil)
        return NO;
    else{
        if([loca isEqual:@"~"]){
            [loca release];
            return NO;
        }
            
    }
    [loca release];
    return YES;
}


@end