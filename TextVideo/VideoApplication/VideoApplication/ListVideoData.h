//
//  ListVideoData.h
//  VideoApplication
//
//  Created by Cuong Tran on 1/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListVideoData : NSObject {
    NSString                *_status;
    NSMutableArray          *_videos;
}

@property (nonatomic, retain) NSString *status;
@property (nonatomic, retain) NSMutableArray *videos;
@end
