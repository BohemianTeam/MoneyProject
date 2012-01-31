//
//  iBackMasterViewController.h
//  iBack
//
//  Created by bohemian on 1/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class iBackDetailViewController;

@interface iBackMasterViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    IBOutlet UITableView        *menuTable;
    UIImagePickerController     *cameraView;
}
@property (nonatomic, retain) UITableView     *menuTable;
@property (strong, nonatomic) iBackDetailViewController *detailViewController;
@property (nonatomic, retain) UIImagePickerController     *cameraView;
@end
