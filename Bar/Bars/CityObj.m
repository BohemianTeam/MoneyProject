//
//  CityObj.m
//  Bars
//
//  Created by bohemian on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CityObj.h"

@implementation CityObj
@synthesize cityID, stateID;
@synthesize cityName, cityPrice;
@synthesize isWishlist, isCompleted;

- (id)initWithID:(NSInteger)cityId stateID:(NSInteger)stateId name:(NSString*)name price:(NSString*)price complete:(BOOL)comp wish:(BOOL)wish
{
    self = [super init];
    if(self)
    {
        cityID = cityId;
        stateID = stateId;
        cityName = [[NSString alloc] initWithString:name];
        cityPrice = [[NSString alloc] initWithString:price];
        isWishlist = wish;
        isCompleted = comp;
    }
    
    return  self;
}
- (void)dealloc
{
    [cityPrice release];
    [cityName release];
    [super dealloc];
}
- (NSString*)getName
{
    return cityName;
}
@end
