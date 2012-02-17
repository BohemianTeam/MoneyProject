//
//  SaveFilesViewController.h
//  iBack
//
//  Created by bohemian on 1/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileViewCell.h"
#import "AlertManager.h"
#import "GData.h"
#import "MBProgressHUD.h"
#import "KeychainItemWrapper.h"
@interface SaveFilesViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, 
UINavigationControllerDelegate, FileViewCellDelegate, UITextFieldDelegate, FileSelectionAlertDelegate>
{
    IBOutlet UITableView    *filesTable;
    NSMutableArray          *movFiles;
    NSMutableDictionary     *needDeleteFiles;
    BOOL                    isEditTable;
    NSInteger               fileSelectedIndex;    
    
    GDataServiceTicket      *mUploadTicket;
    MBProgressHUD           *uploading;
    
    NSString                *userLogin;
    NSString                *passLogin;
    KeychainItemWrapper     *keychain;
}
@property (nonatomic, retain)NSString                *userLogin;
@property (nonatomic, retain)NSString                *passLogin;
@property (nonatomic, retain)NSMutableArray *movFiles;
@property (nonatomic, retain)NSDictionary   *needDeleteFiles;
@property (nonatomic, retain)UITableView    *filesTable;
@property (nonatomic, assign)BOOL           isEditTable;
@property (nonatomic, assign)NSInteger      fileSelectedIndex;
- (void)loadFilesIntoArray;
- (void)showLoading;
- (void)endLoading;
- (GDataServiceTicket *)uploadTicket;
- (void)setUploadTicket:(GDataServiceTicket *)ticket;
- (GDataServiceGoogleYouTube *)youTubeService: (NSString*)user pass:(NSString*)pass;
@end
