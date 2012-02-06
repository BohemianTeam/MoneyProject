//
//  Timeline.m
//  VideoSubtitle
//
//  Created by Cuong Tran on 1/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Timeline.h"

@implementation Timeline
@synthesize index   =  _index;
@synthesize time    = _time;
@synthesize text    = _text;

- (id)init {
    self = [super init];
    if (self) {
        _index = 0;
        _text = @"";
        _time = 0;
    }
    return self;
}


+ (Timeline *)initWithDictionary:(NSDictionary *)dic {
    Timeline *timeLine = [[Timeline alloc] init];
    timeLine.index = [[dic objectForKey:@"index"] intValue];
    timeLine.text = [dic objectForKey:@"text"];
    timeLine.time = [[dic objectForKey:@"time"] doubleValue];
    return timeLine;
}


- (NSMutableDictionary *)toDictionary; {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[NSNumber numberWithInt:_index] forKey:@"index"];
    [dic setObject:_text forKey:@"text"];
    [dic setObject:[NSNumber numberWithDouble:_time] forKey:@"time"];
    return  dic;
}


- (void)dealloc {
    [_text release];
    [super dealloc];
}
@end
