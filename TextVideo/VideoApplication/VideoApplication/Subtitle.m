//
//  Subtitle.m
//  VideoSubtitle
//
//  Created by Cuong Tran on 1/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Subtitle.h"

@implementation Subtitle
@synthesize name        = _name;
@synthesize listTimes   = _listTimes;

- (id)init {
    self = [super init];
    if (self) {
        _name = @"";
        _listTimes = [[NSMutableArray alloc] init];
    }
    return self;
}


+ (Subtitle *)initWithDictionary:(NSDictionary *)dic {
    Subtitle *subTitle = [[Subtitle alloc] init];
    subTitle.name = [dic objectForKey:@"name"];
    NSArray *array = [dic objectForKey:@"listTimes"];
    for (NSDictionary *timeDic in array) {
        Timeline *timeline = [Timeline initWithDictionary:timeDic];
        [subTitle.listTimes addObject:timeline];
        [timeline release];
    }
    return subTitle;
}


- (NSMutableDictionary *)toDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:_name forKey:@"name"];
    NSMutableArray *listTimeLine = [[NSMutableArray alloc] init];
    for (Timeline *timeLine in _listTimes) {
        [listTimeLine addObject:[timeLine toDictionary]];
    }
    [dic setObject:listTimeLine forKey:@"listTimes"];
    [listTimeLine release];
    return dic;
}


- (void)dealloc {
    [_name release];
    [_listTimes release];
}
@end
