//
//  UIDevice+UnitType.h
//  iOSStudy
//
//  Created by Knox on 2022/3/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString *UIDeviceTypeName NS_STRING_ENUM;

FOUNDATION_EXPORT const UIDeviceTypeName UIDeviceTypeNameUnkown;

FOUNDATION_EXPORT const UIDeviceTypeName UIDeviceTypeNameiPhone1G;
FOUNDATION_EXPORT const UIDeviceTypeName UIDeviceTypeNameiPhone3G;
FOUNDATION_EXPORT const UIDeviceTypeName UIDeviceTypeNameiPhone3GS;

// 2010
FOUNDATION_EXPORT const UIDeviceTypeName UIDeviceTypeNameiPhone4;

// 2011
FOUNDATION_EXPORT const UIDeviceTypeName UIDeviceTypeNameiPhone4s;

// 2012
FOUNDATION_EXPORT const UIDeviceTypeName UIDeviceTypeNameiPhone5;

// 2013
FOUNDATION_EXPORT const UIDeviceTypeName UIDeviceTypeNameiPhone5s;
FOUNDATION_EXPORT const UIDeviceTypeName UIDeviceTypeNameiPhone5c;

// 2014
FOUNDATION_EXPORT const UIDeviceTypeName UIDeviceTypeNameiPhone6;
FOUNDATION_EXPORT const UIDeviceTypeName UIDeviceTypeNameiPhone6Plus;

// 2015
FOUNDATION_EXPORT const UIDeviceTypeName UIDeviceTypeNameiPhone6s;
FOUNDATION_EXPORT const UIDeviceTypeName UIDeviceTypeNameiPhone6sPlus;

// 2016
FOUNDATION_EXPORT const UIDeviceTypeName UIDeviceTypeNameiPhoneSE;
FOUNDATION_EXPORT const UIDeviceTypeName UIDeviceTypeNameiPhone7;
FOUNDATION_EXPORT const UIDeviceTypeName UIDeviceTypeNameiPhone7Plus;

// 2017
FOUNDATION_EXPORT const UIDeviceTypeName UIDeviceTypeNameiPhone8;
FOUNDATION_EXPORT const UIDeviceTypeName UIDeviceTypeNameiPhone8Plus;

// 2018
FOUNDATION_EXPORT const UIDeviceTypeName UIDeviceTypeNameiPhoneX;
FOUNDATION_EXPORT const UIDeviceTypeName UIDeviceTypeNameiPhoneXS;
FOUNDATION_EXPORT const UIDeviceTypeName UIDeviceTypeNameiPhoneXSMax;
FOUNDATION_EXPORT const UIDeviceTypeName UIDeviceTypeNameiPhoneXR;

// 2019
FOUNDATION_EXPORT const UIDeviceTypeName UIDeviceTypeNameiPhone11;
FOUNDATION_EXPORT const UIDeviceTypeName UIDeviceTypeNameiPhone11Pro;
FOUNDATION_EXPORT const UIDeviceTypeName UIDeviceTypeNameiPhone11ProMax;

// 2020
FOUNDATION_EXPORT const UIDeviceTypeName UIDeviceTypeNameiPhoneSE2;
FOUNDATION_EXPORT const UIDeviceTypeName UIDeviceTypeNameiPhone12;
FOUNDATION_EXPORT const UIDeviceTypeName UIDeviceTypeNameiPhone12Mini;
FOUNDATION_EXPORT const UIDeviceTypeName UIDeviceTypeNameiPhone12Pro;
FOUNDATION_EXPORT const UIDeviceTypeName UIDeviceTypeNameiPhone12ProMax;

// 2021
FOUNDATION_EXPORT const UIDeviceTypeName UIDeviceTypeNameiPhone13;
FOUNDATION_EXPORT const UIDeviceTypeName UIDeviceTypeNameiPhone13Mini;
FOUNDATION_EXPORT const UIDeviceTypeName UIDeviceTypeNameiPhone13Pro;
FOUNDATION_EXPORT const UIDeviceTypeName UIDeviceTypeNameiPhone13ProMax;



@interface UIDevice (UnitType)

@property (nonatomic, copy, readonly) UIDeviceTypeName deviceTypeName;

@end

NS_ASSUME_NONNULL_END
