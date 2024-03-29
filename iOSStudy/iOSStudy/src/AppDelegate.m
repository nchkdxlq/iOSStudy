//
//  AppDelegate.m
//  iOSStudy
//
//  Created by Knox on 2020/12/27.
//

#import "AppDelegate.h"
#import "FeatureListViewController.h"
#import "NKCallTrace.h"
#import "NKLaunchMetrics.h"
#import "UIDevice+UnitType.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    [NKCallTrace start];
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    NSLog(@"%@ areaInset = %@", [UIDevice currentDevice].deviceTypeName, NSStringFromUIEdgeInsets(window.safeAreaInsets));
    NSLog(@"%@ areaInset = %@", [UIDevice currentDevice].deviceTypeName, NSStringFromUIEdgeInsets(UIScreen.areaInsets));
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[FeatureListViewController new]];
    window.rootViewController = nav;
    self.window = window;
    [window makeKeyAndVisible];
    [NKRunLoopActivityMonitor startMonitor];
    
    [NKLaunchMetrics didFinishLaunchingEnd];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"%s", __func__);
    
//    [NKCallTrace getCallRecords];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
