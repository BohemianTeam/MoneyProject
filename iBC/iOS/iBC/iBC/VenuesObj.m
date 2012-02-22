//
//  VenuesObj.m
//  iBC
//
//  Created by bohemian on 2/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VenuesObj.h"
#import "config.h"

@implementation VenuesObj
@synthesize imgLogo;

- (id)iniWithDictionary:(NSDictionary*)dict
{
    self = [super iniWithDictionary:dict];
    if(self){
        imgLogo = nil;
    }
    return self;
}
- (NSString*)getName
{
    NSString *name = (NSString*)[super getObjectForKey:VenueName];
    if(name != nil)
        return [name uppercaseString];
    
    return @"";
}
- (NSString*)getAddress
{
    NSString *add = (NSString*)[super getObjectForKey:Distance];
    if(add){
        return add;
    }
  
    add = (NSString*)[super getObjectForKey:City];
    
    if(add)
        return add;
    
    return @""; 
}
- (NSString*)getLogoUrl
{
    return (NSString*)[super getObjectForKey:Logo];
}
- (NSString*)getVenueCode
{
    return (NSString*)[super getObjectForKey:VenueCode];
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
