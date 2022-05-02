//
//  UIDevice+UnitType.m
//  iOSStudy
//
//  Created by Knox on 2022/3/22.
//

#import "UIDevice+UnitType.h"
#import <sys/utsname.h>

const UIDeviceTypeName UIDeviceTypeNameUnkown = @"Unkown";

const UIDeviceTypeName UIDeviceTypeNameiPhone1G = @"iPhone 1G";
const UIDeviceTypeName UIDeviceTypeNameiPhone3G = @"iPhone 3G";
const UIDeviceTypeName UIDeviceTypeNameiPhone3GS = @"iPhone 3GS";

// 2010
const UIDeviceTypeName UIDeviceTypeNameiPhone4 = @"iPhone 4";

// 2011
const UIDeviceTypeName UIDeviceTypeNameiPhone4s = @"iPhone 4s";

// 2012
const UIDeviceTypeName UIDeviceTypeNameiPhone5 = @"iPhone 5";

// 2013
const UIDeviceTypeName UIDeviceTypeNameiPhone5s = @"iPhone 5s";
const UIDeviceTypeName UIDeviceTypeNameiPhone5c = @"iPhone 5c";

// 2014
const UIDeviceTypeName UIDeviceTypeNameiPhone6 = @"iPhone 6";
const UIDeviceTypeName UIDeviceTypeNameiPhone6Plus = @"iPhone 6 Plus";

// 2015
const UIDeviceTypeName UIDeviceTypeNameiPhone6s = @"iPhone 6s";
const UIDeviceTypeName UIDeviceTypeNameiPhone6sPlus = @"iPhone 6s Plus";

// 2016
const UIDeviceTypeName UIDeviceTypeNameiPhoneSE = @"iPhone SE";
const UIDeviceTypeName UIDeviceTypeNameiPhone7 = @"iPhone 7";
const UIDeviceTypeName UIDeviceTypeNameiPhone7Plus = @"iPhone 7 Plus";

// 2017
const UIDeviceTypeName UIDeviceTypeNameiPhone8 = @"iPhone 8";
const UIDeviceTypeName UIDeviceTypeNameiPhone8Plus = @"iPhone 8 Plus";

// 2018
const UIDeviceTypeName UIDeviceTypeNameiPhoneX = @"iPhone X";
const UIDeviceTypeName UIDeviceTypeNameiPhoneXS = @"iPhone Xs";
const UIDeviceTypeName UIDeviceTypeNameiPhoneXSMax = @"iPhone Xs Max";
const UIDeviceTypeName UIDeviceTypeNameiPhoneXR = @"iPhone Xʀ";

// 2019
const UIDeviceTypeName UIDeviceTypeNameiPhone11 = @"iPhone 11";
const UIDeviceTypeName UIDeviceTypeNameiPhone11Pro = @"iPhone 11 Pro";
const UIDeviceTypeName UIDeviceTypeNameiPhone11ProMax = @"iPhone 11 Pro Max";

// 2020
const UIDeviceTypeName UIDeviceTypeNameiPhoneSE2 = @"iPhone SE 2";
const UIDeviceTypeName UIDeviceTypeNameiPhone12 = @"iPhone 12";
const UIDeviceTypeName UIDeviceTypeNameiPhone12Mini = @"iPhone 12 mini";
const UIDeviceTypeName UIDeviceTypeNameiPhone12Pro = @"iPhone 12 Pro";
const UIDeviceTypeName UIDeviceTypeNameiPhone12ProMax = @"iPhone 12 Pro Max";

// 2021
const UIDeviceTypeName UIDeviceTypeNameiPhone13 = @"iPhone 13";
const UIDeviceTypeName UIDeviceTypeNameiPhone13Mini = @"iPhone 13 mini";
const UIDeviceTypeName UIDeviceTypeNameiPhone13Pro = @"iPhone 13 Pro";
const UIDeviceTypeName UIDeviceTypeNameiPhone13ProMax = @"iPhone 13 Pro Max";

@implementation UIDevice (UnitType)

- (UIDeviceTypeName)deviceTypeName {
    static dispatch_once_t onceToken;
    static UIDeviceTypeName deviceName;
    dispatch_once(&onceToken, ^{
        deviceName = [self internalDeviceTypeName];
    });
    return deviceName;
}

- (UIDeviceTypeName)internalDeviceTypeName {
    UIDeviceTypeName name = nil;
#if TARGET_IPHONE_SIMULATOR
    name = [self simulatorDeviceName];
#else
    name = [self iPhoneDeviceName];
#endif
    return name.length > 0 ? name : UIDeviceTypeNameUnkown;
}

