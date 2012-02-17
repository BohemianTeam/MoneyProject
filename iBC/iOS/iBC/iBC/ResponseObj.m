//
//  ResponseObj.m
//  iBC
//
//  Created by bohemian on 2/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ResponseObj.h"
#import "CJSONDeserializer.h"

@implementation ResponseObj

//- (id)initWithString:(NSString*)resStr
//{
//    self = [super init];
//    if(self){
//        responseDict = [[NSDictionary alloc] init];
//    }
//    return self;
//}
- (id)initWithDataResponse:(NSData*)data
{
    self = [super init];
    if(self){
        NSError *err = nil;
        CJSONDeserializer *jsonDeserializer = [CJSONDeserializer deserializer];
        responseDict = [[NSDictionary alloc] initWithDictionary:(NSDictionary*)[jsonDeserializer deserializeAsDictionary:data error:&err]];
    }
    return self;
}
- (id)iniWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if(self){
        responseDict = [[NSDictionary alloc] initWithDictionary:dict];
    }
    return self;
}
- (void)dealloc
{
    [responseDict release];
    [super dealloc];
}
- (id)getObjectForKey:(NSString*)key
{
    id result = nil;
    result = [responseDict objectForKey:key];
    
    if(result == [NSNull null])
        return nil;
    return result;
}
@end
