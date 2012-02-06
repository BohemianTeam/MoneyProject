//
//  UIApplicationExt.m
//  VideoApplication
//
//  Created by Cuong Tran on 1/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIApplicationExt.h"

static int networkActivityCount = 0;

@implementation UIApplication(Ext)

- (void)showNetworkActivityIndicatorVisible:(BOOL)flag {
    if (flag){
        networkActivityCount++;
        [self setNetworkActivityIndicatorVisible:flag];
    } else {        
        networkActivityCount--;
        if (networkActivityCount <= 0) {
            networkActivityCount = 0;
            [self setNetworkActivityIndicatorVisible:NO];
        }
    }    
}

@end
