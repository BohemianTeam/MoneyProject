//
//  iBackMasterViewController.h
//  iBack
//
//  Created by bohemian on 1/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RevertMedia.h"
#import "AlertManager.h"
@class iBackDetailViewController;


@interface iBackMasterViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    IBOutlet UITableView        *menuTable;  
    IBOutlet UIView             *overlayView;
}
@property (nonatomic, retain) UITableView     *menuTable;
@property (nonatomic, retain) UIView             *overlayView;
@property (strong, nonatomic) iBackDetailViewController *detailViewController;

@end
