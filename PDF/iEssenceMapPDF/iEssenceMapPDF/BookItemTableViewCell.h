//
//  BookItemTableViewCell.h
//  iEssenceMapPDF
//
//  Created by Cuong Tran on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
@protocol BookItemTableViewCellDelegate
- (void) openPDFWithPath:(NSString *) path;
@end
@interface BookItemTableViewCell : UITableViewCell <NSURLConnectionDownloadDelegate>{
    id                  _datasource;
    id                  _delegate;
    ASIHTTPRequest      *_request;
    NSString            *_pdfToDownload;
	UIButton            *_removeButton;
	UIButton            *_openButton;
    BOOL                _pdfInDownload;
    BOOL                _isPdfLink;
    UIProgressView      *_progressDownload;
    BOOL                _downloadPdfStopped;
    NSString            *_localPath;
    NSString            *_name;
}
@property (nonatomic, retain) ASIHTTPRequest    *request;
@property (nonatomic, retain)   NSString          *pdfToDownload;
@property (nonatomic, retain) UIButton          *removeButton;
@property (nonatomic, retain) UIButton          *openButton;
@property (nonatomic, retain) UIProgressView    *progressDownload;
@property (nonatomic, assign) id                delegate;
@property (nonatomic, assign) id                datasource;
@property (nonatomic, retain)   NSString          *localPath;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier path:(NSString *) path name:(NSString *)name;
@end
