//
//  BarsAppDelegate.h
//  Bars
//
//  Created by bohemian on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BarsViewController;

@interface BarsAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//@property (strong, nonatomic) BarsViewController    *viewController;
@property (strong, nonatomic) UITabBarController    *tabbar;
@end
