//
//  StarredListViewController.h
//  iBC
//
//  Created by bohemian on 2/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageDownloader.h"

@class MBProgressHUD;

@interface StarredListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, ImageDownloaderDelegate, UIScrollViewDelegate>
{
    UITableView         *starredTable;
    
    NSMutableArray      *eventsList;
    NSMutableArray      *venuesList;
    Service             *service;
    MBProgressHUD       *loadingView;
    NSMutableDictionary *imageDownloadsInProgress;  // the set of imgDownloader objects for each app
    
    BOOL                haveData;
    BOOL                isGoDetailPage;
}
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;
- (id) initWithTitle:(NSString *) title;
- (void)getDataFromServer;
- (void)startIconDownload:(id)otherObj forIndexPath:(NSIndexPath*)indexPath;
@end
