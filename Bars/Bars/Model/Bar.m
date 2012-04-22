//
//  Bar.m
//  Bars
//
//  Created by Cuong Tran on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Bar.h"
#import "AppDatabase.h"

@implementation Bar
@synthesize cityID, barID;
@synthesize barInfo, barName, barAddress, barLocation;
@synthesize isCompleted;

- (id)initWithID:(NSInteger)barId cityID:(NSInteger)cityId name:(NSString*)name address:(NSString*)addr info:(NSString*)info location:(NSString*)loca isCompleted:(BOOL)isComplete
{
    if(self = [super init]){
        barID = barId;
        cityID = cityId;
        barName = [name retain];
        barAddress = [addr retain];
        barInfo = [info retain];
        barLocation = [loca retain];
        isCompleted = isComplete;
    }
    
    return self;
}
- (void)setBarIsCompleted
{
    isCompleted = true;
    [[AppDatabase sharedDatabase] updateBar:barID isComplete:TRUE];
    
    BOOL isCityComplete = [[AppDatabase sharedDatabase] updateFinishTourCity:cityID];
    if (isCityComplete) {
        NSLog(@"city tour completed");
    }
//    if([[AppDatabase sharedDatabase] updateBar:barID isComplete:TRUE])
//        isCompleted = true;
}
- (void)dealloc
{
    [barName release];
    [barAddress release];
    [barInfo release];
    [barLocation release];
    
    [super dealloc];
}
@end
