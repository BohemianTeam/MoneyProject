//
//  Timeline.h
//  VideoSubtitle
//
//  Created by Cuong Tran on 1/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Timeline : NSObject {
   int               _index;
    NSTimeInterval   _time;
    NSString        *_text;
}
@property (nonatomic, assign) int                index;
@property (nonatomic, assign) NSTimeInterval     time;
@property (nonatomic, retain) NSString          *text;

+ (Timeline *)initWithDictionary:(NSDictionary *)dic;
- (NSMutableDictionary *)toDictionary;
@end
