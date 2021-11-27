//
//  UIDeviceMetrics.h
//  iOSStudy
//
//  Created by Knox on 2021/11/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDeviceMetrics : NSObject

/// 应用当前CPU的使用率
+ (float)appCpuUsage;

/// 设备当前CPU的使用率
+ (float)cpuUsage;

/// 设备CPU核数
+ (NSUInteger)cpuCount;

/// 当前设备物理内存
- (unsigned long long)physicalMemory;

/// App当前使用内存
+ (unsigned long long)appUsedMemory;

@end

NS_ASSUME_NONNULL_END
