//
//  BarsAppDelegate.m
//  Bars
//
//  Created by bohemian on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BarsAppDelegate.h"

#import "BarsViewController.h"
#import "AppDatabase.h"
#import "Util.h"
#import "Config.h"
#import "BarDetailViewController.h"
#import "Bar.h"

@implementation BarsAppDelegate

@synthesize window = _window;
//@synthesize viewController = _viewController;
@synthesize tabbar = _tabbar;
- (void)dealloc
{
    [_window release];
    [_tabbar release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Util createEditableCopyOfDatabaseIfNeeded:DBFILE];
    [[AppDatabase sharedDatabase] openDB:[Util documentsPath:DBFILE]];
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    
    BarsViewController *vc1 = [[[BarsViewController alloc] initWithID:0 type:States] autorelease];
    vc1.title = @"USA";
    UIImage *tabImage = [UIImage imageNamed:@"usa"];
    UITabBarItem *theItem = [[UITabBarItem alloc] initWithTitle:@"USA" image:tabImage tag:0];
    vc1.tabBarItem = theItem;
    [theItem release];
    

    UINavigationController *navVC1 = [[[UINavigationController alloc] initWithRootViewController:vc1] autorelease];
    navVC1.navigationBar.barStyle = UIBarStyleBlack;
        
    //wishlist view controller
    BarsViewController *vc2 = [[[BarsViewController alloc] initWithID:0 type:Wishlists] autorelease];
    vc2.title = @"WishList";
    tabImage = [UIImage imageNamed:@"wishIcon"];
    theItem = [[UITabBarItem alloc] initWithTitle:@"WishList" image:tabImage tag:1];
    vc2.tabBarItem = theItem;
    [theItem release];
    UINavigationController *navVC2 = [[[UINavigationController alloc] initWithRootViewController:vc2] autorelease];
    navVC2.navigationBar.barStyle = UIBarStyleBlack;
    
    //complete view controller
    BarsViewController *vc3 = [[[BarsViewController alloc] initWithID:0 type:Completeds] autorelease];
    vc3.title = @"Completed";
    tabImage = [UIImage imageNamed:@"CompletedIcon"];
    theItem = [[UITabBarItem alloc] initWithTitle:@"Completed" image:tabImage tag:2];
    vc3.tabBarItem = theItem;
    [theItem release];
    UINavigationController *navVC3 = [[[UINavigationController alloc] initWithRootViewController:vc3] autorelease];
    navVC3.navigationBar.barStyle = UIBarStyleBlack;
    
    self.tabbar = [[UITabBarController alloc] init];
    [self.tabbar setViewControllers:[NSArray arrayWithObjects:navVC1, navVC2, navVC3, nil]];
    //[self.tabbar addChildViewController:navVC1];
    //[self.tabbar addChildViewController:navVC2];
    //[self.tabbar addChildViewController:navVC3];

    self.window.rootViewController = self.tabbar;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end