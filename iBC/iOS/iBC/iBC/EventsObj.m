//
//  EventsObj.m
//  iBC
//
//  Created by bohemian on 2/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EventsObj.h"

@implementation EventsObj
@synthesize imgLogo;
- (id)iniWithDictionary:(NSDictionary*)dict
{
    self = [super iniWithDictionary:dict];
    if(self){
        imgLogo = nil;
    }
    return self;
}
- (NSString*)getCode
{
    return (NSString*)[super getObjectForKey:EventCode];
}
- (NSString*)getTitle
{
    NSString *title = (NSString*)[super getObjectForKey:Title];
    if(title != nil)
        return [title uppercaseString];
    
    return @"";
}
- (NSString*)getName
{
    NSString *name = (NSString*)[super getObjectForKey:VenueName];
    if(name != nil)
        return name;
    
    return @"";
}
- (NSString*)getDates
{
    NSString *dates = (NSString*)[super getObjectForKey:Dates];
    if(dates != nil)
    {
        NSArray *splits = [dates componentsSeparatedByString:@" "];
        return [splits lastObject];
    }
    return @"";
}
- (NSString*)getPrice
{
    NSString *price = (NSString*)[super getObjectForKey:Price];
    if(price != nil)
        return price;
    
    return @"";
}
- (NSString*)getLogoUrl
{
    return (NSString*)[super getObjectForKey:Logo];
}
- (NSString*)getGenre
{
    return (NSString*)[super getObjectForKey:Genre];
}
- (NSString*)getSynopsis
{
    return (NSString*)[super getObjectForKey:Synopsis];
}
- (NSArray*)getImgs
{
    return (NSArray*)[super getObjectForKey:Images];
}
- (NSArray*)getInfoBlocks
{
    return (NSArray*)[super getObjectForKey:InfoBlocks];
}
- (void)dealloc
{
    [imgLogo release];
    [super dealloc];
}

#pragma - SetImageDownload delegate
- (void)setImage:(UIImage*)img
{
    imgLogo = [img retain];
}
@end
