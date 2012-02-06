//
//  LoadingMaskView.m
//  VideoApplication
//
//  Created by Cuong Tran on 1/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoadingMaskView.h"
#import "Util.h"
#define kMsgFont                    [UIFont systemFontOfSize:18]
#define kPadding                    20
#define kMaxWidth                   320 - kPadding - kPadding
#define kMaxHeight                  480 - kPadding - kPadding
#define kMsgMaxWidth                kMaxWidth - kPadding - kPadding

#define kAlertDelay                 3.0 //Seconds

@interface LoadingMaskView (Private)

- (CGRect)getFrameFromText:(NSString *)text;
- (BOOL)isValidDelegateForSelector:(SEL)selector;
- (void)showOrHide:(BOOL)visibled;

@end

@implementation LoadingMaskView
@synthesize delegate = _delegate;
@synthesize visibled = _visibled;


- (id)initWithMessage:(NSString *)msg alert:(BOOL)isAlert {
    self = [super initWithFrame:CGRectMake(0, 0, 320, 480)];
    if (self) {
        _isAlert = isAlert;
        _visibled = FALSE;
        self.backgroundColor = [UIColor clearColor];
        
        CGRect frame = [self getFrameFromText:msg];
        
        UIImageView *view = [[UIImageView alloc] initWithFrame:frame];
        view.image = [[UIImage imageNamed:@"PopupBg.png"] 
                      stretchableImageWithLeftCapWidth:15 topCapHeight:20.0];
        view.backgroundColor = [UIColor clearColor];
        [self addSubview:view];
        
        if (_isAlert) {
            _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadding, kPadding, 
                                                                    frame.size.width - kPadding - kPadding, 
                                                                    frame.size.height - kPadding - kPadding)];
        } else {
            CGRect indicatorRect = CGRectMake((frame.size.width - 30)*1.0 / 2, kPadding + 10, 30, 30);
            _indicator = [[UIActivityIndicatorView alloc] initWithFrame:indicatorRect];
            _indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
            _indicator.backgroundColor = [UIColor clearColor];
            [view addSubview:_indicator];
            
            CGFloat titleY = indicatorRect.origin.y + indicatorRect.size.height;
            
            _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadding,
                                                                    titleY + 10, 
                                                                    frame.size.width - kPadding - kPadding, 
                                                                    frame.size.height - titleY - kPadding - kPadding)];
        }
        
        _titleLabel.text = msg;
        _titleLabel.font = kMsgFont;
        _titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.backgroundColor = [UIColor clearColor];
        [view addSubview:_titleLabel];
        
        CGRect oldFrame = _titleLabel.frame;
        _titleLabel.numberOfLines = 0;
        [_titleLabel sizeToFit];
        _titleLabel.frame = oldFrame;
        _titleLabel.textAlignment = UITextAlignmentCenter;
        [view release];
    }
    return self;
}

- (id)initWithMessageOnView:(NSString *)msg alert:(BOOL)isAlert {
    BOOL purchased = NO;
    int offset = purchased ? 0 : 50;
    if (self = [super initWithFrame:CGRectMake(0, 0 - 44 - offset, 320, 480)]) {
        _isAlert = isAlert;
        _visibled = FALSE;
        self.backgroundColor = [UIColor clearColor];
        
        CGRect frame = [self getFrameFromText:msg];
        
        UIImageView *view = [[UIImageView alloc] initWithFrame:frame];
        view.image = [[UIImage imageNamed:@"PopupBg.png"] 
                      stretchableImageWithLeftCapWidth:15 topCapHeight:20.0];
        view.backgroundColor = [UIColor clearColor];
        [self addSubview:view];
        
        if (_isAlert) {
            _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadding, kPadding, 
                                                                    frame.size.width - kPadding - kPadding, 
                                                                    frame.size.height - kPadding - kPadding)];
        } else {
            CGRect indicatorRect = CGRectMake((frame.size.width - 30)*1.0 / 2, kPadding + 10, 30, 30);
            _indicator = [[UIActivityIndicatorView alloc] initWithFrame:indicatorRect];
            _indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
            _indicator.backgroundColor = [UIColor clearColor];
            [view addSubview:_indicator];
            
            CGFloat titleY = indicatorRect.origin.y + indicatorRect.size.height;
            
            _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadding,
                                                                    titleY + 10, 
                                                                    frame.size.width - kPadding - kPadding, 
                                                                    frame.size.height - titleY - kPadding - kPadding)];
        }
        
        _titleLabel.text = msg;
        _titleLabel.font = kMsgFont;
        _titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.backgroundColor = [UIColor clearColor];
        [view addSubview:_titleLabel];
        
        CGRect oldFrame = _titleLabel.frame;
        _titleLabel.numberOfLines = 0;
        [_titleLabel sizeToFit];
        _titleLabel.frame = oldFrame;
        _titleLabel.textAlignment = UITextAlignmentCenter;
        [view release];
    }
    return self;
}

