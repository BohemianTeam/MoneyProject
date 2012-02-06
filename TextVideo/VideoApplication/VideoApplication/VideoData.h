//
//  VideoData.h
//  VideoApplication
//
//  Created by Cuong Tran on 1/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoData : NSObject {
    NSString            *_id;
    NSString            *_title;
    NSString            *_desc;
    NSString            *_url;
    NSString            *_subUrl;
    NSString            *_timelineUrl;
    BOOL                _isSuccess;
    NSString            *_localPathVideo;
    NSString            *_localPathSub;
    NSString            *_localPathTimeline;
}
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *desc;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSString *subUrl;
@property (nonatomic, retain) NSString *timelineUrl;
@property (nonatomic, assign) BOOL isSuccess;
@property (nonatomic, retain) NSString *mid;
@property (nonatomic, retain) NSString *localPathVideo;
@property (nonatomic, retain) NSString *localPathSub;
@property (nonatomic, retain) NSString *localPathTimeline;

- (void) searchLocalPath;
@end
