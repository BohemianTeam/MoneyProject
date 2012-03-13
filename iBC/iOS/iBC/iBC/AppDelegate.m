//
//  AppDelegate.m
//  iBC
//
//  Created by Cuong Tran on 2/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"
#import "config.h"
#import "Service.h"
#import "ResponseObj.h"
#import "Util.h"
#import "CJSONDeserializer.h"

@implementation AppDelegate
@synthesize starredList;
@synthesize window = _window;
@synthesize viewController = _viewController;

- (void)dealloc
{
    [starredList release];
    [_window release];
    [_viewController release];
    [super dealloc];
}
- (void)showRootView
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.viewController = [[[ViewController alloc] initWithNibName:@"ViewController_iPhone" bundle:nil] autorelease];
    } else {
        self.viewController = [[[ViewController alloc] initWithNibName:@"ViewController_iPad" bundle:nil] autorelease];
    }
    UINavigationController * rootViewController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    self.window.rootViewController = rootViewController;
    [self.window makeKeyAndVisible];
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //check existed of unique key
    NSString *instID = [Util getInstID];
    if(instID == nil){
        //get unique install key
        [self getUniqueInsKey];
    }else{
        //get starred list
        [self getStarredList];
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
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}
#pragma mark - Starredlist methods
- (BOOL)isInStarredList:(NSString*)code
{
    if(starredList != nil)
    {
        if([starredList containsObject:code])
            return YES;
    }
    
    return NO;
}
- (void)updateStarredList:(NSString*)code status:(NSInteger)stt
{
    if(stt == 1)    //add code
    {
        [starredList addObject:code];
    }else{          //remoce code
        [starredList removeObject:code];
    }
}

#pragma mark - Service methods
- (void)getUniqueInsKey
{
    NSLog(@"getUniqueInsKey");
    Service *service = [[Service alloc] init];
    service.canShowAlert = YES;
    service.canShowLoading = YES;
    service.delegate = self;
    [service getInstID];
    
    [service release];
}
- (void)getStarredList
{
    NSLog(@"getStarredList");
    if(starredList != nil){
        [starredList release];
        starredList = nil;
    }
    starredList = [[NSMutableArray alloc] init];
    
    Service *service = [[Service alloc] init];
    service.canShowAlert = YES;
    service.canShowLoading = YES;
    service.delegate = self;
    [service getStarredList];
    
    [service release];
}
#pragma mark - service delegate
- (void) mServiceGetStarredListSucces:(Service *) service responses:(id) response {
    NSLog(@"API mServiceGetStarredListSucces : success");
    
    CJSONDeserializer *jsonDeserializer = [CJSONDeserializer deserializer];

    //update starred list
    NSArray *resArray = [jsonDeserializer deserializeAsArray:(NSData*)response error:nil];
    for (NSDictionary *dict in resArray) {
        NSLog(@"starredList: %@", [dict objectForKey:Code]);
        [starredList addObject:[dict objectForKey:Code]];
    }

    //show root view controller
    [self showRootView];
}
- (void) mServiceGetInstIDSucces:(Service *) service responses:(id) response {
    NSLog(@"API getInstID : success");
    
    ResponseObj *resObj = [[ResponseObj alloc] initWithDataResponse:(NSData*)response];
    NSString *instID = [resObj getObjectForKey:InstID];
    NSLog(@"instID: %@", [resObj getObjectForKey:InstID]);
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if(standardUserDefaults)
    {
        [standardUserDefaults setObject:instID forKey:kAppInstall];
    }
    
    //get starred list
    [self getStarredList];
}

- (void) mService:(Service *) service didFailWithError:(NSError *) error {
    
}

@end
