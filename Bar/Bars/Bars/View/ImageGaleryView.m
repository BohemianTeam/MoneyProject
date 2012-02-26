//
//  ImageGaleryView.m
//  Bars
//
//  Created by Cuong Tran on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ImageGaleryView.h"
#define kItemPerPage 1
#define PAGE_WIDTH  180
#define PAGE_HEIGH  180

@interface ImageGaleryView (private)
- (void) generateScroll;
- (void) updateArrowButton;
- (void) scrollToPage:(int) pageIndex;
@end

@implementation ImageGaleryView 
    
- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _views = [[NSMutableArray alloc] init];
        _imageLinks = [[NSMutableArray alloc] initWithObjects:@"album.png",@"camera.png",@"album.png",@"camera.png",@"album.png", nil];
        
        UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, PAGE_WIDTH, PAGE_HEIGH)];
        bg.image = [UIImage imageNamed:@"image_border.png"];
        
//        [self addSubview:bg];
        [bg release];
        
        _scrollFrame = CGRectMake((frame.size.width - PAGE_WIDTH) / 2, 0, PAGE_WIDTH, PAGE_HEIGH);
        _scrollView = [[UIScrollView alloc] initWithFrame:_scrollFrame];
        
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.clipsToBounds = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:_scrollView];
        
        _leftArrow = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftArrow.frame = CGRectMake(20, (PAGE_HEIGH - 39) / 2, 39, 21);
        _leftArrow.tintColor = [UIColor blueColor];
        [_leftArrow setImage:[UIImage imageNamed:@"ArrowScrollLeft.png"] forState:UIControlStateNormal];
        [_leftArrow addTarget:self action:@selector(didArrowClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_leftArrow];
        
        _rightArrow = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightArrow.frame = CGRectMake(258, (PAGE_HEIGH - 39) / 2, 39, 21);
        [_rightArrow setImage:[UIImage imageNamed:@"ArrowScrollRight.png"] forState:UIControlStateNormal];
        [_rightArrow addTarget:self action:@selector(didArrowClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_rightArrow];
        
        [self generateScroll];

    }
    
    return self;
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
    for (int j = 0; j < [_imageLinks count]; j++) {
        UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[_imageLinks objectAtIndex:j]]];
        [_views addObject:img];
        [img release];
    }
    _currentItemIndex = 0;
    _totalItems = [_views count];
    int i;
    for (i = 0;i < _totalItems;i++) {
        UIImageView *img = [_views objectAtIndex:i];
        img.frame = CGRectMake(PAGE_WIDTH * i,0, PAGE_WIDTH, PAGE_HEIGH);
        [_scrollView addSubview:img];
        [img release];
    }
    
    _scrollView.contentSize = CGSizeMake(_scrollFrame.size.width * _totalItems, _scrollFrame.size.height);
    
    
    [self updateArrowButton];
}

- (void) updateArrowButton {
    if (_currentItemIndex == 0) {
        _leftArrow.hidden = YES;
        _rightArrow.hidden = NO;
    } else if (_currentItemIndex == _totalItems - 1) {
        _leftArrow.hidden = NO;
        _rightArrow.hidden = YES;
    } else {
        _leftArrow.hidden = NO;
        _rightArrow.hidden = NO;
    }
    
    for (int i = 0;i < [_views count];i++) {
        _currentItemIndex == i ? [[_views objectAtIndex:i] setHidden:NO] : [[_views objectAtIndex:i] setHidden:YES];
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
    [_views release];
    [_scrollView release];
    [_imageLinks release];
    [super dealloc];
}

@end
