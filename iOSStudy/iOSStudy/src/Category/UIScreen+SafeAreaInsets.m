//
//  UIScreen+SafeAreaInsets.m
//  iOSStudy
//
//  Created by Knox on 2021/12/12.
//

#import "UIScreen+SafeAreaInsets.h"
#import <objc/message.h>


@implementation UIScreen (SafeAreaInsets)

+ (UIEdgeInsets)safeAreaInset {
    if (@available(iOS 11.0, *)) {
        NSValue *safeAreaInsetsValue = objc_getAssociatedObject(self, _cmd);
        if (safeAreaInsetsValue) {
            return [safeAreaInsetsValue UIEdgeInsetsValue];
        }
        UIWindow *window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
        UIEdgeInsets insets = window.safeAreaInsets;
        objc_setAssociatedObject(self, _cmd, [NSValue valueWithUIEdgeInsets:insets], OBJC_ASSOCIATION_RETAIN);
        return insets;
    } else {
        return UIEdgeInsetsMake(20, 0, 0, 0);
    }
}

@end

