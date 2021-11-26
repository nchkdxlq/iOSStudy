//
//  NetworkMetrics.h
//  iOSStudy
//
//  Created by Knox on 2021/11/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetworkMetrics : NSObject

+ (instancetype)sharedMetrics;

- (void)collectSessionTaskMetrics:(NSURLSessionTaskMetrics *)metrics;

@end

NS_ASSUME_NONNULL_END
