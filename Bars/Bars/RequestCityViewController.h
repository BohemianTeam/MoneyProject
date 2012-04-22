//
//  RequestCityViewController.h
//  Bars
//
//  Created by Cuccku on 3/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface RequestCityViewController : UIViewController <UITextViewDelegate, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate>
{
    UITextView          *txvRequest;
    UITableView         *_tableView;
}

- (void)sendRequest;
- (void)cancelRequest;
@end