- (NSString *)simulatorDeviceName {
    NSString *name = [NSProcessInfo processInfo].environment[@"SIMULATOR_DEVICE_NAME"];
    if ([name isEqualToString:@"iPhone SE (1st generation)"]) {
        return UIDeviceTypeNameiPhoneSE;
    } else if ([name isEqualToString:@"iPhone SE (2nd generation)"]) {
        return UIDeviceTypeNameiPhoneSE2;
    } else {
        return name;
    }
}

- (NSString *)iPhoneDeviceName {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //iPhone
    if ([platform isEqualToString:@"iPhone1,1"]) return UIDeviceTypeNameiPhone1G;
    if ([platform isEqualToString:@"iPhone1,2"]) return UIDeviceTypeNameiPhone3G;
    if ([platform isEqualToString:@"iPhone2,1"]) return UIDeviceTypeNameiPhone3GS;
    if ([platform isEqualToString:@"iPhone3,1"]) return UIDeviceTypeNameiPhone4;
    if ([platform isEqualToString:@"iPhone3,2"]) return UIDeviceTypeNameiPhone4;
    if ([platform isEqualToString:@"iPhone4,1"]) return UIDeviceTypeNameiPhone4s;
    if ([platform isEqualToString:@"iPhone5,1"]) return UIDeviceTypeNameiPhone5;
    if ([platform isEqualToString:@"iPhone5,2"]) return UIDeviceTypeNameiPhone5;
    if ([platform isEqualToString:@"iPhone5,3"]) return UIDeviceTypeNameiPhone5c;
    if ([platform isEqualToString:@"iPhone5,4"]) return UIDeviceTypeNameiPhone5c;
    if ([platform isEqualToString:@"iPhone6,1"]) return UIDeviceTypeNameiPhone5s;
    if ([platform isEqualToString:@"iPhone6,2"]) return UIDeviceTypeNameiPhone5s;
    if ([platform isEqualToString:@"iPhone7,1"]) return UIDeviceTypeNameiPhone6Plus;
    if ([platform isEqualToString:@"iPhone7,2"]) return UIDeviceTypeNameiPhone6;
    if ([platform isEqualToString:@"iPhone8,1"]) return UIDeviceTypeNameiPhone6s;
    if ([platform isEqualToString:@"iPhone8,2"]) return UIDeviceTypeNameiPhone6sPlus;
    if ([platform isEqualToString:@"iPhone8,4"]) return UIDeviceTypeNameiPhoneSE;
    if ([platform isEqualToString:@"iPhone9,1"]) return UIDeviceTypeNameiPhone7;
    if ([platform isEqualToString:@"iPhone9,3"]) return UIDeviceTypeNameiPhone7;
    if ([platform isEqualToString:@"iPhone9,2"]) return UIDeviceTypeNameiPhone7Plus;
    if ([platform isEqualToString:@"iPhone9,4"]) return UIDeviceTypeNameiPhone7Plus;
    if ([platform isEqualToString:@"iPhone10,1"]) return UIDeviceTypeNameiPhone8;
    if ([platform isEqualToString:@"iPhone10,4"]) return UIDeviceTypeNameiPhone8;
    if ([platform isEqualToString:@"iPhone10,2"]) return UIDeviceTypeNameiPhone8Plus;
    if ([platform isEqualToString:@"iPhone10,5"]) return UIDeviceTypeNameiPhone8Plus;
    if ([platform isEqualToString:@"iPhone10,3"]) return UIDeviceTypeNameiPhoneX;
    if ([platform isEqualToString:@"iPhone10,6"]) return UIDeviceTypeNameiPhoneX;
    if ([platform isEqualToString:@"iPhone11,8"]) return UIDeviceTypeNameiPhoneXR;
    if ([platform isEqualToString:@"iPhone11,2"]) return UIDeviceTypeNameiPhoneXS;
    if ([platform isEqualToString:@"iPhone11,4"]) return UIDeviceTypeNameiPhoneXSMax;
    if ([platform isEqualToString:@"iPhone11,6"]) return UIDeviceTypeNameiPhoneXSMax;
    if ([platform isEqualToString:@"iPhone12,1"]) return UIDeviceTypeNameiPhone11;
    if ([platform isEqualToString:@"iPhone12,3"]) return UIDeviceTypeNameiPhone11Pro;
    if ([platform isEqualToString:@"iPhone12,5"]) return UIDeviceTypeNameiPhone11ProMax;
    if ([platform isEqualToString:@"iPhone12,8"]) return UIDeviceTypeNameiPhoneSE2;
    if ([platform isEqualToString:@"iPhone13,1"]) return UIDeviceTypeNameiPhone12Mini;
    if ([platform isEqualToString:@"iPhone13,2"]) return UIDeviceTypeNameiPhone12;
    if ([platform isEqualToString:@"iPhone13,3"]) return UIDeviceTypeNameiPhone12Pro;
    if ([platform isEqualToString:@"iPhone13,4"]) return UIDeviceTypeNameiPhone12ProMax;
    
    return platform;
}

@end
