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
    NSString *addHtml = (NSString*)[super getObjectForKey:Address];
    addHtml = [addHtml stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSLog(@"1: %@", addHtml);
    addHtml = [addHtml stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];
    NSLog(@"2: %@", addHtml);
    addHtml = [addHtml stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
    NSLog(@"3: %@", addHtml);
    addHtml = [addHtml stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
    return addHtml;
}
- (NSArray*)getImgs
{
    return (NSArray*)[super getObjectForKey:Images];
}
- (NSString*)getPhone
{
    return (NSString*)[super getObjectForKey:Phone];
}
- (NSString*)getEmail
{
    NSString *email = (NSString*)[super getObjectForKey:Email];
    if(email != nil && ![email isEqual:@""])
        return email;
    return @"None email";
}
- (NSString*)getWeb
{
    return (NSString*)[super getObjectForKey:WebAdd];
}
- (NSString*)getDistanceOrCity
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
- (NSString*)getDescription
{
    return (NSString*)[super getObjectForKey:Description];
}
- (NSString*)getCoordinates
{
    return (NSString*)[super getObjectForKey:Coordinates];
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
