//
//  HTTPMetricsManager+Private.h
//  iOSStudy
//
//  Created by Knox on 2021/12/5.
//

#import "HTTPMetricsManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTTPMetricsManager (Private)

- (void)didFinishCollectingMetrics:(NSURLSessionTaskMetrics *)metrics;

@end

NS_ASSUME_NONNULL_END
