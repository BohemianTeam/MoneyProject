//
//  ImageDownloader.m
//  youplusdallas
//
//  Created by bohemian on 1/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ImageDownloader.h"
#import "ResponseObj.h"

#define IMAGE_WIDTH 300
#define IMAGE_HEIGHT 160

@implementation ImageDownloader
@synthesize indexPath;
@synthesize setImgDelegate, delegate;
@synthesize activeDownload;
@synthesize imageConnection;

#pragma mark

- (void)dealloc
{
    [activeDownload release];
    [indexPath release];
    [imageConnection cancel];
    [imageConnection release];
    
    [super dealloc];
}

- (void)startDownloadWithUrl:(NSString*)url
{
    self.activeDownload = [NSMutableData data];
    // alloc+init and start an NSURLConnection; release on completion/failure
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:
                             [NSURLRequest requestWithURL:
                              [NSURL URLWithString:url]] delegate:self];
    self.imageConnection = conn;
    [conn release];
}

- (void)cancelDownload
{
    [self.imageConnection cancel];
    self.imageConnection = nil;
    self.activeDownload = nil;
}


#pragma mark -
#pragma mark Download support (NSURLConnectionDelegate)
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.activeDownload appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	// Clear the activeDownload property to allow later attempts
    self.activeDownload = nil;
    
    // Release the connection now that it's finished
    self.imageConnection = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"download finish");
    // Set appIcon and clear temporary data/image
    UIImage *image = [[UIImage alloc] initWithData:self.activeDownload];
    
    //using to resize image if need
//    NSLog(@"connectionDidFinishLoading %f---%f", image.size.width, image.size.height);
//    if (image.size.width != IMAGE_WIDTH && image.size.height != IMAGE_HEIGHT)
//	{
//        CGSize itemSize = CGSizeMake(IMAGE_WIDTH, IMAGE_HEIGHT);
//		UIGraphicsBeginImageContext(itemSize);
//		CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
//		[image drawInRect:imageRect];
//        
//        [self.setImgDelegate setImage:UIGraphicsGetImageFromCurrentImageContext()];
//		UIGraphicsEndImageContext();
//    }
//    else
//    {
//        [self.setImgDelegate setImage:image];
//    }
    [self.setImgDelegate setImage:image];
    self.activeDownload = nil;
    [image release];
    
    // Release the connection now that it's finished
    self.imageConnection = nil;
    
    // call our delegate and tell it that our icon is ready for display
    [delegate appImageDidLoad:self.indexPath];
}
@end
