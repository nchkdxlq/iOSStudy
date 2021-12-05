//
//  NSURLSessionDelegateProxy.m
//  iOSStudy
//
//  Created by Knox on 2021/12/5.
//

#import "NSURLSessionDelegateProxy.h"
#import "HTTPMetricsManager+Private.h"

@interface NSURLSessionDelegateProxy () <NSURLSessionTaskDelegate>

@end


@implementation NSURLSessionDelegateProxy

- (instancetype)initWithTarget:(id<NSURLSessionDelegate>)target {
    _target = target;
    return self;
}

+ (instancetype)proxyWithTarget:(id<NSURLSessionDelegate>)target {
    return [[NSURLSessionDelegateProxy alloc] initWithTarget:target];
}

- (id)forwardingTargetForSelector:(SEL)selector {
    return _target;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    void *null = NULL;
    [invocation setReturnValue:&null];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    return [NSObject instanceMethodSignatureForSelector:@selector(init)];
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    return [_target respondsToSelector:aSelector];
}

- (BOOL)conformsToProtocol:(Protocol *)aProtocol {
    return [_target conformsToProtocol:aProtocol];
}

- (BOOL)isEqual:(id)object {
    return [_target isEqual:object];
}

- (NSUInteger)hash {
    return [_target hash];
}

- (Class)class {
    return [_target class];
}

- (Class)superclass {
    return [_target superclass];
}

- (BOOL)isKindOfClass:(Class)aClass {
    return [_target isKindOfClass:aClass];
}

- (BOOL)isMemberOfClass:(Class)aClass {
    return [_target isMemberOfClass:aClass];
}

- (BOOL)isProxy {
    return YES;
}

- (NSString *)description {
    return [_target description];
}

- (NSString *)debugDescription {
    return [_target debugDescription];
}

#pragma mark - NSURLSessionTaskDelegate

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didFinishCollectingMetrics:(NSURLSessionTaskMetrics *)metrics {
    if ([_target respondsToSelector:@selector(URLSession:task:didFinishCollectingMetrics:)]) {
        [(id<NSURLSessionTaskDelegate>)_target URLSession:session task:task didFinishCollectingMetrics:metrics];
    }
    
    [HTTPMetricsManager.sharedMetrics didFinishCollectingMetrics:metrics];
}

@end
