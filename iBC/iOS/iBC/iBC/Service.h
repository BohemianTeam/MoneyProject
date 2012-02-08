//
//  Service.h
//  VideoApplication
//
//  Created by Cuong Tran on 1/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *MBErrorDomain;
static NSError *mb_err(int code) {
    return [NSError errorWithDomain:MBErrorDomain code:code userInfo:nil];
}

typedef enum {
    ActionTypeNone = 0,
    ActionTypeGetVideo,
    ActionTypeGetAllVideo,
    ActionTypeGetStatus,
} ActionType;

typedef enum {
    StatusCodeSuccess                   = 0,
    StatusCodeFailed                    = 1,
    StatusCodeNetworkUnavailable        = 90,
    StatusCodeUnknown                   = 100
} StatusCode;


@interface Service : NSObject {
    id                  _delegate;
    BOOL                _connecting;
    NSURLConnection     *_connection;
    NSMutableData       *_buffer;
    
    ActionType          _action;
    BOOL                _canShowAlert;
    BOOL                _canShowLoading;
    
    int                 _timeout;
    NSTimer             *_timer;
    
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) BOOL connecting;
@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, retain) NSMutableData * buffer;
@property (nonatomic, assign) ActionType action;
@property (nonatomic, assign) BOOL canShowAlert;
@property (nonatomic, assign) BOOL canShowLoading;
@property (nonatomic, assign) int timeout;


- (void) getVideo:(NSString *) title;
- (void) getAllVideo;
- (void) getStatus;
- (void) stop;
@end
