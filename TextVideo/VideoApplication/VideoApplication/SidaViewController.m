//
//  SidaViewController.m
//  MobionConnect
//
//  Created by Han Korea on 1/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SidaViewController.h"

@implementation SidaViewController
@synthesize showWithOrientation;
-(void) viewWillAppear:(BOOL)animated {
    /* check show orientation to process */
    if (UIDeviceOrientationUnknown != showWithOrientation) {
        /* check to back process */
        if (!_controler._didPushToNavCtrl){
            /* set didPush flag */
            _controler._didPushToNavCtrl = YES;
            
            /* set application to show orientation */
            UIApplication *myApp = [UIApplication sharedApplication];
            [myApp setStatusBarOrientation:showWithOrientation animated:YES];
            
            /* refresh navigation */
            UIView *aView = self.navigationController.view.superview;
            [self.navigationController.view removeFromSuperview];
            [aView addSubview:self.navigationController.view];
        }
    }
    [super viewWillAppear:animated];
    return;
}


-(void) viewDidAppear:(BOOL)animated {
    /* clean controller */
    _controler._didPushToNavCtrl = NO;
    [super viewDidAppear:animated];
    return;
}

#pragma mark === AUTOROTATE ===
-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    BOOL ret = YES;
    /* check show orientation to return */
    if (UIDeviceOrientationUnknown != showWithOrientation) {
        ret = (interfaceOrientation == showWithOrientation);
    }
    return ret;
} 

@end 
