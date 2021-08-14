//
//  NKWeakProxy.m
//  iOSStudy
//
//  Created by Knox on 2021/6/5.
//

#import "NKWeakProxy.h"

@interface NKWeakProxy()

@property (nonatomic, weak) id target;

@end


@implementation NKWeakProxy

+ (instancetype)proxyWithTarget:(id)target {
    NKWeakProxy *ins = [NKWeakProxy alloc];
    ins.target = target;
    return ins;
}


- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    NSLog(@"%s", __func__);
    return [self.target methodSignatureForSelector:sel];
}


- (void)forwardInvocation:(NSInvocation *)invocation {
    NSLog(@"%s", __func__);
    [invocation invokeWithTarget:self.target];
}


@end
