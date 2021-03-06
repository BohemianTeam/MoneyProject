//
//  AppDelegate.m
//  VideoApplication
//
//  Created by Cuong Tran on 1/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "NewMookViewController.h"
#import "MainViewController.h"
#import "Util.h"
#import "VideoDatabase.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize rootViewController = _rootViewController;
#pragma mark create database file
////////////////////////////////////////////////////////////////////////////////////////////
///////						create database file									///////
///////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)applicationDocumentsDirectory
{ 
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
												NSUserDomainMask, YES) lastObject]; 
} 
- (NSString*)createEditableCopyOfDatabaseIfNeeded: (NSString*)nameDB
{ 
    // First, test for existence - we don’t want to wipe out a user’s DB 
    NSFileManager *fileManager = [NSFileManager defaultManager]; 
    NSString *documentsDirectory = [self applicationDocumentsDirectory]; 
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:nameDB]; 
	
    BOOL dbexists = [fileManager fileExistsAtPath:writableDBPath]; 
    if (!dbexists) {  
		// The writable database does not exist, so copy the default to the 
		NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:nameDB]; 
		
		NSError *error; 
		BOOL success = [fileManager copyItemAtPath:defaultDBPath 
											toPath:writableDBPath error:&error]; 
		if (!success) { 
			NSAssert1(0, @"Failed to create writable database file with message'%@'.", [error localizedDescription]); 
		} 
    }
    
    return writableDBPath;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    //create database
    NSString *dbPath = [self createEditableCopyOfDatabaseIfNeeded: DBFILE];
	[[VideoDatabase sharedDatabase] openDB:dbPath];
    
    // Override point for customization after application launch.
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    MainViewController *rootViewController = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    [_window addSubview:navigationController.view];
    [_window makeKeyAndVisible]; 
    [Util createResourcesDir];
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
