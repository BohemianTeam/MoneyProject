//
//  VideoSubView.h
//  VideoApplication
//
//  Created by bohemian on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VideoSubViewTouchDelegate;
@interface VideoSubView : UIView
{
    CGPoint				firstTouch;
    BOOL                flagMove;
    
    id<VideoSubViewTouchDelegate>   touchDelegate;
}
@property(nonatomic, assign)id<VideoSubViewTouchDelegate>   touchDelegate;
@end
@protocol VideoSubViewTouchDelegate
- (void)goForwardView;
@end