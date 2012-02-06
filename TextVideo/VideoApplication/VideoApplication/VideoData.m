//
//  VideoData.m
//  VideoApplication
//
//  Created by Cuong Tran on 1/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VideoData.h"
#import "Util.h"
@implementation VideoData
@synthesize title = _title;
@synthesize desc = _desc;
@synthesize url = _url;
@synthesize subUrl = _subUrl;
@synthesize timelineUrl = _timelineUrl;
@synthesize isSuccess = _isSuccess;
@synthesize mid = _id;
@synthesize localPathVideo = _localPathVideo;
@synthesize localPathSub = _localPathSub;
@synthesize localPathTimeline = _localPathTimeline;

- (void) searchLocalPath {
    NSString * hash = [Util calcMD5:self.title];
    NSString * dir = [Util getVideoDir];
    NSString * path = [dir stringByAppendingString:[NSString stringWithFormat:@"/%@", hash]];
    if ([Util checkFileExits:path]) {
        self.localPathVideo = path;
    }
    dir = [Util getTimeLineDir];
    path = [dir stringByAppendingString:[NSString stringWithFormat:@"/%@", hash]];
    if ([Util checkFileExits:path]) {
        self.localPathTimeline = path;
    }
    dir = [Util getSubDir];
    path = [dir stringByAppendingString:[NSString stringWithFormat:@"/%@", hash]];
    if ([Util checkFileExits:path]) {
        self.localPathSub = path;
    }

}

- (void) dealloc {
    [_title release];
    [_desc release];
    [_url release];
    [_timelineUrl release];
    [_subUrl release];
    [_id release];
    [_localPathVideo release];
    [_localPathTimeline release];
    [_localPathSub release];
    [super dealloc];
}
@end
