//
//  BarDetailViewController.h
//  Bars
//
//  Created by Cuong Tran on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Bar;
@class ImageGaleryView;
@interface BarDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    UITableView                 *_tableView;
    UILabel                     *_barDescription;
    UIButton                    *_map;
    UIButton                    *_camera;
    UIButton                    *_upload;
    
    ImageGaleryView             *_galeryView;
    Bar                         *_bar;
}
- (id) initWithBar:(Bar *) bar;
@end
