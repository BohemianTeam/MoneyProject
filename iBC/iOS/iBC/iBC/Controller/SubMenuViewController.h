//
//  SubMenuViewController.h
//  iBC
//
//  Created by Cuong Tran on 2/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubMenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>{
    UITableView                 *_tableView;
    NSMutableArray              *_arrMenuItems;
}
- (id) initWithTitle:(NSString *) title;
@end
