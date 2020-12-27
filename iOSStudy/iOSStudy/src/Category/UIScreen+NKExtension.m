//
//  UIScreen+NKExtension.m
//  iOSStudy
//
//  Created by Knox on 2020/12/26.
//  Copyright © 2020 Knox. All rights reserved.
//

#import "UIScreen+NKExtension.h"

@implementation UIScreen (NKExtension)

+ (CGFloat)width {
    return [UIScreen mainScreen].bounds.size.width;
}

+ (CGFloat)height {
    return [UIScreen mainScreen].bounds.size.height;
}

@end
