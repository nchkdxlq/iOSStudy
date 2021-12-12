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
        UIEdgeInsets insets;
        if (@available(iOS 11.0, *)) {
            UIWindow *window =[[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
            insets = window.safeAreaInsets;
        } else {
            insets = UIEdgeInsetsMake(20, 0, 0, 0);
            [UIScreen setSafeAreaInset:insets];
        }
        return insets;
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

- (instancetype)safeAreaInsets_initWithFrame:(CGRect)frame API_AVAILABLE(ios(11.0)) {
    [self safeAreaInsets_initWithFrame:frame];
    if (CGRectEqualToRect(frame, UIScreen.mainScreen.bounds)) {
        [UIScreen setSafeAreaInset:self.safeAreaInsets];
    }
    return self;
}

@end

