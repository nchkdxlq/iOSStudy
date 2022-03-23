//
//  UIScreen+SafeAreaInsets.m
//  iOSStudy
//
//  Created by Knox on 2021/12/12.
//

#import "UIScreen+SafeAreaInsets.h"
#import <objc/message.h>
#import "UIDevice+UnitType.h"


@implementation UIScreen (SafeAreaInsets)

+ (UIEdgeInsets)areaInsets {
    if (@available(iOS 11.0, *)) {
        static NSDictionary<UIDeviceTypeName, NSValue *> *insetsMap;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            insetsMap = @{
                UIDeviceTypeNameiPhoneX:        [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(44, 0, 34, 0)],
                UIDeviceTypeNameiPhoneXS:       [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(44, 0, 34, 0)],
                UIDeviceTypeNameiPhoneXSMax:    [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(44, 0, 34, 0)],
                UIDeviceTypeNameiPhoneXR:       [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(48, 0, 34, 0)],
                UIDeviceTypeNameiPhone11:       [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(48, 0, 34, 0)],
                UIDeviceTypeNameiPhone11Pro:    [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(44, 0, 34, 0)],
                UIDeviceTypeNameiPhone11ProMax: [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(44, 0, 34, 0)],
                UIDeviceTypeNameiPhone12:       [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(47, 0, 34, 0)],
                UIDeviceTypeNameiPhone12Pro:    [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(47, 0, 34, 0)],
                UIDeviceTypeNameiPhone12ProMax: [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(47, 0, 34, 0)],
                UIDeviceTypeNameiPhone12Mini:   [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(50, 0, 34, 0)],
                UIDeviceTypeNameiPhone13:       [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(47, 0, 34, 0)],
                UIDeviceTypeNameiPhone13Pro:    [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(47, 0, 34, 0)],
                UIDeviceTypeNameiPhone13ProMax: [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(47, 0, 34, 0)],
                UIDeviceTypeNameiPhone13Mini:   [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(50, 0, 34, 0)],
            };
        });
        
        NSValue *value = insetsMap[[UIDevice currentDevice].deviceTypeName];
        if (value != nil) {
            return value.UIEdgeInsetsValue;
        }
    }
    return UIEdgeInsetsZero;
}

+ (BOOL)isNotch {
    return self.areaInsets.top > 0;
}

@end

