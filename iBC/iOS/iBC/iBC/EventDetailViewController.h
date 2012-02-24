//
//  EventDetailViewController.h
//  iBC
//
//  Created by bohemian on 2/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import "ImageDownloader.h"
@class EventsObj;
@class ImgDownloaderView;
@interface EventDetailViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, ImageDownloaderDelegate>
{
    UITableView             *eventDetailTable;
    NSMutableArray          *infoBlockList;
    
    EventsObj               *eventObj;
    NSString                *eventCode;
    
    BOOL                    haveData;
    NSMutableDictionary     *imageDownloadsInProgress;  // the set of imgDownloader objects for each app
}
@property(nonatomic, retain)NSString                *eventCode;
@property (nonatomic, retain)NSMutableDictionary    *imageDownloadsInProgress;
- (void)getDataFromServer;
- (void)startDownload:(NSString*)imgUrl imgView:(ImgDownloaderView*)imgView forIndexPath:(NSIndexPath*)indexPath;
@end
