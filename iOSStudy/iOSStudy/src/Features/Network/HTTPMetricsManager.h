//
//  HTTPMetricsManager.h
//  iOSStudy
//
//  Created by Knox on 2021/11/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HTTPMetricsManager : NSObject

+ (void)didFinishCollectingMetrics:(NSURLSessionTaskMetrics *)metrics;

@end

NS_ASSUME_NONNULL_END
