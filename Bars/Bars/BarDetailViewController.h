//
//  BarDetailViewController.h
//  Bars
//
//  Created by Cuong Tran on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreLocationController.h"
#import "ImageCaptureViewController.h"
#import "FacebookViewController.h"

@class Bar;
@class ImageGaleryView;

@interface BarDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIActionSheetDelegate, CoreLocationControllerDelegate, UIAlertViewDelegate, ImageCaptureViewControllerDelegate, FacebookViewControllerDelegate>{
    UITableView                 *_tableView;
    UILabel                     *_barDescription;
    
    UIButton                    *_map;
    UIButton                    *_camera;
    UIButton                    *_upload;
    
    UIImagePickerController     *_picker;
    
    ImageGaleryView             *_galeryView;
    Bar                         *_bar;
    
    CoreLocationController      *_locationController;
    CLLocation                  *_currentLocation;
    CLLocation                  *_barLocation;

    UIAlertView                 *_helpAlert;
    UIAlertView                 *_getLocationAlert;
    UIButton                    *btnCompleted;
}

- (id) initWithBar:(Bar *) bar;
@end
