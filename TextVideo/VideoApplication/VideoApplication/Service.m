//
//  Service.m
//  VideoApplication
//
//  Created by Cuong Tran on 1/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Service.h"
#import "Util.h"
#import "ListVideoData.h"

NSString *MBErrorDomain = @"com.video";
@interface Service ()

- (NSString *)joinParameters:(NSDictionary *)params;
- (void)processData:(NSData *)data;
- (BOOL)doRequestWithURL:(NSString *)urlString params:(NSDictionary *)pValues;
- (BOOL)doRequestWithURL:(NSString *)urlString params:(NSDictionary *)pValues isPost:(BOOL)isPost;
- (BOOL)doRequestWithURL:(NSString *)urlString params:(NSDictionary *)pValues isPost:(BOOL)isPost headers:(NSDictionary *)headers;
- (void)stopTimerIfNeeded;
- (void)processError:(NSError *)error;

@end
@implementation Service
@synthesize action			= _action;
@synthesize delegate		= _delegate;
@synthesize connecting		= _connecting;
@synthesize connection		= _connection;
@synthesize buffer			= _buffer;
@synthesize canShowAlert    = _canShowAlert;
@synthesize canShowLoading  = _canShowLoading;
@synthesize timeout         = _timeout;

- (id) init {
    self = [super init];
    if (self) {
        self.connecting = FALSE;
        self.buffer = nil;
        self.delegate = nil;
        self.timeout = 10;
        self.canShowAlert = TRUE;
        self.canShowLoading = TRUE;
        self.action = ActionTypeNone;
    }
    return self;
}

- (void) getVideo:(NSString *)title {
    self.action = ActionTypeGetVideo;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:title forKey:@"title"];
    NSString *url = [NSString stringWithFormat:@"%@/api/v1/get_video_by_title",API_URL];
    [self doRequestWithURL:url params:params isPost:YES];
    [params release];
}


- (void) getAllVideo {
    self.action = ActionTypeGetAllVideo;
    
    NSString *url = [NSString stringWithFormat:@"%@/getvideo.php",API_URL];
    [self doRequestWithURL:url params:nil];
}
#pragma service processing
- (void)reset {
    [self stopTimerIfNeeded];
    if (self.connecting) {
        if (self.canShowLoading) {
            [[UIApplication sharedApplication] showNetworkActivityIndicatorVisible:FALSE];
        }
    }
    self.connecting = FALSE;
    self.action = ActionTypeNone;
    if (_connection) {
        [_connection cancel];
        [_connection release];
        _connection = nil;
    }    
    if (_buffer) {
        [_buffer release];
        _buffer = nil;
    }
}


- (void)stop {
    self.delegate = nil;
    [self reset];
}


- (void)stopTimerIfNeeded {
    if (_timer) {
        [_timer invalidate];
        [_timer release];
        _timer = nil;
    }
}


- (void)startTimer {
    _timer = [[NSTimer timerWithTimeInterval:self.timeout
                                      target:self
                                    selector:@selector(didTimeOut)
                                    userInfo:nil
                                     repeats:NO] retain];
    [[NSRunLoop mainRunLoop] addTimer:_timer 
                              forMode:NSDefaultRunLoopMode];
}


- (void)didTimeOut {
    if (self.connecting) {
        [self processError:mb_err(408)]; // time out
    }
}


- (BOOL)doRequestWithURL:(NSString *)urlString params:(NSDictionary *)params isPost:(BOOL)isPost {
    return [self doRequestWithURL:urlString params:params isPost:isPost headers:nil];
}


- (BOOL)doRequestWithURL:(NSString *)urlString params:(NSDictionary *)params {
    return [self doRequestWithURL:urlString params:params isPost:FALSE headers:nil];
}


