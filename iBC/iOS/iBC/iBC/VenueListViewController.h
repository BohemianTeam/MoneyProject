//
//  VenueListViewController.h
//  iBC
//
//  Created by bohemian on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageDownloader.h"

@interface VenueListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, ImageDownloaderDelegate, UIScrollViewDelegate>
{
    UITableView         *venueTable;

    NSMutableArray      *venuesList;
    

    NSMutableDictionary *imageDownloadsInProgress;  // the set of imgDownloader objects for each app
    
    BOOL                haveData;
}
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;
- (id) initWithTitle:(NSString *) title;
- (void)getDataFromServer;
- (void)startIconDownload:(id)otherObj forIndexPath:(NSIndexPath*)indexPath;@end