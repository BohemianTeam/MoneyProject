//
//  DownloadService.m
//  VideoApplication
//
//  Created by Cuong Tran on 1/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DownloadService.h"
#import "Util.h"
#import "VideoData.h"
#import "LoadingMaskView.h"
#import "ASIHTTPRequest.h"
#import "MBProgressHUD.h"
@interface DownloadService()

- (void) continueDownload;
- (void) download;
- (void) processError:(NSError *) error;
- (void) stopTimerIfNeed;
- (void) setPathWithCurrentType:(DownloadType) type;
- (void) checkFileExist;
- (void) showLoading;
- (void) hideLoading;
- (void) showHUD;
- (void) hideHUD;
- (void) mixesTask;
@end

@implementation DownloadService
@synthesize path = _path;
@synthesize localPath = _localPath;
@synthesize connecting = _connecting;
@synthesize delegate;
@synthesize timer = _timer;
@synthesize timeout = _timeout;

- (id) initWithVideoData:(VideoData *)data andType:(DownloadType)type {
    self = [super init];
    if (self) {
        _videoData = [data retain];
        _currentType = type;
        [self setPathWithCurrentType:_currentType];
        self.timeout = 60;
        _totalBytes = 0;
        _receiveBytes = 0;
        _connecting = NO;
    }
    return self;
}

- (id) initWithVideoData:(VideoData *)data andSuperView:(UIView *)superView{
    _superView = [superView retain];
    return [self initWithVideoData:data andType:DownloadTypeVideo];
}

- (void) setPathWithCurrentType:(DownloadType)type {
    NSString *hashStr = _videoData.title;//[Util calcMD5:_videoData.title];
    if (type == DownloadTypeVideo) {
        self.path = _videoData.url;

        NSURL *url = [NSURL URLWithString:self.path];
        NSString *extension = [url pathExtension];
        NSString *videoDir = [Util getVideoDir];
        
        _localPath = [videoDir stringByAppendingString:[NSString stringWithFormat:@"/%@", [hashStr stringByAppendingPathExtension:extension]]];
        _videoData.localPathVideo = [NSString stringWithFormat:@"%@", [hashStr stringByAppendingPathExtension:extension]];
    } else if (type == DownloadTypeSub) {
        self.path = _videoData.subUrl;
        
        NSURL *url = [NSURL URLWithString:self.path];
        NSString *extension = [url pathExtension];
        NSString *subDir = [Util getSubDir];
        
        _localPath = [subDir stringByAppendingString:[NSString stringWithFormat:@"/%@", [hashStr stringByAppendingPathExtension:extension]]];
    } else if (type == DownloadTypeTimeLine) {
        self.path = _videoData.timelineUrl;
        
        NSURL *url = [NSURL URLWithString:self.path];
        NSString *extension = [url pathExtension];
        NSString *timelineDir = [Util getTimeLineDir];
        
        _localPath = [timelineDir stringByAppendingString:[NSString stringWithFormat:@"/%@", [hashStr stringByAppendingPathExtension:extension]]];
    }
}

#pragma download with asihttprequest processing

- (void) showHUD {
    if (_loadingHUD == nil) {
        _loadingHUD = [[MBProgressHUD alloc] initWithView:_superView];
        [_superView addSubview:_loadingHUD];
        _loadingHUD.dimBackground = YES;
        _loadingHUD.labelText = @"Downloading ..";
        [_loadingHUD show:YES];
    }
}


- (void) hideHUD {
    if (_loadingHUD) {
        [_loadingHUD hide:YES afterDelay:2];
        [_loadingHUD removeFromSuperview];
        [_loadingHUD release];
        _loadingHUD = nil;
    }
}

- (void) mixesTask {
}

- (void) downloadWithASIRequest {
    _connecting = YES;
    _asiRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:self.path]];
    _asiRequest.timeOutSeconds = self.timeout;
    [_asiRequest setDownloadDestinationPath:self.localPath];
    [_asiRequest setDelegate:self];
    [_asiRequest setNumberOfTimesToRetryOnTimeout:2];
    [_asiRequest setAllowResumeForFileDownloads:YES];
    [_asiRequest setDownloadProgressDelegate:self];
    [_asiRequest setDidFailSelector:@selector(asiDidFailWithError:)];
    [_asiRequest setDidFinishSelector:@selector(asiDidFinished:)];
    
    [_asiRequest startAsynchronous];
    [self showHUD];
}

- (void) asiDidFailWithError:(ASIHTTPRequest *) request {
//    [self processError:[request error]];
    _loadingHUD.labelText = @"Error";
    [self hideHUD];
    [self.delegate downloadServiceFailed:self];
}

