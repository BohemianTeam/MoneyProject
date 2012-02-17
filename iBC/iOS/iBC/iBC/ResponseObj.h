//
//  ResponseObj.h
//  iBC
//
//  Created by bohemian on 2/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ResponseObj : NSObject
{
    NSDictionary    *responseDict;
}
//@property(nonatomic, readonly)NSDictionary    *responseDict;
- (id)iniWithDictionary:(NSDictionary*)dict;
- (id)initWithDataResponse:(NSData*)data;
- (id)getObjectForKey:(NSString*)key;
@end
