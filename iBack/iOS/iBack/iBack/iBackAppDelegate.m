//
//  iBackAppDelegate.m
//  iBack
//
//  Created by bohemian on 1/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "iBackAppDelegate.h"

#import "iBackMasterViewController.h"
#import "FileHelper.h"
@implementation iBackAppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;
@synthesize menuArray;
- (void)dealloc
{
    
    [_window release];
    [_navigationController release];
    [menuArray release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [FileHelper createFolder:IMG_FOLDER_TEMP withPath:[FileHelper documentsPath]];
    [FileHelper createFolder:VIDEO_FOLDER_TEMP withPath:[FileHelper documentsPath]];
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.

    //create menu
    menuArray = [[NSArray alloc] initWithObjects:@"About", @"Settings", @"How To", @"Record Video", @"Record Audio", @"Saved Files", nil];
    
    //check version of device
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    NSLog(@"version device: %f", version);
    if (version >= 5.0)
    {
        NSLog(@"version device: %f", version);
        UIImage *gradientNaviBar = [[UIImage imageNamed:@"NaviBar"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        // Set the background image dor all UINavigationBars
        [[UINavigationBar appearance] setBackgroundImage:gradientNaviBar forBarMetrics:UIBarMetricsDefault];
    }

    
    iBackMasterViewController *masterViewController = [[[iBackMasterViewController alloc] initWithNibName:@"iBackMasterViewController" bundle:nil] autorelease];
    self.navigationController = [[[UINavigationController alloc] initWithRootViewController:masterViewController] autorelease];
    self.window.rootViewController = self.navigationController;
    
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
// UINavigationBar category
@implementation UINavigationBar (UINavigationBarCategory)
// iPhone 3.0 code here
- (void)drawRect:(CGRect)rect {
    #if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_5_0
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version < 5.0)
    {
        UIImage *image = [UIImage imageNamed:@"NaviBar"];
        [image drawInRect: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) ];
    }
    [super drawRect:rect];
    #endif 
}

@end
