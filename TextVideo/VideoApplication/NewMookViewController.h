//
//  NewMookViewController.h
//  VideoApplication
//
//  Created by Cuong Tran on 1/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownloadService.h"
@class Service;
@class ListVideoData;
@class MBProgressHUD;

@interface NewMookViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, DownloadServiceDelegate>{
    UITableView             *_tableView;
    Service                 *_service;
    ListVideoData           *_data;
    DownloadService         *_download;
    MBProgressHUD           *_loadingHUD;
}
@property (nonatomic, retain) UITableView *tableView;

@end
