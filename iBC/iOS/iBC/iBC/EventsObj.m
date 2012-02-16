//
//  EventsObj.m
//  iBC
//
//  Created by bohemian on 2/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EventsObj.h"

@implementation EventsObj
- (id)iniWithDictionary:(NSDictionary*)dict
{
    self = [super iniWithDictionary:dict];
    if(self){
        imgLogo = nil;
    }
    return self;
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
- (void)dealloc
{
    [imgLogo release];
    [super dealloc];
}
- (void)setImageLogo:(UIImage*)img
{
    imgLogo = img;
}
@end
