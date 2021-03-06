//
//  FacebookViewController.h
//  Bars
//
//  Created by Trinh Hung on 4/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"
typedef enum FacebookRequest {
    FBRequestNone = 0,
    FBFeedMe,
    FBFeedInfo,
    FBUpload,
}FacebookRequest;

@protocol FacebookViewControllerDelegate

- (void) didUploadToFacebookSuccess;

@end

@class Bar;
@interface FacebookViewController : UIViewController <FBRequestDelegate, FBDialogDelegate, FBSessionDelegate, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, UITextFieldDelegate>{

    Facebook                *_facebook;
    NSArray                 *_permissions;
    
    NSMutableArray          *mainMenuItems;
    
    UITableView             *menuTableView;
    UIView                  *headerView;
    UILabel                 *nameLabel;
    UIImageView             *profilePhotoImageView;
    UITextField             *_photoTag;
    
    NSURL                   *_urlOpenInExternalBrowser;
    Bar                     *_bar;
    UIImage                 *_currentImage;
    
    FacebookRequest         _fbRequest;
    
    id                      _delegate;
}
@property (nonatomic, retain) NSArray *permissions;
@property (nonatomic, retain) id delegate;

- (void) setImage:(UIImage *) img withBar:(Bar *) bar;
@end
