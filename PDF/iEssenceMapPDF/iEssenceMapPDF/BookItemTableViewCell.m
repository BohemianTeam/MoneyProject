//
//  BookItemTableViewCell.m
//  iEssenceMapPDF
//
//  Created by Cuong Tran on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BookItemTableViewCell.h"

@interface BookItemTableViewCell(private)
-(void)downloadPDF:(id)sender withUrl:(NSString *)sourceURL andName:(NSString *)namePdf;
-(BOOL)checkIfPDfLink:(NSString *)url;
@end
@implementation BookItemTableViewCell

@synthesize request = _request;
@synthesize delegate = _delegate;
@synthesize datasource = _datasource;
@synthesize pdfToDownload = _pdfToDownload;
@synthesize progressDownload = _progressDownload;
@synthesize removeButton = _removeButton;
@synthesize openButton = _openButton;
@synthesize localPath = _localPath;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier path:(NSString *)path name:(NSString *)name {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.pdfToDownload = path;
        _name = [name retain];
        UIButton * aButton = nil;
        
        UILabel * aLabel = nil;
        NSString * aLabelTitle = nil;
        
        UIProgressView * aProgressView = nil;
        
        NSArray * paths = nil;
        NSString * documentsDirectory = nil;
        
        NSFileManager * fileManager = nil;

        
        BOOL fileAlreadyExists = NO;
        // Paths to the cover and the document.
        
        paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        documentsDirectory = [paths objectAtIndex:0];	
        _localPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.pdf",_name]];
        NSLog(@"%@",_localPath);
        fileManager = [[NSFileManager alloc]init];
        
        //create the temp directory used for the resume of pdf.
        if ([fileManager fileExistsAtPath:_localPath]) {
            fileAlreadyExists = YES;
        }else {
            fileAlreadyExists = NO;
        }
        
        // Open button.
        
        aButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [aButton setFrame:CGRectMake(310, 7, 80, 30)];
        [aButton setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleRightMargin];
        [aButton setTitle:@"Download" forState:UIControlStateNormal];
        // Open or download action, depend if the file is already present or not.
        
        if (!fileAlreadyExists) {
            [aButton addTarget:self action:@selector(actionDownloadPdf:) forControlEvents:UIControlEventTouchUpInside];
        } else {
            [aButton addTarget:self action:@selector(actionOpenPdf:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [self addSubview:aButton];
        self.openButton = aButton;
        
        // Remove button.
        
        aButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [aButton setFrame:CGRectMake(400, 7, 80, 30)];
        [aButton setTitle:@"Remove" forState:UIControlStateNormal];
        [aButton setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleRightMargin];
        [aButton addTarget:self action:@selector(actionremovePdf:) forControlEvents:UIControlEventTouchUpInside];
        [[aButton titleLabel]setFont:[UIFont fontWithName:@"Arial Rounded MT Bold" size:(15.0)]];
        
        // If pdf already exist show the button.
        
        [aButton setHidden:(!fileAlreadyExists)];
        [self addSubview:aButton];
        self.removeButton = aButton;
        
        // Title label.
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            
            aLabel = [[UILabel alloc ] initWithFrame:CGRectMake(0, 7, 300, 30) ];
            aLabel.textAlignment =  UITextAlignmentCenter;
            aLabel.textColor = [UIColor blackColor];
            aLabel.backgroundColor = [UIColor clearColor];
            aLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:(25.0)];
            
        }else {
            
            aLabel = [[UILabel alloc ] initWithFrame:CGRectMake(20, 7, 105, 20) ];
            aLabel.textAlignment =  UITextAlignmentCenter;
            aLabel.textColor = [UIColor blackColor];
            aLabel.backgroundColor = [UIColor clearColor];
            aLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:(15.0)];
        }
        
        aLabelTitle = [NSString stringWithFormat:@"%@",_name];
        [aLabel setText:aLabelTitle]; 
        [self addSubview:aLabel];
        [aLabel release];
        [fileManager release];
        
        // Calculate sizes and offsets.
        
        CGFloat progressBarVOffset;
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) { // iPad.
            
            progressBarVOffset = 100; //set y position of the progress bar
            
        } else {		// iPhone.
            
            //iphone
            progressBarVOffset = 215;
        }

        // Progress bar for the download operation.
        
        aProgressView = [[UIProgressView alloc] initWithFrame:CGRectMake(490, 22, 120, 30)];
        aProgressView.progressViewStyle = UIProgressViewStyleDefault; // FIXME: it was UIActivityIndicatorViewStyleGray. 
        aProgressView.progress= 0.0;
        aProgressView.hidden = TRUE;
        [self addSubview:aProgressView];
        self.progressDownload = aProgressView;
        [aProgressView release];
    }
    return self;
}

