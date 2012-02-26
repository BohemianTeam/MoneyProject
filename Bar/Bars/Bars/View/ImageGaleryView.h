//
//  ImageGaleryView.h
//  Bars
//
//  Created by Cuong Tran on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Bar;
@interface ImageGaleryView : UIView <UIScrollViewDelegate>{
    NSMutableArray              *_views;
    NSMutableArray              *_imageLinks;
    
    UIScrollView                *_scrollView;
    CGRect                      _scrollFrame;
    
    UIButton                    *_leftArrow;
    UIButton                    *_rightArrow;
    
    int                         _currentItemIndex;
    int                         _totalItems;
    
    Bar                         *_bar;

}
- (id) initWithFrame:(CGRect)frame withBar:(Bar *) bar;
- (void) notifyDataSetChanged;
@end