- (void) asiDidFinished:(ASIHTTPRequest *) request {
    _receiveBytes = 0;
    NSLog(@"finish one");
    [self continueDownload];
    if (_currentType == DownloadTypeNone) {
        _loadingHUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]] autorelease];
        _loadingHUD.mode = MBProgressHUDModeCustomView;
        _loadingHUD.labelText = @"Completed";
        [self hideHUD];
        [self.delegate downloadService:self didSuccessWithVideoData:_videoData];
        [_asiRequest release];
        _asiRequest = nil;
    }
    
}

-(void) request:(ASIHTTPRequest *)request incrementDownloadSizeBy: (long long)newLength {
    _totalBytes = newLength;
    _loadingHUD.mode = MBProgressHUDModeDeterminate;
    NSLog(@"%lld", newLength);
}

-(void) request:(ASIHTTPRequest *)request didReceiveBytes:(long long)bytes {
    _receiveBytes = _receiveBytes + bytes;
    _loadingHUD.mode = MBProgressHUDModeDeterminate;
    int rouded = 100 * _loadingHUD.progress;
    _loadingHUD.labelText = [NSString stringWithFormat:@"%i%%", rouded];
    _loadingHUD.progress = _receiveBytes / (float) _totalBytes;
}

- (void) continueDownload {
    NSLog(@"continueDownload: %d", _currentType);
    if (_currentType != DownloadTypeNone && _currentType != DownloadTypeTimeLine) {
        _currentType += 1;
        [self setPathWithCurrentType:_currentType];
        [self downloadWithASIRequest];
        
    } else {
        _currentType = DownloadTypeNone;
    }
    
}


- (void) showLoading {
    if(_alert == nil) {
        _alert = [[LoadingMaskView alloc] initWithCancelButton:@"" alert:YES titleButton:@"Cancel"];
    }
    _alert.delegate = self;
    if (!_alert.visibled) {
        [_alert show];
    }
}

- (void) hideLoading {
    [_alert hide];
}

- (void) checkFileExist {
    BOOL isExits = [Util checkFileExits:_localPath];
    if (isExits) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:LocStr(@"MsgExistFile") delegate:nil cancelButtonTitle:LocStr(@"Cancel") otherButtonTitles:LocStr(@"OK"), nil];
        alertView.delegate = self;
        [alertView show];
        [alertView release];
    } else {
        [self download];
    }
}

- (void) checkFileExistAndDownload {
    [self checkFileExist];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        
    } else if (buttonIndex == 1) {
        [self download];
    }
}


- (void) stopTimerIfNeed {
    if (_timer) {
        [_timer invalidate];
        [_timer release];
        _timer = nil;
    }
}

- (void) startTimer {
    _timer = [[NSTimer timerWithTimeInterval:self.timeout target:self selector:@selector(didTimeOut) userInfo:nil repeats:NO] retain];
    
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}

- (void) didTimeOut {
    if (self.connecting) {
        [self processError:nil];
    }
}
#pragma download processing

- (void) download {
    if (self.connecting) {
        return;
    }
    [self stopTimerIfNeed];
    NSURL *url = [NSURL URLWithString:self.path];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NO timeoutInterval:self.timeout];
    NSLog(@"URL:%@", self.path);
    _buffer = [[NSMutableData alloc] init];
    _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (_connection) {
        [self startTimer];
        self.connecting = TRUE;
        [[UIApplication sharedApplication] showNetworkActivityIndicatorVisible:TRUE];
    }
}


- (void) processError:(NSError *)error {
    [delegate downloadServiceFailed:self];
    [self stop];
    NSLog(@"URL not found : %@" ,self.path);
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response {
    return request;
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)response { 
    [self stopTimerIfNeed];
    [_buffer setLength:0];
    int code = [response statusCode];
    if (code != 200) {
        NSLog(@"status code : %@", code);
        [self processError:nil];
    }
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Request failed! Eror : (%d) %@", error.code, [error localizedDescription]);
    [self processError:error];
    
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_buffer appendData:data];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (_buffer) {
        [Util deleteDir:_localPath];
        [Util createDirectoryAtPath:_localPath];
        NSURL *url = [NSURL URLWithString:_localPath];
        [_buffer writeToURL:url atomically:YES];
//        [delegate downloadService:self didReceiveStatus:@"success" filePath:_localPath];
    }
    [self stop];
}


- (void)stop {
    [self stopTimerIfNeed];
    if (self.connecting) {
        [[UIApplication sharedApplication] showNetworkActivityIndicatorVisible:FALSE];
    }

    self.connecting = FALSE;
    if (_buffer) {
        [_buffer release];
        _buffer = nil;
    }
    _currentType = DownloadTypeNone;
    [_asiRequest cancel];
}

- (void) dealloc {
    [self stop];
    self.path = nil;
    self.localPath = nil;
    [super dealloc];
}


@end