-(void)actionremovePdf:(id)sender{
	
	// Basically, we get the UI elements and change their behaviour.
	
	NSFileManager *filemanager = nil;
	
	// Remove the file form disk (ignore the error).
	
	filemanager = [[NSFileManager alloc] init];
	[filemanager removeItemAtPath:_localPath error:NULL];
	[filemanager release];
	
	// Hide the remove button.
	
	_removeButton.hidden = YES;
    
	[_openButton removeTarget:self action:@selector(actionOpenPdf:) forControlEvents:UIControlEventTouchUpInside];
	[_openButton addTarget:self action:@selector(actionDownloadPdf:) forControlEvents:UIControlEventTouchUpInside];
	
}

-(void)actionOpenPdf:(id)sender {
    NSLog(@"local path === %@",_localPath);
    [self.delegate openPDFWithPath:_localPath];
}

-(void)actionDownloadPdf:(id)sender {
	
	if(_pdfInDownload)
		return;
	
	//senderButton = sender;
	//self.pdfToDownload=[NSString stringWithFormat:@"%@", page];
	[self downloadPDF:self withUrl:_pdfToDownload andName:_name];
}

-(void)downloadPDF:(id)sender withUrl:(NSString *)sourceURL andName:(NSString *)namePdf {
    NSURL *url = [NSURL URLWithString:sourceURL];
    ASIHTTPRequest * request = nil;
    
    NSString * documentsDirectory = nil;
    NSString * pdfPath = nil;
    
    UIProgressView * progressView = nil;
    progressView = _progressDownload;
    self.progressDownload.hidden = NO;
        
    //check if the download url is a link to a pdf file or pfk file.
    _isPdfLink = [self checkIfPDfLink:sourceURL];
    
    if (_isPdfLink) {
        pdfPath = _localPath;//[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.pdf",namePdf]];
    }
    
    request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    
    [request setUseKeychainPersistence:YES];
    [request setDownloadDestinationPath:pdfPath];
    [request setDidFinishSelector:@selector(requestFinished:)];
    [request setDidFailSelector:@selector(requestFailed:)];
    
    // Get the progressview from the mainviewcontroller and set it as the progress delegate.
    [request setDownloadProgressDelegate:progressView];
    
    [request setShouldPresentAuthenticationDialog:YES];
    [request setAllowResumeForFileDownloads:YES]; //set YEs if resume is supported 
//    [request setTemporaryFileDownloadPath:pdfPathTempForResume]; // if resume is supported set the temporary Path
    
    self.request = request;
    
    [request startAsynchronous];
    
}

-(void)requestStarted:(ASIHTTPRequest *)request{
	_pdfInDownload = YES;
    
}

-(void)requestFinished:(ASIHTTPRequest *)request {
    _pdfToDownload = NO;
    [_openButton removeTarget:self action:@selector(actionStopPdf:) forControlEvents:UIControlEventTouchUpInside];
	[_openButton addTarget:self action:@selector(actionOpenPdf:) forControlEvents:UIControlEventTouchUpInside];
    [_openButton setTitle:@"Open" forState:UIControlStateNormal];
    _removeButton.hidden = NO;
}

-(void)requestFailed:(ASIHTTPRequest *)request {
    
}

-(BOOL)checkIfPDfLink:(NSString *)url{
	
	//url example in xml
	
	NSArray *listItems = [url componentsSeparatedByString:@"."];
	NSString *doctype = [listItems objectAtIndex:listItems.count-1];
	
	if ([doctype isEqualToString:@"pdf"]) {
		// NSLog(@"Is Pdf");
		return YES;
	}else{
		// NSLog(@"Is fpk");
		return NO;
	}
}

- (void)connection:(NSURLConnection *)connection didWriteData:(long long)bytesWritten totalBytesWritten:(long long)totalBytesWritten expectedTotalBytes:(long long)expectedTotalBytes{
    
    self.progressDownload.hidden = NO;
    
    float progress = (float)totalBytesWritten/(float)expectedTotalBytes;
    
    [self.progressDownload setProgress:progress animated:YES];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"down_Doc_Error" object:nil];

    UIProgressView * aProgressView = nil;
    
	_pdfInDownload = NO;
	
	aProgressView = _progressDownload;
	aProgressView.hidden = !_downloadPdfStopped;

    
	if (_downloadPdfStopped) {
		_downloadPdfStopped = NO;
	}
    
    
}

- (void)connectionDidFinishDownloading:(NSURLConnection *)connection destinationURL:(NSURL *)destinationURL {
    
    self.progressDownload.hidden =YES;
	
	_pdfInDownload = NO;
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
