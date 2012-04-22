//
//  BarsAppDelegate.h
//  Bars
//
//  Created by bohemian on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"
@class BarsViewController;
@class FacebookViewController;
@interface BarsAppDelegate : UIResponder <UIApplicationDelegate, UIAlertViewDelegate> {
    Facebook                *facebook;
    NSMutableDictionary     *userPermissions;
    FacebookViewController  *facebookViewController;
}

@property (strong, nonatomic) UIWindow *window;

//@property (strong, nonatomic) BarsViewController    *viewController;
@property (strong, nonatomic) UITabBarController    *tabbar;
@property (nonatomic, retain) Facebook *facebook;
@property (nonatomic, retain) NSMutableDictionary *userPermissions;
@property (nonatomic, retain) FacebookViewController *facebookViewController;
@end
