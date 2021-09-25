//
//  NSObject+GCD.m
//  iOSStudy
//
//  Created by Knox on 2021/9/2.
//

#import "NSObject+GCD.h"

@implementation NSObject (GCD)

- (void)dispatchSafeMainThreadWithBlock:(dispatch_block_t)block {
    if (block == NULL) return;
    if ([NSThread isMainThread]) {
        dispatch_sync(dispatch_get_main_queue(), block);
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

- (void)dispatchMainQueueAfterInterval:(NSTimeInterval)interval block:(dispatch_block_t)block {
    if (block == NULL) return;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
}


@end
