//
//  main.m
//  iOSStudy
//
//  Created by Knox on 2020/12/27.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "NKLaunchMetrics.h"

int main(int argc, char * argv[]) {
    [NKLaunchMetrics main];
    
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
