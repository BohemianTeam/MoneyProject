//
//  VideoSubView.m
//  VideoApplication
//
//  Created by bohemian on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VideoSubView.h"

@implementation VideoSubView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        flagMove = false;
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
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touch Begin");
    UITouch *touch = [touches anyObject];
	firstTouch = [touch locationInView:self];
    
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touch moved");
	flagMove = true;
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"Touch End");
    
    if(flagMove){
        UITouch *touch = [touches anyObject];
        CGPoint endTouch = [touch locationInView:self];
        
        if(endTouch.x - firstTouch.x >= 0){
            NSLog(@"go forward (right)");
        }else{
            NSLog(@"go back (left)");
        }
        flagMove = !flagMove;
    }
    
}
@end
