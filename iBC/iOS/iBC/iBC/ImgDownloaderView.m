//
//  ImgDownloaderView.m
//  iBC
//
//  Created by bohemian on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ImgDownloaderView.h"

@implementation ImgDownloaderView

#pragma - SetImageDownload delegate
- (void)setImage:(UIImage*)img
{
    NSLog(@"set img- %f - %f", self.frame.origin.x, self.frame.size.height);
    //UIImage *imgf = [UIImage imageNamed:@"ttt.jpg"];
    //[self setImage:img];
    [super setImage:img];
}

@end
