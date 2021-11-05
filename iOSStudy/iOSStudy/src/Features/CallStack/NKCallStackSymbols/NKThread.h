//
//  NKThread.h
//  iOSStudy
//
//  Created by Knox on 2021/11/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class NKStackFrame;

@interface NKThread : NSObject

@property (nonatomic, assign, readonly) thread_t thread;

@property (nonatomic, assign, readonly) NSArray<NKStackFrame *> *callStackFrame;

+ (instancetype)threadWithThread:(thread_t)thread;

@end

NS_ASSUME_NONNULL_END
