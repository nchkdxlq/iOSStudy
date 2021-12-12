//
//  UIWindow+SafeAreaInsets.m
//  iOSStudy
//
//  Created by Knox on 2021/12/12.
//

#import "UIWindow+SafeAreaInsets.h"
#import <objc/message.h>


@implementation UIWindow (SafeAreaInsets)

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method originMethod = class_getInstanceMethod(self, @selector(makeKeyAndVisible));
        Method newMethod = class_getInstanceMethod(self, @selector(safeAreaInsets_makeKeyAndVisible));
        method_exchangeImplementations(originMethod, newMethod);
    });
}

- (void)safeAreaInsets_makeKeyAndVisible {
    [self safeAreaInsets_makeKeyAndVisible];
    NSValue *safeAreaInsetsValue = [NSValue valueWithUIEdgeInsets:self.safeAreaInsets];
    objc_setAssociatedObject(self.class, @selector(keyWindowSafeAreaInset), safeAreaInsetsValue, OBJC_ASSOCIATION_RETAIN);
}


+ (UIEdgeInsets)keyWindowSafeAreaInset {
    NSValue *safeAreaInsetsValue = objc_getAssociatedObject(self.class, _cmd);
    if (safeAreaInsetsValue == nil) {
        return UIEdgeInsetsZero;
    } else {
        return [safeAreaInsetsValue UIEdgeInsetsValue];
    }
}

@end
