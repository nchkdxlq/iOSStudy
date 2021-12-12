//
//  UIScreen+SafeAreaInsets.m
//  iOSStudy
//
//  Created by Knox on 2021/12/12.
//

#import "UIScreen+SafeAreaInsets.h"
#import <objc/message.h>


@implementation UIScreen (SafeAreaInsets)

+ (void)setSafeAreaInset:(UIEdgeInsets)safeAreaInset {
    NSValue *safeAreaInsetsValue = [NSValue valueWithUIEdgeInsets:safeAreaInset];
    objc_setAssociatedObject(self, @selector(safeAreaInset), safeAreaInsetsValue, OBJC_ASSOCIATION_RETAIN);
}

+ (UIEdgeInsets)safeAreaInset {
    NSValue *safeAreaInsetsValue = objc_getAssociatedObject(self, _cmd);
    if (safeAreaInsetsValue == nil) {
        UIWindow *window =[[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
        return window.safeAreaInsets;
    } else {
        return [safeAreaInsetsValue UIEdgeInsetsValue];
    }
}

@end


//////////////////////////////////////////////////////

@implementation UIWindow (SafeAreaInsets)

+ (void)initialize {
    if (@available(iOS 11.0, *)) {    
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            Method originMethod = class_getInstanceMethod(self, @selector(initWithFrame:));
            Method newMethod = class_getInstanceMethod(self, @selector(safeAreaInsets_initWithFrame:));
            method_exchangeImplementations(originMethod, newMethod);
        });
    }
}

- (instancetype)safeAreaInsets_initWithFrame:(CGRect)frame {
    UIWindow *window = [self safeAreaInsets_initWithFrame:frame];
    if (self) {
        if (CGRectEqualToRect(frame, UIScreen.mainScreen.bounds)) {
            [UIScreen setSafeAreaInset:window.safeAreaInsets];
        }
    }
    return window;
}

@end

