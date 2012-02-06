//
//  ViewController.h
//  VideoApplication
//
//  Created by Cuong Tran on 1/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LoadingMaskView;
@class Service;
@class ListVideoData;
@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>{
    UITableView             *_tableView;
    LoadingMaskView         *_loadingView;
    Service                 *_service;
    ListVideoData           *_data;
}
@property (nonatomic, retain) UITableView *tableView;
@end
