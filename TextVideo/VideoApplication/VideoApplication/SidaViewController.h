//
//  SidaViewController.h
//  MobionConnect
//
//  Created by Han Korea on 1/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SidaViewController : UIViewController {
    UIInterfaceOrientation showWithOrientation;
    struct {
        unsigned int  _didPushToNavCtrl:1;
    } _controler;
} 
@property (nonatomic,assign) UIInterfaceOrientation showWithOrientation;
@end
