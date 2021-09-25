//
//  NSObject+GCD.h
//  iOSStudy
//
//  Created by Knox on 2021/9/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (GCD)

- (void)dispatchSafeMainThreadWithBlock:(dispatch_block_t)block;

- (void)dispatchMainQueueAfterInterval:(NSTimeInterval)interval block:(dispatch_block_t)block;

@end

NS_ASSUME_NONNULL_END
