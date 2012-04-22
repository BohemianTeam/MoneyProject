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
#import "AbstractNavigationController.h"
#import "UINavigationBar+CustomBackground.h"
#import "FacebookViewController.h"
static NSString* kAppId = @"166549606700386";
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
@implementation BarsAppDelegate

@synthesize window = _window;
//@synthesize viewController = _viewController;
@synthesize tabbar = _tabbar;
@synthesize facebook,userPermissions, facebookViewController;
- (void)dealloc
{
    [facebookViewController release];
    [facebook release];
    [userPermissions release];
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
    

    AbstractNavigationController *navVC1 = [[[AbstractNavigationController alloc] initWithRootViewController:vc1] autorelease];
//    navVC1.navigationBar.barStyle = UIBarStyleBlackOpaque;
        
    //wishlist view controller
    BarsViewController *vc2 = [[[BarsViewController alloc] initWithID:0 type:Wishlists] autorelease];
    vc2.title = @"WishList";
    tabImage = [UIImage imageNamed:@"wishIcon"];
    theItem = [[UITabBarItem alloc] initWithTitle:@"WishList" image:tabImage tag:1];
    vc2.tabBarItem = theItem;
    [theItem release];
    
    AbstractNavigationController *navVC2 = [[[AbstractNavigationController alloc] initWithRootViewController:vc2] autorelease];
//    navVC2.navigationBar.barStyle = UIBarStyleBlackOpaque;
    
    //complete view controller
    BarsViewController *vc3 = [[[BarsViewController alloc] initWithID:0 type:Completeds] autorelease];
    vc3.title = @"Completed";
    tabImage = [UIImage imageNamed:@"CompletedIcon"];
    theItem = [[UITabBarItem alloc] initWithTitle:@"Completed" image:tabImage tag:2];
    vc3.tabBarItem = theItem;
    [theItem release];
    
    AbstractNavigationController *navVC3 = [[[AbstractNavigationController alloc] initWithRootViewController:vc3] autorelease];
//    navVC3.navigationBar.barStyle = UIBarStyleBlackOpaque;
    
    self.tabbar = [[UITabBarController alloc] init];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"5.0")) {
        self.tabbar.tabBar.tintColor = kNavigationBarCustomTintColor;//[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_o"]];
    }
    
    [self.tabbar setViewControllers:[NSArray arrayWithObjects:navVC1, navVC2, navVC3, nil]];
    // Initialize Facebook
    facebookViewController = [[FacebookViewController alloc] init];
    
    facebook = [[Facebook alloc] initWithAppId:kAppId andDelegate:nil];
    
    // Check and retrieve authorization information
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] && [defaults objectForKey:@"FBExpirationDateKey"]) {
        facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
    // Initialize user permissions
    userPermissions = [[NSMutableDictionary alloc] initWithCapacity:1];
    
    // Override point for customization after application launch.
    // Add the navigation controller's view to the window and display.
    self.window.rootViewController = self.tabbar;
    [self.window makeKeyAndVisible];
    
    // Check App ID:
    // This is really a warning for the developer, this should not
    // happen in a completed app
    if (!kAppId) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Setup Error"
                                  message:@"Missing app ID. You cannot run the app until you provide this in the code."
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil,
                                  nil];
        [alertView show];
        [alertView release];
    } else {
        // Now check that the URL scheme fb[app_id]://authorize is in the .plist and can
        // be opened, doing a simple check without local app id factored in here
        NSString *url = [NSString stringWithFormat:@"fb%@://authorize",kAppId];
        BOOL bSchemeInPlist = NO; // find out if the sceme is in the plist file.
        NSArray* aBundleURLTypes = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleURLTypes"];
        if ([aBundleURLTypes isKindOfClass:[NSArray class]] &&
            ([aBundleURLTypes count] > 0)) {
            NSDictionary* aBundleURLTypes0 = [aBundleURLTypes objectAtIndex:0];
            if ([aBundleURLTypes0 isKindOfClass:[NSDictionary class]]) {
                NSArray* aBundleURLSchemes = [aBundleURLTypes0 objectForKey:@"CFBundleURLSchemes"];
                if ([aBundleURLSchemes isKindOfClass:[NSArray class]] &&
                    ([aBundleURLSchemes count] > 0)) {
                    NSString *scheme = [aBundleURLSchemes objectAtIndex:0];
                    if ([scheme isKindOfClass:[NSString class]] &&
                        [url hasPrefix:scheme]) {
                        bSchemeInPlist = YES;
                    }
                }
            }
        }
        // Check if the authorization callback will work
        BOOL bCanOpenUrl = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString: url]];
        if (!bSchemeInPlist || !bCanOpenUrl) {
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"Setup Error"
                                      message:@"Invalid or missing URL scheme. You cannot run the app until you set up a valid URL scheme in your .plist."
                                      delegate:self
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil,
                                      nil];
            [alertView show];
            [alertView release];
        }
    }

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
    // Although the SDK attempts to refresh its access tokens when it makes API calls,
    // it's a good practice to refresh the access token also when the app becomes active.
    // This gives apps that seldom make api calls a higher chance of having a non expired
    // access token.
    [[self facebook] extendAccessTokenIfNeeded];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [self.facebook handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [self.facebook handleOpenURL:url];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}
- (void) applicationDidReceiveMemoryWarning:(UIApplication *)application {
    NSLog(@"memory warning");
}
#pragma mark - UIAlertViewDelegate methods
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // Quit the app
    exit(1);
}

@end
