//
//  WebViewViewController.m
//  iEssenceMapPDF
//
//  Created by Cuong Tran on 3/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WebViewViewController.h"

@implementation WebViewViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) initWithURL:(NSString *)url {
    self = [super init];
    if (self) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
        _webView.delegate = self;
        
        NSURL *targetURL = [NSURL URLWithString:[url retain]];
        NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
        [_webView loadRequest:request];
        
        [self.view addSubview:_webView];
    }
    
    return self;
}

#pragma mark - UIWebViewDelegate
- (void) webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"webViewDidStartLoad");
}

- (void) webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"webViewDidFinishLoad");
}

- (void) dealloc {
    [_webView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
