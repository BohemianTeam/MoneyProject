//
//  BookItemViewController.h
//  iEssenceMapPDF
//
//  Created by Cuong Tran on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "BookItemTableViewCell.h"
@interface BookItemViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, BookItemTableViewCellDelegate>{
    UITableView             *_tableView;
    NSMutableArray          *_pdfs;
    NSMutableArray          *_links;
}

@end
