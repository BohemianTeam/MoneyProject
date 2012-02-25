//
//  ImageDownloader.h
//

//  Copyright (C) 2010 Apple Inc. All Rights Reserved.
//

#import <Foundation/Foundation.h>

@protocol ImageDownloaderDelegate;
@protocol SetImageDelegate;
@interface ImageDownloader : NSObject
{
    id<ImageDownloaderDelegate>         delegate;
    id<SetImageDelegate>                setImgDelegate;         //using for Object
    
    NSMutableData                       *activeDownload;
    NSURLConnection                     *imageConnection;
    NSIndexPath                         *indexPath;
}
@property (nonatomic, assign) id<ImageDownloaderDelegate> delegate;
@property (nonatomic, assign) id<SetImageDelegate> setImgDelegate;
@property (nonatomic, retain) NSIndexPath *indexPath;
@property (nonatomic, retain) NSMutableData *activeDownload;
@property (nonatomic, retain) NSURLConnection *imageConnection;

- (void)startDownloadWithUrl:(NSString*)url;
- (void)cancelDownload;

@end

@protocol SetImageDelegate
- (void)setImage:(UIImage*)img;
@end

@protocol ImageDownloaderDelegate
- (void)appImageDidLoad:(NSIndexPath*)indexPath;
@end