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
@class Bar;

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
- (NSArray*)lookingCitysByWish;
- (NSArray*)lookingCitysByCompleted;
- (CityObj*)lookingCityByCityID: (NSInteger)cityID;

- (NSInteger)lookingSumBarsInCity:(NSInteger)cityID;
- (NSArray*)lookingBarsByCityID:(NSInteger)cityID;
- (Bar*)lookingBarByBarID:(NSInteger)barID;

//update database
- (BOOL)updateCity:(NSInteger)cityID withWish:(BOOL)isWish;
- (BOOL)updateCity:(NSInteger)cityID withCompleted:(BOOL) isCompleted;
- (BOOL)updateFinishTourCity:(NSInteger) cityID;
- (BOOL)updateCity:(NSInteger)cityID column:(NSString*)column value:(id)val;
- (BOOL)updateBar:(NSInteger)barID column:(NSString*)column value:(id)val;
- (BOOL)updateBar:(NSInteger)barID isComplete:(BOOL)isComp;
- (BOOL)updateBar:(NSInteger)barID withLocation:(NSString*)loca;

//checking database
- (BOOL)haveLocationBar:(NSInteger)barID;

//
//- (NSArray*) lookingDataByIndexPath: (NSInteger) index;
//- (NSArray*) lookingDataByVideoID: (NSInteger) videoID;
//
////insert database
//- (BOOL) checkExistVideoID: (NSInteger)videoID;
//- (void) addNewVideo:(NSString*)fileName videoID: (NSInteger)videoID duration: (NSString*)duration;
@end
