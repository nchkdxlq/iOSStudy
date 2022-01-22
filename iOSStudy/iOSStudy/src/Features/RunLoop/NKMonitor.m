//
//  NKMonitor.m
//  iOSStudy
//
//  Created by Knox on 2021/9/8.
//

#import "NKMonitor.h"
#import <mach/mach.h>

#if defined(__arm64__)
#include <mach/arm/thread_state.h>
#elif defined(__x86_64__)
#include <mach/i386/thread_state.h>
#endif


static thread_t g_main_thread;

typedef struct {
    __uint64_t lr; // LinkRegister
    __uint64_t fp; // FramePoint
} NKStackFrame;

// 获取主线程当前函数的 栈帧指针fp、返回地址lr
static inline BOOL fillTopStackFrame(NKStackFrame *frame) {
    mach_msg_type_number_t state_count;
    kern_return_t kr;
#if defined(__arm64__)
    state_count = ARM_UNIFIED_THREAD_STATE_COUNT;
    arm_unified_thread_state_t arm_thread_state;
    kr = thread_get_state(g_main_thread, ARM_UNIFIED_THREAD_STATE, (thread_state_t)&arm_thread_state, &state_count);
    frame->lr = arm_thread_state.ts_64.__lr;
    frame->fp = arm_thread_state.ts_64.__fp;
#elif defined(__x86_64__)
    state_count = x86_THREAD_STATE_COUNT;
    x86_thread_state_t x86_thread_state;
    kr = thread_get_state(g_main_thread, x86_THREAD_STATE, (thread_state_t)&x86_thread_state, &state_count);
    frame->lr = x86_thread_state.uts.ts64.__rax;
    frame->fp = x86_thread_state.uts.ts64.__rbx;
#endif
    return kr != KERN_SUCCESS;
}

static inline BOOL NKStackFrameEqualToFrame(NKStackFrame frame1, NKStackFrame frame2) {
    return frame1.fp == frame2.fp && frame1.lr == frame2.lr;
}

NSString* activityText(CFRunLoopActivity activity) {
    switch (activity) {
        case kCFRunLoopEntry:
            return @"kCFRunLoopEntry";
        case kCFRunLoopBeforeTimers:
            return @"kCFRunLoopBeforeTimers";
        case kCFRunLoopBeforeSources:
            return @"kCFRunLoopBeforeSources";
        case kCFRunLoopBeforeWaiting:
            return @"kCFRunLoopBeforeWaiting";
        case kCFRunLoopAfterWaiting:
            return @"kCFRunLoopAfterWaiting";
        case kCFRunLoopExit:
            return @"kCFRunLoopExit";
        default:
            return @"kCFRunLoopUnknow";
    }
}



@interface NKMonitor ()

@property (nonatomic, assign) CFRunLoopObserverRef hightestPriorityObserver;
@property (nonatomic, strong) dispatch_semaphore_t hightestPrioritySemaphore;
@property (nonatomic, assign) CFRunLoopActivity hightestPriorityRunLoopActivity;
@property (nonatomic, assign) NSInteger hightestPriorityTimeoutCount;

@property (nonatomic, assign) NSUInteger loopCount;

@property (nonatomic, assign) CFRunLoopObserverRef lowestPriorityObserver;
@property (nonatomic, strong) dispatch_semaphore_t lowestPrioritySemaphore;
@property (nonatomic, assign) CFRunLoopActivity lowestPriorityRunLoopActivity;
@property (nonatomic, assign) NSInteger lowestPriorityTimeoutCount;

@property (nonatomic, assign) NKStackFrame stackFrame;

@property (nonatomic, assign) BOOL running;

@end



static void hightestPriorityObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    NKMonitor *monitor = (__bridge NKMonitor *)info;
    monitor.hightestPriorityRunLoopActivity = activity;
    monitor.loopCount++;
    if (monitor.running) {
        dispatch_semaphore_t semaphore = monitor.hightestPrioritySemaphore;
        dispatch_semaphore_signal(semaphore);
    }
}


static void lowestPriorityObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    NKMonitor *monitor = (__bridge NKMonitor *)info;
    monitor.lowestPriorityRunLoopActivity = activity;
    if (monitor.running) {
        dispatch_semaphore_t semaphore = monitor.lowestPrioritySemaphore;
        dispatch_semaphore_signal(semaphore);
    }
}

@implementation NKMonitor


+ (void)load {
    g_main_thread = mach_thread_self();
}


