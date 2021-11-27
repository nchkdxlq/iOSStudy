//
//  HTTPMetricsManager.m
//  iOSStudy
//
//  Created by Knox on 2021/11/27.
//

#import "HTTPMetricsManager.h"
#import "HMHTTPTransactionMetrics.h"

@implementation HTTPMetricsManager


+ (void)didFinishCollectingMetrics:(NSURLSessionTaskMetrics *)metrics {
    for (NSURLSessionTaskTransactionMetrics *transactionMetrics in metrics.transactionMetrics) {
        HMHTTPTransactionMetrics *model = [HMHTTPTransactionMetrics metricsWithTaskTransactionMetrics:transactionMetrics];
        NSLog(@"%@", model);
    }
}

@end
