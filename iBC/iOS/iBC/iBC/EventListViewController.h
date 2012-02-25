//
//  EventListViewController.h
//  iBC
//
//  Created by bohemian on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageDownloader.h"

typedef enum EventFilter
{
    EventFilterNone,
    EventFilterByDate,
}EventFilter;
@interface EventListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, ImageDownloaderDelegate, UIScrollViewDelegate>
{
    UITableView         *eventTable;
    
    NSMutableArray      *eventsList;
    
    
    NSMutableDictionary *imageDownloadsInProgress;  // the set of imgDownloader objects for each app
    
    BOOL                haveData;
    EventFilter         filterType;
    NSString            *dateFilter;
}
@property(nonatomic, retain) NSMutableDictionary    *imageDownloadsInProgress;
@property(nonatomic, retain) NSString               *dateFilter;
@property(nonatomic, assign) EventFilter            filterType;
- (id) initWithTitle:(NSString *) title;
- (void)getDataFromServer;
- (void)startIconDownload:(id)otherObj forIndexPath:(NSIndexPath*)indexPath;
@end