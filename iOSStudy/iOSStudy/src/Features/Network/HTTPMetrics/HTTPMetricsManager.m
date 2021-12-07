//
//  HTTPMetricsManager.m
//  iOSStudy
//
//  Created by Knox on 2021/11/27.
//

#import "HTTPMetricsManager.h"
#import "HMHTTPTransactionMetrics.h"


@interface HTTPMetricsManager ()

@property (nonatomic, strong) NSOperationQueue *metricsQueue;

@property (nonatomic, strong) NSMutableArray<id<HTTPMetricsManagerDelegate>> *observers;

@property (nonatomic, strong) dispatch_semaphore_t semaphore;

@end

@implementation HTTPMetricsManager


- (void)didFinishCollectingMetrics:(NSURLSessionTaskMetrics *)metrics {
    [self.metricsQueue addOperationWithBlock:^{
        [self internal_didFinishCollectingMetrics:metrics];
    }];
}

- (void)internal_didFinishCollectingMetrics:(NSURLSessionTaskMetrics *)metrics {
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
        _semaphore = dispatch_semaphore_create(1);
        
        _metricsQueue = [NSOperationQueue new];
        _metricsQueue.maxConcurrentOperationCount = 1;
        _metricsQueue.name = @"HMURLSessionTaskMetricsQueue";
    }
    return self;
}

- (void)addObserver:(id<HTTPMetricsManagerDelegate>)observer {
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    if (observer != nil && ![self.observers containsObject:observer]) {
        [self.observers addObject:observer];
    }
    dispatch_semaphore_signal(self.semaphore);
}

- (void)removeObserver:(id<HTTPMetricsManagerDelegate>)observer {
    if (observer == nil) return;
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    [self.observers removeObject:observer];
    dispatch_semaphore_signal(self.semaphore);
}


@end
