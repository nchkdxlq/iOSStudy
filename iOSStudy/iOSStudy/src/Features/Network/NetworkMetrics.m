//
//  NetworkMetrics.m
//  iOSStudy
//
//  Created by Knox on 2021/11/26.
//

#import "NetworkMetrics.h"
#import "NSURLSessionTaskTransactionMetrics+Formatter.h"

@implementation NetworkMetrics

+ (instancetype)sharedMetrics {
    static NetworkMetrics *metrics;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        metrics = [NetworkMetrics new];
    });
    return metrics;
}


- (void)collectSessionTaskMetrics:(NSURLSessionTaskMetrics *)metrics {
    for (NSURLSessionTaskTransactionMetrics *transactionMetrics in metrics.transactionMetrics) {
        NSLog(@"%@", [transactionMetrics metricsDescription]);
    }
}


@end
