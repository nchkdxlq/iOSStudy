//
//  HTTPMetricsManager.m
//  iOSStudy
//
//  Created by Knox on 2021/11/27.
//

#import "HTTPMetricsManager.h"
#import "HMHTTPTransactionMetrics.h"


@interface HTTPMetricsManager ()

@property (nonatomic, strong) NSMutableArray<id<HTTPMetricsManagerDelegate>> *observers;

@end

@implementation HTTPMetricsManager


- (void)didFinishCollectingMetrics:(NSURLSessionTaskMetrics *)metrics {
    NSArray<id<HTTPMetricsManagerDelegate>> *observers = self.observers.copy;
    for (NSURLSessionTaskTransactionMetrics *transactionMetrics in metrics.transactionMetrics) {
        if (transactionMetrics.resourceFetchType == NSURLSessionTaskMetricsResourceFetchTypeLocalCache
            || transactionMetrics.resourceFetchType == NSURLSessionTaskMetricsResourceFetchTypeUnknown) {
            continue;
        }
        
        HMHTTPTransactionMetrics *model = [HMHTTPTransactionMetrics metricsWithTaskTransactionMetrics:transactionMetrics];
        for (id<HTTPMetricsManagerDelegate> obs in observers) {
            if ([obs respondsToSelector:@selector(metricsManager:didCollectedMetrics:)]) {
                [obs metricsManager:self didCollectedMetrics:model];
            }
        }
    }
}


+ (instancetype)sharedMetrics {
    static HTTPMetricsManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [HTTPMetricsManager new];
    });
    return instance;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        _observers = [NSMutableArray new];
    }
    return self;
}

- (void)addObserver:(id<HTTPMetricsManagerDelegate>)observer {
    if (observer == nil || [self.observers containsObject:observer]) return;
    [self.observers addObject:observer];
}

- (void)removeObserver:(id<HTTPMetricsManagerDelegate>)observer {
    if (observer == nil) return;
    [self.observers removeObject:observer];
}


@end
