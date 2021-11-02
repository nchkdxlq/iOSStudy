//
//  NKRunLoopActivityMonitor.h
//  iOSStudy
//
//  Created by Knox on 2021/10/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NKRunLoopActivityMonitor : NSObject

@property (nonatomic, assign, readonly, class) CFRunLoopActivity activity;

@property (nonatomic, copy, readonly, class) NSString *activityText;

+ (void)startMonitor;

@end

NS_ASSUME_NONNULL_END
