//
//  PDFWebViewViewController.h
//  iEssenceMapPDF
//
//  Created by Cuong Tran on 3/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDFWebViewViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>{
    UITableView                 *_tableView;
    NSMutableArray              *_pdfs;
    NSMutableArray              *_links;
}

@end
