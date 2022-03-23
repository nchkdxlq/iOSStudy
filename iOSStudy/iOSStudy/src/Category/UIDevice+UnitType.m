//
//  UIDevice+UnitType.m
//  iOSStudy
//
//  Created by Knox on 2022/3/22.
//

#import "UIDevice+UnitType.h"


const UIDeviceTypeName UIDeviceTypeNameUnkown = @"Unkown";

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
    return [NSProcessInfo processInfo].environment[@"SIMULATOR_DEVICE_NAME"];
}

- (NSString *)iPhoneDeviceName {
    return nil;
}

@end
