//
//  HTTPMetricsManager.h
//  iOSStudy
//
//  Created by Knox on 2021/11/27.
//

#import <Foundation/Foundation.h>
#import "HMHTTPTransactionMetrics.h"

NS_ASSUME_NONNULL_BEGIN

@class HTTPMetricsManager;

@protocol HTTPMetricsManagerDelegate <NSObject>

@optional
- (void)metricsManager:(HTTPMetricsManager *)manager didCollectedMetrics:(HMHTTPTransactionMetrics *)metrics;

@end


@interface HTTPMetricsManager : NSObject

+ (instancetype)sharedMetrics;

- (void)addObserver:(id<HTTPMetricsManagerDelegate>)observer;

- (void)removeObserver:(id<HTTPMetricsManagerDelegate>)observer;

@end

NS_ASSUME_NONNULL_END