- (BOOL)doRequestWithURL:(NSString *)urlString params:(NSDictionary *)pValues isPost:(BOOL)isPost headers:(NSDictionary *)headers {
    [self stopTimerIfNeeded];
    
    NSString *paramsString = [self joinParameters:pValues];  
	NSString *newURL;
	if(pValues)
		newURL = (isPost ? urlString : [NSString stringWithFormat:@"%@?%@", urlString, paramsString]);
	else {
		newURL = (isPost ? urlString : [NSString stringWithFormat:@"%@", urlString]);
	}
    if (_buffer) {
        [_buffer release];
        _buffer = nil;
    }
    if (_connection) {
        [_connection cancel];
        [_connection release];
        _connection = nil;
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:newURL]
                                                                cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                            timeoutInterval:self.timeout];    
    [request setHTTPMethod:(isPost) ? @"POST" : @"GET"];

    if (isPost) {
        NSData *data = [[NSData alloc] initWithBytes:[paramsString UTF8String] length:[paramsString length]];    
        [request setHTTPBody:data];
        [data release];
    }
    if (headers) {
        NSArray *keys = [headers allKeys];
        for (NSString *key in keys) {
            [request setValue:[headers objectForKey:key] forHTTPHeaderField:key];
        }
    }
	_buffer = [[NSMutableData alloc] init];
    _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [request release];
    
    if (_connection) {
        _connecting = TRUE;
        if (self.canShowLoading) {
            [[UIApplication sharedApplication] showNetworkActivityIndicatorVisible:TRUE];
        }
        [self startTimer];
        return TRUE;
    }
    return FALSE;

}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)response {
    [self stopTimerIfNeeded];
    
    [_buffer setLength:0];
    int code = [response statusCode];
    if (code == 404) {
        NSString *emptyXml = @"";
        [_buffer appendData:[emptyXml dataUsingEncoding:NSUTF8StringEncoding]];
        [self processData:_buffer];
    } else if (code != 200) {
        [self processError:mb_err(code)];
    }
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_buffer appendData:data];
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {    
    [self processError:error];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {   
    [self processData:_buffer];
}



- (void)processError:(NSError *)error {
    @try {
        NSLog(@"Request failed! Error:(%d) %@", error.code, [error localizedDescription]);
        [self reset];
        
        if (!_delegate)
            return;
        
        if (self.canShowAlert) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"AlertTitleNotConnect"
                                                            message:@"AlertMsgNotConnect"
                                                           delegate:nil 
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        
        SEL sel = @selector(mService:didFailWithError:);
        if (_delegate && [_delegate respondsToSelector:sel]) {
            [_delegate performSelector:sel withObject:self withObject:mb_err([error code])];
        }
    } @catch (NSException *ex) {
        NSLog(@"processError:%@", [ex reason]);
    }
}


- (void)processData:(NSData *)data {
    if (self.delegate == nil) {
        [self reset];
        return;
    }
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    int act = self.action;
    NSData *buff = [data retain];
 
    @try {
        [self reset];
        switch (act) {
            case ActionTypeGetAllVideo :
            {
                ListVideoData *response = [Util postVideo:buff];
                if ([response.status isEqualToString:@"success"]) {
                    SEL sel = @selector(mServiceGetVideoSuccess:responses:);
                    if ([_delegate respondsToSelector:sel]) {
                        [_delegate performSelector:sel withObject:self withObject:response];
                    }
                }
                else {
                    SEL sel = @selector(mServiceGetVideoFailed:responses:);
                    if ([_delegate respondsToSelector:sel]) {
                        [_delegate performSelector:sel withObject:self withObject:response];
                    }					
                }
                
                break;
            }
            case ActionTypeGetVideo :
                
                break;
        }
    } @catch (NSException *ex) {
        NSLog(@"Exception:%@", [ex reason]);
    } @finally {
        if (buff) {
            [buff release];
            buff = nil;
        }
    }
    [pool release];
}


- (NSString *)joinParameters:(NSDictionary *)params {
    NSString *paramsString = @"";
    if (params) {
        NSArray *keys = [params allKeys];
		int c = [keys count];
		int i = 0;
		while (i < c) {
			NSString *k = [keys objectAtIndex:i];
            NSString *v = [params valueForKey:k];
            if (k && v) {
                v = [Util URLEncode:v];
                paramsString = [paramsString stringByAppendingFormat:@"%@=%@", k, v];
            }
			i++;
			if (i >= c)
				break;
			paramsString = [paramsString stringByAppendingString:@"&"];
		}
    }
    return paramsString;
}


+ (void)showErrorNetwork {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"AlertTitleErrorNetwork"
														message:@"AlertMsgErrorNetwork"
													   delegate:nil 
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}


- (void)dealloc {
    [self stop];
    [super dealloc];
}

@end
