//
//  LoadingDialogView.m
//  VideoApplication
//
//  Created by Cuong Tran on 1/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoadingDialogView.h"

@implementation LoadingDialogView

- (id) init {
    self = [super init];
    if (self) {
        _alertView = [[[UIAlertView alloc] initWithTitle:@"\n\nLoading Video\nPlease Wait..." 
                                            message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil] autorelease];
        [_alertView show];
        _loadingIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _loadingIndicatorView.center = CGPointMake(_alertView.bounds.size.width / 2, _alertView.bounds.size.height - 50);
        NSLog(@"%f",_alertView.bounds.size.width / 2);
        [_loadingIndicatorView startAnimating];
        [_alertView addSubview:_loadingIndicatorView];
    }
    return self;
}

- (void) show {
    if (_alertView.isHidden) {
        [_alertView show];
    }
}

- (void) hide {
    [_alertView dismissWithClickedButtonIndex:0 animated:YES];
}

- (void) dealloc {
    [_loadingIndicatorView release];
    if (_alertView) {
        [_alertView release];
    }
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
