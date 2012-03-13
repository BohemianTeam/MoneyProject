//
//  VenueDetailViewController.h
//  iBC
//
//  Created by bohemian on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageDownloader.h"
@class VenuesObj;
@class ImgDownloaderView;

@interface VenueDetailViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, ImageDownloaderDelegate>
{
    UIButton                *btnStarred;
    UITableView             *venueDetailTable;
    NSMutableArray          *venueRoomList;

    VenuesObj               *venueObj;
    NSString                *venueCode;
    Service                 *service;
    NSMutableDictionary     *imageDownloadsInProgress;  // the set of imgDownloader objects for each app
    BOOL                    haveData;
    BOOL                    isStarred;
    BOOL                    isGoDetailPage;
}
@property(nonatomic, retain)NSString                *venueCode;
@property (nonatomic, retain)NSMutableDictionary    *imageDownloadsInProgress;
- (void)getDataFromServer;
- (void)startDownload:(NSString*)imgUrl imgView:(ImgDownloaderView*)imgView forIndexPath:(NSIndexPath*)indexPath;
- (void)btnStarredPressed;
- (void)setStarredStatus:(NSString*)status;
@end

