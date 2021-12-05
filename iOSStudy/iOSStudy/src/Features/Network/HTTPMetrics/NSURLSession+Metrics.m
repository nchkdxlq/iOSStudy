//
//  NSURLSession+Metrics.m
//  iOSStudy
//
//  Created by Knox on 2021/12/5.
//

#import "NSURLSession+Metrics.h"
#import <objc/message.h>
#import "NSURLSessionDelegateProxy.h"


@implementation NSURLSession (Metrics)

+ (void)load {
    Method originMethod = class_getClassMethod(self, @selector(sessionWithConfiguration:delegate:delegateQueue:));
    Method newMethod = class_getClassMethod(self, @selector(metrics_sessionWithConfiguration:delegate:delegateQueue:));
    method_exchangeImplementations(originMethod, newMethod);
}


+ (NSURLSession *)metrics_sessionWithConfiguration:(NSURLSessionConfiguration *)configuration
                                          delegate:(id<NSURLSessionDelegate>)delegate
                                     delegateQueue:(NSOperationQueue *)queue {
    id<NSURLSessionDelegate> delegateProxy = [NSURLSessionDelegateProxy proxyWithTarget:delegate];
    return [self metrics_sessionWithConfiguration:configuration delegate:delegateProxy delegateQueue:queue];
}

@end
