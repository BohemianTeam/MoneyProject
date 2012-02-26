//
//  ImageGaleryView.m
//  Bars
//
//  Created by Cuong Tran on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ImageGaleryView.h"
#import "Bar.h"
#import "Util.h"

#define kItemPerPage 1
#define PAGE_WIDTH  200
#define PAGE_HEIGH  188
#define BORDER 10
@interface ImageGaleryView (private)
- (void) generateScroll;
- (void) updateArrowButton;
- (void) scrollToPage:(int) pageIndex;
- (void) getAllBarImage;
- (void) updateImageVisible;
@end

@implementation ImageGaleryView 
    
- (id) initWithFrame:(CGRect)frame withBar:(Bar *)bar{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _bar = [bar retain];
        
        _views = [[NSMutableArray alloc] init];
        _imageLinks = [[NSMutableArray alloc] init];
        
        _scrollFrame = CGRectMake((frame.size.width - PAGE_WIDTH) / 2, BORDER + BORDER + 1, PAGE_WIDTH, PAGE_HEIGH);
        
        UIImageView *bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image_border.png"]];
        bg.frame = CGRectMake((frame.size.width - 247) / 2 , 0, 248, 233);
        [self addSubview:bg];
        [bg release];
        
        _scrollView = [[UIScrollView alloc] initWithFrame:_scrollFrame];
        
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.clipsToBounds = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.scrollEnabled = NO;
        [self addSubview:_scrollView];
        
        _leftArrow = [[UIButton alloc] init];
        _leftArrow.frame = CGRectMake(0, (233 - 46) / 2, 46, 46);
        _leftArrow.tintColor = [UIColor blueColor];
        [_leftArrow setImage:[UIImage imageNamed:@"left_arrow.jpeg"] forState:UIControlStateNormal];
        [_leftArrow addTarget:self action:@selector(didArrowClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_leftArrow];
        
        _rightArrow = [[UIButton alloc] init];
        _rightArrow.frame = CGRectMake(274, (233 - 46) / 2, 46, 46);
        [_rightArrow setImage:[UIImage imageNamed:@"right-arrow.jpeg"] forState:UIControlStateNormal];
        [_rightArrow addTarget:self action:@selector(didArrowClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_rightArrow];
        
        [self notifyDataSetChanged];

    }
    
    return self;
}

- (void) notifyDataSetChanged {
    [_imageLinks removeAllObjects];
    [_views removeAllObjects];
    
    [self getAllBarImage];
    [self generateScroll];
    
}

- (void) getAllBarImage {
    NSString *barImgDir = [Util getImageBarDir:_bar.barName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *arr = [fileManager contentsOfDirectoryAtPath:barImgDir error:nil];
    _imageLinks = [[NSMutableArray alloc] initWithArray:arr];
}


- (void) didArrowClicked:(id) sender {
    if (sender == _leftArrow) {
        (_currentItemIndex - 1) < 0 ? (_currentItemIndex = 0) : (_currentItemIndex = _currentItemIndex - 1);
    } else if (sender == _rightArrow) {
        (_currentItemIndex + 1) >= _totalItems ? (_currentItemIndex = _totalItems - 1) : (_currentItemIndex = _currentItemIndex + 1);
    }
    
    [self scrollToPage:_currentItemIndex];
    [self updateArrowButton];
}


- (void) scrollToPage:(int)pageIndex {
    CGRect lastVisibleRect;
    CGSize contentSize = [_scrollView contentSize];
    lastVisibleRect.size.height = contentSize.height; //We want the visible rect height to be the content view height as we are only scrolling horizontally
    lastVisibleRect.origin.y = 0.0; // So the y origin should be 0
    lastVisibleRect.size.width = PAGE_WIDTH; // The visible rect width should be as wide as the screen
    lastVisibleRect.origin.x  = contentSize.width - PAGE_WIDTH * (_totalItems - pageIndex); // And the x position should be all the way to the right - one page width (assumes a page is as wide as the screen)
    [_scrollView scrollRectToVisible:lastVisibleRect animated:NO];
}


- (void) generateScroll {
    if ([_scrollView.subviews count] > 0) {
        for (UIView *subview in _scrollView.subviews) {
            [subview removeFromSuperview];
        }
    }
    
    for (int j = 0; j < [_imageLinks count]; j++) {
        NSString *imgPath = [_imageLinks objectAtIndex:j];
        NSString *fullPath = [[Util getImageBarDir:_bar.barName] stringByAppendingString:[NSString stringWithFormat:@"/%@", imgPath]];

        UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:fullPath]];
        [_views addObject:img];
        [img release];
    }
    _totalItems = [_views count];
    
    _totalItems == 0 ? (_currentItemIndex = 0) : (_currentItemIndex = _totalItems - 1);
    
    for (UIView *view in _scrollView.subviews) {
        [view removeFromSuperview];
    }
    int i;
    for (i = 0;i < _totalItems;i++) {
        UIImageView *img = [[_views objectAtIndex:i] retain];
        img.frame = CGRectMake(PAGE_WIDTH * i,0, PAGE_WIDTH, PAGE_HEIGH);
        [_scrollView addSubview:img];
        [img release];
    }
    
    _scrollView.contentSize = CGSizeMake(_scrollFrame.size.width * _totalItems, _scrollFrame.size.height);
    
    [self scrollToPage:_currentItemIndex];
    
    [self updateArrowButton];
}

- (void) updateArrowButton {
    if (_currentItemIndex == 0) {
        if ([_views count] == 0 || [_views count] == 1) {
            _leftArrow.hidden = YES;
            _rightArrow.hidden = YES;
        } else {
            _leftArrow.hidden = YES;
            _rightArrow.hidden = NO;
        }
    } else if (_currentItemIndex == _totalItems - 1) {
        _leftArrow.hidden = NO;
        _rightArrow.hidden = YES;
    } else {
        _leftArrow.hidden = NO;
        _rightArrow.hidden = NO;
    }
    
    [self updateImageVisible];
}

- (void) updateImageVisible {
    for (int i = 0;i < [_views count];i++) {
        (_currentItemIndex == i) ? [[_views objectAtIndex:i] setHidden:NO] : [[_views objectAtIndex:i] setHidden:YES];
    }
}

#pragma mark Scrool view delegate functions
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    int pageWidth = PAGE_WIDTH;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    if (0 <= page && page < _totalItems) {
        _currentItemIndex = page;
        NSLog(@"%d", _currentItemIndex);
    }
    
    [self updateArrowButton];
}



- (void) dealloc {
    [_leftArrow release];
    [_rightArrow release];
    [_views release];
    [_scrollView release];
    [_imageLinks release];
    [super dealloc];
}

@end
