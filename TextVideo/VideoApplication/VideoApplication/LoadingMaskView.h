//
//  LoadingMaskView.h
//  VideoApplication
//
//  Created by Cuong Tran on 1/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface LoadingMaskView : UIView {
    UIActivityIndicatorView *_indicator;
    UILabel                 *_titleLabel;
    BOOL                    _isAlert, _visibled;
    id                      _delegate;
}
@property(nonatomic, assign) id delegate;
@property(nonatomic, assign) BOOL visibled;

- (id)initWithMessage:(NSString *)msg;
- (id)initWithMessage:(NSString *)msg alert:(BOOL)isAlert;
- (id)initWithMessageOnView:(NSString *)msg alert:(BOOL)isAlert;
- (id)initWithCancelButton:(NSString *)msg alert:(BOOL)isAlert titleButton:(NSString *)titleButton;
- (void)message:(NSString *)msg;
- (void)show;
- (void)hide;
- (void)showOnView:(UIView *)view;
- (void)setTitle:(NSString *)title;

@end


@protocol SVPopupDelegate

@optional

- (void)showOrHidePopup:(id)popup visibled:(NSNumber *)visibled;
- (void)clickCancelButton;

@end
