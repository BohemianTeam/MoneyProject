//
//  VenueListViewController.h
//  iBC
//
//  Created by bohemian on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "ImageDownloader.h"

@interface VenueListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, ImageDownloaderDelegate, UIScrollViewDelegate,CLLocationManagerDelegate>
{
    UITableView         *venueTable;

    NSMutableArray      *venuesList;
    CLLocationManager   *locationManager;
    Service             *service;
    NSMutableDictionary *imageDownloadsInProgress;  // the set of imgDownloader objects for each app
    
    BOOL                haveData;
    BOOL                isGoDetailPage;
}
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;
- (id) initWithTitle:(NSString *) title;
- (void)getLocation;
- (void)getDataFromServer:(NSString*)loca;
- (void)updateStarredList;
- (void)startIconDownload:(id)otherObj forIndexPath:(NSIndexPath*)indexPath;
- (void)btnBackPressed;
@end
