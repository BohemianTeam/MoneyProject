//
//  DownloadService.h
//  VideoApplication
//
//  Created by Cuong Tran on 1/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    DownloadTypeNone = 0,
    DownloadTypeVideo,
    DownloadTypeSub,
    DownloadTypeTimeLine
} DownloadType;
@class LoadingMaskView;
@class DownloadService;
@class VideoData;
@class ASIHTTPRequest;
@class MBProgressHUD;
@protocol DownloadServiceDelegate
@optional
- (void) downloadService:(DownloadService *) service didReceiveStatus:(NSString *) status filePath:(NSString *) path;
- (void) downloadServiceFailed:(DownloadService *)service;
@end
@interface DownloadService : NSObject {
    id <DownloadServiceDelegate>    *_delegate;
    NSString                        *_path;
    NSString                        *_localPath;
    
    BOOL                            _canceled;
    BOOL                            _connecting;
    NSURLConnection                 *_connection;
    ASIHTTPRequest                  *_asiRequest;
    NSMutableData                   *_buffer;
    int                             _timeout;
    NSTimer                         *_timer;
    
    VideoData                       *_videoData;
    DownloadType                    _currentType;
    LoadingMaskView                 *_alert;
    MBProgressHUD                   *_loadingHUD;
    UIView                          *_superView;
}
@property (nonatomic, assign) id <DownloadServiceDelegate> delegate;
@property (nonatomic, retain) NSString *localPath;
@property (nonatomic, retain) NSString *path;
@property (nonatomic, assign) BOOL  connecting;
@property (nonatomic, assign) int timeout;
@property (nonatomic, retain) NSTimer *timer;

- (id) initWithVideoData:(VideoData *) data andType:(DownloadType) type;
- (id) initWithVideoData:(VideoData *)data andSuperView:(UIView *) superView;
- (void) stop;
- (void) checkFileExistAndDownload;
- (void) downloadWithASIRequest;
@end
