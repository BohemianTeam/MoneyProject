//
//  ListVideoData.m
//  VideoApplication
//
//  Created by Cuong Tran on 1/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ListVideoData.h"

@implementation ListVideoData
@synthesize status = _status;
@synthesize videos = _videos;

- (id)init {
    if (self = [super init]) {
        _videos = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) dealloc {
    [_status release];
    [_videos release];
    [super dealloc];
}
@end
