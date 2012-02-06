//
//  MainViewController.h
//  VideoApplication
//
//  Created by Cuong Tran on 1/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownloadService.h"
@class Service;
@class ListVideoData;
@class LoadingView;

@interface MainViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, DownloadServiceDelegate>{
    UITableView             *_tableView;
    LoadingView         *_loadingView;
    Service                 *_service;
    ListVideoData           *_data;
    DownloadService         *_download;
}
@property (nonatomic, retain) UITableView *tableView;

@end
