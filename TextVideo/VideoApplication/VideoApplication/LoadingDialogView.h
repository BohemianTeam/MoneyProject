//
//  LoadingDialogView.h
//  VideoApplication
//
//  Created by Cuong Tran on 1/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingDialogView : UIView {
    UIAlertView                 *_alertView;
    UIActivityIndicatorView     *_loadingIndicatorView;
    
}

- (void) show;
- (void) hide;

@end
