//
//  AppDatabase.h
//  Bars
//
//  Created by bohemian on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"
@class CityObj;

@interface AppDatabase : NSObject
{
    sqlite3                 *database;
    NSString                *dbPath;
}
@property(nonatomic, retain) NSString           *dbPath;

+(AppDatabase*)sharedDatabase;
- (void) openDB: (NSString*)path;

//looking database
- (NSInteger)lookingSumStates;
- (NSString*)lookingStateByStateID: (NSInteger)stateID;

- (NSInteger)lookingSumCitysInState: (NSInteger)stateID;
- (NSArray*)lookingCitysByStateID:(NSInteger)stateID;
- (CityObj*)lookingCityByCityID: (NSInteger)cityID;

- (NSInteger)lookingSumBarsInCity:(NSInteger)cityID;
- (NSArray*)lookingBarsByCityID:(NSInteger)cityID;
- (NSString*)lookingBarByBarID:(NSInteger)barID;

//
//- (NSArray*) lookingDataByIndexPath: (NSInteger) index;
//- (NSArray*) lookingDataByVideoID: (NSInteger) videoID;
//
////insert database
//- (BOOL) checkExistVideoID: (NSInteger)videoID;
//- (void) addNewVideo:(NSString*)fileName videoID: (NSInteger)videoID duration: (NSString*)duration;
@end
