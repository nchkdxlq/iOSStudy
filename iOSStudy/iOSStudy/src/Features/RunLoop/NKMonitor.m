//
//  NKMonitor.m
//  iOSStudy
//
//  Created by Knox on 2021/9/8.
//

#import "NKMonitor.h"

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

@property (nonatomic, assign) CFRunLoopObserverRef lowestPriorityObserver;
@property (nonatomic, strong) dispatch_semaphore_t lowestPrioritySemaphore;
@property (nonatomic, assign) CFRunLoopActivity lowestPriorityRunLoopActivity;
@property (nonatomic, assign) NSInteger lowestPriorityTimeoutCount;

@property (nonatomic, assign) BOOL running;

@end



static void hightestPriorityObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info){
    NKMonitor *lagMonitor = (__bridge NKMonitor*)info;
    lagMonitor.hightestPriorityRunLoopActivity = activity;
//     NSLog(@"hightestPriorityObserverCallBack %@", activityText(activity));
    dispatch_semaphore_t semaphore = lagMonitor.hightestPrioritySemaphore;
    dispatch_semaphore_signal(semaphore);
}


static void lowestPriorityObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info){
    NKMonitor *lagMonitor = (__bridge NKMonitor*)info;
    lagMonitor.lowestPriorityRunLoopActivity = activity;
//     NSLog(@"lowestPriorityObserverCallBack %@", activityText(activity));
    dispatch_semaphore_t semaphore = lagMonitor.lowestPrioritySemaphore;
    dispatch_semaphore_signal(semaphore);
}

@implementation NKMonitor


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
    CFRunLoopObserverContext context = {0, (__bridge void*)self, NULL, NULL};
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
            CFRunLoopActivity activity = self.hightestPriorityRunLoopActivity;
            if (semaphoreWait != 0) {
                switch (activity) {
                    case kCFRunLoopAfterWaiting:
                    case kCFRunLoopBeforeTimers:
                    case kCFRunLoopBeforeSources: {
                        if (++self.hightestPriorityTimeoutCount < 3) {
                            // 小卡顿
                        } else {
                            // 大卡顿
                        }
                        NSLog(@"hightestPriority 监测到卡顿 Activity = %@", activityText(activity));
                    }
                        break;
                        
                    default:
                        break;
                }
            } else {
                self.hightestPriorityTimeoutCount = 0;
            }
        }
    });
    
    dispatch_async(queue, ^{
        while (self.running) {
            dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, interval * NSEC_PER_MSEC);
            long semaphoreWait = dispatch_semaphore_wait(self.lowestPrioritySemaphore, time);
            if (semaphoreWait != 0) {
                // 增加self.hightestPriorityRunLoopActivity == kCFRunLoopBeforeWaiting 为了不与hightestPriority监测重复
                if (self.lowestPriorityRunLoopActivity == kCFRunLoopBeforeSources
                    && self.hightestPriorityRunLoopActivity == kCFRunLoopBeforeWaiting) {
                    if (++self.lowestPriorityTimeoutCount < 3) {
                        // 小卡顿
                    } else {
                        // 大卡顿
                    }
                    NSLog(@"lowestPriority 监测到卡顿 Activity = %@", activityText(kCFRunLoopBeforeSources));
                }
            } else {
                self.lowestPriorityTimeoutCount = 0;
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


