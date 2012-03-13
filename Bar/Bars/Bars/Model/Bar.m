//
//  Bar.m
//  Bars
//
//  Created by Cuong Tran on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Bar.h"

@implementation Bar
@synthesize cityID, barID;
@synthesize barInfo, barName, barAddress, barLocation;

- (id)initWithID:(NSInteger)barId cityID:(NSInteger)cityId name:(NSString*)name address:(NSString*)addr info:(NSString*)info location:(NSString*)loca
{
    if(self = [super init]){
        barID = barId;
        cityID = cityId;
        barName = [name retain];
        barAddress = [addr retain];
        barInfo = [info retain];
        barLocation = [loca retain];
    }
    
    return self;
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