- (instancetype)init {
    self = [super init];
    if (self) {
        self.hightestPrioritySemaphore = dispatch_semaphore_create(0);
        self.lowestPrioritySemaphore = dispatch_semaphore_create(0);
        [self addRunLoopObserver];
    }
    return self;
}

- (void)addRunLoopObserver {
    CFRunLoopObserverContext context = {0, (__bridge void *)self, NULL, NULL};
    CFRunLoopObserverRef hightestPriorityObserver = CFRunLoopObserverCreate(kCFAllocatorDefault,
                                                                            kCFRunLoopAllActivities,
                                                                            YES,
                                                                            INT_MIN,
                                                                            &hightestPriorityObserverCallBack,
                                                                            &context);
     CFRunLoopAddObserver(CFRunLoopGetMain(), hightestPriorityObserver, kCFRunLoopCommonModes);
     self.hightestPriorityObserver = hightestPriorityObserver;
    
    
    CFRunLoopObserverRef lowestPriorityObserver = CFRunLoopObserverCreate(kCFAllocatorDefault,
                                                                          kCFRunLoopAllActivities,
                                                                          YES,
                                                                          INT_MAX,
                                                                          &lowestPriorityObserverCallBack,
                                                                          &context);
     CFRunLoopAddObserver(CFRunLoopGetMain(), lowestPriorityObserver, kCFRunLoopCommonModes);
     self.lowestPriorityObserver = lowestPriorityObserver;
}

- (void)beginMonitor {
    if (self.running) return;
    self.running = YES;
    NSTimeInterval interval = 80; // ms
   //创建子线程监控
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        while (self.running) {
            dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, interval * NSEC_PER_MSEC);
            long semaphoreWait = dispatch_semaphore_wait(self.hightestPrioritySemaphore, time);
            if (semaphoreWait == 0) {
                self.hightestPriorityTimeoutCount = 0;
            } else {
                CFRunLoopActivity activity = self.hightestPriorityRunLoopActivity;
                switch (activity) {
                    case kCFRunLoopAfterWaiting:
                    case kCFRunLoopBeforeSources: {
                        // 避免误判, 只有在一个方法里面的耗时超过设定的阈值就算是卡顿
                        NKStackFrame curStackFrame;
                        BOOL success = fillTopStackFrame(&curStackFrame);
                        if (success == NO) continue;
                        if (NKStackFrameEqualToFrame(curStackFrame, self.stackFrame)) {
                            self.hightestPriorityTimeoutCount++;
                            if (self.hightestPriorityTimeoutCount < 3) {
                                // 小卡顿
                            } else {
                                // 大卡顿
                            }
                            NSLog(@"hightestPriority 监测到卡顿 Activity = %@", activityText(activity));
                        } else {
                            self.hightestPriorityTimeoutCount = 0;
                        }
                        self.stackFrame = curStackFrame;
                    }
                        break;
                        
                    default:
                        break;
                }
            }
        }
    });
    
    dispatch_async(queue, ^{
        while (self.running) {
            dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, interval * NSEC_PER_MSEC);
            long semaphoreWait = dispatch_semaphore_wait(self.lowestPrioritySemaphore, time);
            if (semaphoreWait == 0) {
                self.lowestPriorityTimeoutCount = 0;
            } else {
                // 增加self.hightestPriorityRunLoopActivity == kCFRunLoopBeforeWaiting 为了不与hightestPriority监测重复
                if (self.lowestPriorityRunLoopActivity == kCFRunLoopBeforeSources
                    && self.hightestPriorityRunLoopActivity == kCFRunLoopBeforeWaiting) {
                    
                    NKStackFrame curStackFrame;
                    BOOL success = fillTopStackFrame(&curStackFrame);
                    if (success == NO) continue;
                    
                    if (NKStackFrameEqualToFrame(curStackFrame, self.stackFrame)) {
                        self.lowestPriorityTimeoutCount++;
                        if (self.lowestPriorityTimeoutCount < 3) {
                            // 小卡顿
                        } else {
                            // 大卡顿
                        }
                        NSLog(@"lowestPriority 监测到卡顿 Activity = %@", activityText(kCFRunLoopBeforeSources));
                    } else {
                        self.lowestPriorityTimeoutCount = 0;
                    }
                    self.stackFrame = curStackFrame;
                }
            }
        }
    });
}

- (void)endMonitor {
    self.running = NO;
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

@end