- (id)initWithCancelButton:(NSString *)msg alert:(BOOL)isAlert titleButton:(NSString *)titleButton{
	if (self = [super initWithFrame:CGRectMake(0, 0, 320, 480)]) {
        _isAlert = isAlert;
        _visibled = FALSE;
        self.backgroundColor = [UIColor clearColor];
        
        CGRect frame = [self getFrameFromText:msg];
		CGRect frameImageView = CGRectMake(frame.origin.x, frame.origin.y - kPadding / 2, 
										   frame.size.width, frame.size.height + kPadding + 42);
        
        UIImageView *view = [[UIImageView alloc] initWithFrame:frameImageView];
        view.image = [[UIImage imageNamed:@"PopupBg.png"] 
                      stretchableImageWithLeftCapWidth:15 topCapHeight:20.0];
        view.backgroundColor = [UIColor clearColor];
        [self addSubview:view];
        
        if (_isAlert) {
            _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadding, kPadding, 
                                                                    frame.size.width - kPadding - kPadding, 
                                                                    frame.size.height - kPadding - kPadding)];
			UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
			btnCancel.frame = CGRectMake((self.frame.size.width  - 180)*1.0 / 2, 
										 view.frame.origin.y + _titleLabel.frame.origin.y +
										 _titleLabel.frame.size.height, 180, 42);
            
			[btnCancel setBackgroundImage:[[UIImage imageNamed:@"btnAlert.png"] stretchableImageWithLeftCapWidth:2.0 topCapHeight:2.0] forState:UIControlStateNormal];
			[btnCancel setTitle:titleButton forState:UIControlStateNormal];
			
			[btnCancel addTarget:self action:@selector(clickCancel) forControlEvents:UIControlEventTouchUpInside];
			
			[self addSubview:btnCancel];								
		} else {
            CGRect indicatorRect = CGRectMake((frame.size.width - 30)*1.0 / 2, kPadding + 10, 30, 30);
            _indicator = [[UIActivityIndicatorView alloc] initWithFrame:indicatorRect];
            _indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
            _indicator.backgroundColor = [UIColor clearColor];
            [view addSubview:_indicator];
            
            CGFloat titleY = indicatorRect.origin.y + indicatorRect.size.height;
            
            _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadding,
                                                                    titleY + 10, 
                                                                    frame.size.width - kPadding - kPadding, 
                                                                    frame.size.height - titleY - kPadding - kPadding)];
			
			UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
			btnCancel.frame = CGRectMake((self.frame.size.width  - 180)*1.0 / 2, 
										 view.frame.origin.y + _titleLabel.frame.origin.y +
										 _titleLabel.frame.size.height + 15, 180, 42);
			
			[btnCancel setBackgroundImage:[[UIImage imageNamed:@"btnAlert.png"] stretchableImageWithLeftCapWidth:2.0 topCapHeight:2.0] forState:UIControlStateNormal];
			[btnCancel setTitle:titleButton forState:UIControlStateNormal];
			[btnCancel addTarget:self action:@selector(clickCancel) forControlEvents:UIControlEventTouchUpInside];					
			
			[self addSubview:btnCancel];								
		}
        
        _titleLabel.text = msg;
        _titleLabel.font = kMsgFont;
        _titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.backgroundColor = [UIColor clearColor];
        [view addSubview:_titleLabel];
        
        CGRect oldFrame = _titleLabel.frame;
        _titleLabel.numberOfLines = 0;
        [_titleLabel sizeToFit];
        _titleLabel.frame = oldFrame;
        _titleLabel.textAlignment = UITextAlignmentCenter;
        
        [view release];		
	}
    return self;
}

