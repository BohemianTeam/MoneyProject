//
//  WebViewViewController.h
//  iEssenceMapPDF
//
//  Created by Cuong Tran on 3/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewViewController : UIViewController <UIWebViewDelegate>{
    UIWebView           *_webView;
}

- (id) initWithURL:(NSString *) url;

@end
