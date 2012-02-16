//
//  StarredListViewController.h
//  iBC
//
//  Created by bohemian on 2/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MBProgressHUD;

@interface StarredListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    UITableView         *starredTable;
    
    NSMutableArray      *eventsList;
    NSMutableArray      *venuesList;
    
    MBProgressHUD       *loadingView;
    NSMutableDictionary *imageDownloadsInProgress;  // the set of imgDownloader objects for each app
    
    BOOL                haveData;
}
- (id) initWithTitle:(NSString *) title;
- (void)getDataFromServer;
@end