- (id)initWithMessage:(NSString *)msg {
    return [self initWithMessage:msg alert:NO];
}


- (void)message:(NSString *)msg {
    _titleLabel.text = msg;
}

- (void)clickCancel{
	if ([self isValidDelegateForSelector:@selector(clickCancelButton)])
        [_delegate clickCancelButton];
}

- (CGRect)getFrameFromText:(NSString *)text {
    CGFloat lblW = [text sizeWithFont:kMsgFont].width;
    lblW = (lblW > kMsgMaxWidth) ? kMsgMaxWidth : lblW;
    CGFloat lblH = [Util calculateHeightOfTextFromWidth:text 
                                                withFont:kMsgFont 
                                               withWidth:lblW 
                                       withLineBreakMode:UILineBreakModeTailTruncation];
    
    CGFloat popupW = lblW + kPadding + kPadding;
    popupW = (popupW < 250) ? 250 : popupW;
    CGFloat popupH = lblH + kPadding + kPadding;
    if (!_isAlert) {
        popupH += 60;
    }
    popupH = (popupH < 120) ? 120 : popupH;
    popupH = (popupH > 460) ? 460 : popupH;
    
    return CGRectMake((320 - popupW) * 1.0 / 2, (480 - popupH) * 1.0 / 2, popupW, popupH);
}

- (void)show {    
    if (![self superview]) {
        NSArray *list = [[UIApplication sharedApplication] windows];
        UIWindow *w  = [list objectAtIndex:([list count] -1)];
        [w addSubview:self];
        [w bringSubviewToFront:self];
    }
    self.hidden = FALSE;
    _visibled = TRUE;
    if (_isAlert) {
        [self performSelector:@selector(hide) withObject:nil afterDelay:kAlertDelay];
    } else {
        [_indicator startAnimating];
    }
    [self showOrHide:YES];
}

- (void)showOnView:(UIView *)view {    
    if ([view superview]) {
        [view addSubview:self];
        [view bringSubviewToFront:self];
    }else {
        NSArray *list = [[UIApplication sharedApplication] windows];
        UIWindow *w  = [list objectAtIndex:([list count] -1)];
        [w addSubview:self];
        [w bringSubviewToFront:self];
    }
    self.hidden = FALSE;
    _visibled = TRUE;
    if (_isAlert) {
        [self performSelector:@selector(hide) withObject:nil afterDelay:kAlertDelay];
    } else {
        [_indicator startAnimating];
    }
    [self showOrHide:YES];
}

- (void)hide {
    if (!_visibled)
        return;
    
    if (!_isAlert)
        [_indicator stopAnimating];
    
    self.hidden = TRUE;
    [self performSelector:@selector(removeMeFromSuperview) withObject:nil afterDelay:1.0];
    
    CATransition *animation = [CATransition animation];
    [animation setType:kCATransitionFade];
    [animation setSubtype:kCATransitionFromBottom];
    [animation setDuration:0.4];
    [animation setDelegate:self];
    [[self layer] addAnimation:animation forKey:@"transitionViewAnimation"];
    
    [self showOrHide:NO];
    _visibled = FALSE;
}


- (void)removeMeFromSuperview {
    [self removeFromSuperview];
}


- (void)showOrHide:(BOOL)visibled {
    if ([self isValidDelegateForSelector:@selector(showOrHidePopup:visibled:)])
        [_delegate performSelector:@selector(showOrHidePopup:visibled:) withObject:self withObject:[NSNumber numberWithBool:visibled]];
}


- (BOOL)isValidDelegateForSelector:(SEL)selector {
    return ((self.delegate!= nil) && [self.delegate respondsToSelector:selector]);
}

- (void)setTitle:(NSString *)title{
	_titleLabel.text = title;
}

- (void)dealloc {
    [_titleLabel release];
    if (_indicator) {
        [_indicator release];
    }
    _delegate = nil;
    [super dealloc];
}


@end