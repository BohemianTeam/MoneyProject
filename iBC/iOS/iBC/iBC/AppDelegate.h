//
//  AppDelegate.h
//  iBC
//
//  Created by Cuong Tran on 2/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSMutableArray             *starredList;
}
@property(nonatomic, retain)NSMutableArray             *starredList;
@property (strong, nonatomic)UIWindow           *window;
@property (strong, nonatomic)ViewController     *viewController;

- (void)getUniqueInsKey;
- (void)getStarredList;
- (BOOL)isInStarredList:(NSString*)code;
- (void)updateStarredList:(NSString*)code status:(NSInteger)stt;
@end
