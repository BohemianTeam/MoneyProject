//
//  iBackAppDelegate.h
//  iBack
//
//  Created by bohemian on 1/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iBackAppDelegate : UIResponder <UIApplicationDelegate>
{
    NSArray *menuArray;
}
@property (nonatomic, retain) NSArray *menuArray;
@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *navigationController;

@end

@interface UINavigationBar (UINavigationBarCategory)
- (void)drawRect:(CGRect)rect;
@end