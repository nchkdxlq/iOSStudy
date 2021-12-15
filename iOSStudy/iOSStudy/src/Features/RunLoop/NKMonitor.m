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

@property (nonatomic, assign) CFRunLoopObserverRef firstOrderObserver;
@property (nonatomic, strong) dispatch_semaphore_t firstOrderSemaphore;
@property (nonatomic, assign) CFRunLoopActivity firstOrderRunLoopActivity;
@property (nonatomic, assign) NSInteger firstOrderTimeoutCount;

@property (nonatomic, assign) CFRunLoopObserverRef lastOrderObserver;
@property (nonatomic, strong) dispatch_semaphore_t lastOrderSemaphore;
@property (nonatomic, assign) CFRunLoopActivity lastOrderRunLoopActivity;
@property (nonatomic, assign) NSInteger lastOrderTimeoutCount;

@property (nonatomic, assign) BOOL running;

@end



static void firstOrderObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info){
    NKMonitor *lagMonitor = (__bridge NKMonitor*)info;
    lagMonitor.firstOrderRunLoopActivity = activity;
//     NSLog(@"firstOrderObserverCallBack %@", activityText(activity));
    dispatch_semaphore_t semaphore = lagMonitor.firstOrderSemaphore;
    dispatch_semaphore_signal(semaphore);
}


static void lastOrderObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info){
    NKMonitor *lagMonitor = (__bridge NKMonitor*)info;
    lagMonitor.lastOrderRunLoopActivity = activity;
//     NSLog(@"lastOrderObserverCallBack %@", activityText(activity));
    dispatch_semaphore_t semaphore = lagMonitor.lastOrderSemaphore;
    dispatch_semaphore_signal(semaphore);
}

@implementation NKMonitor


- (instancetype)init {
    self = [super init];
    if (self) {
        self.firstOrderSemaphore = dispatch_semaphore_create(0);
        self.lastOrderSemaphore = dispatch_semaphore_create(0);
        [self addRunLoopObserver];
    }
    return self;
}

- (void)addRunLoopObserver {
    CFRunLoopObserverContext context = {0, (__bridge void*)self, NULL, NULL};
    CFRunLoopObserverRef firstOrderObserver = CFRunLoopObserverCreate(kCFAllocatorDefault,
                                                                      kCFRunLoopAllActivities,
                                                                      YES,
                                                                      INT_MIN,
                                                                      &firstOrderObserverCallBack,
                                                                      &context);
     CFRunLoopAddObserver(CFRunLoopGetMain(), firstOrderObserver, kCFRunLoopCommonModes);
     self.firstOrderObserver = firstOrderObserver;
    
    
    CFRunLoopObserverRef lastOrderObserver = CFRunLoopObserverCreate(kCFAllocatorDefault,
                                                                     kCFRunLoopAllActivities,
                                                                     YES,
                                                                     INT_MAX,
                                                                     &lastOrderObserverCallBack,
                                                                     &context);
     CFRunLoopAddObserver(CFRunLoopGetMain(), lastOrderObserver, kCFRunLoopCommonModes);
     self.lastOrderObserver = lastOrderObserver;
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
            long semaphoreWait = dispatch_semaphore_wait(self.firstOrderSemaphore, time);
            if (semaphoreWait != 0) {
                switch (self.firstOrderRunLoopActivity) {
                    case kCFRunLoopAfterWaiting:
                    case kCFRunLoopBeforeTimers:
                    case kCFRunLoopBeforeSources: {
                        NSLog(@"firstOrder 监测到卡顿 Activity = %@", activityText(self.firstOrderRunLoopActivity));
                    }
                        break;
                        
                    default:
                        break;
                }
            }
            self.firstOrderTimeoutCount = 0;
        }
    });
    
    dispatch_async(queue, ^{
        while (self.running) {
            dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, interval * NSEC_PER_MSEC);
            long semaphoreWait = dispatch_semaphore_wait(self.lastOrderSemaphore, time);
            if (semaphoreWait != 0) {
                // 增加self.firstOrderRunLoopActivity == kCFRunLoopBeforeWaiting 为了不与firstOrder监测重复
                if (self.lastOrderRunLoopActivity == kCFRunLoopBeforeSources
                    && self.firstOrderRunLoopActivity == kCFRunLoopBeforeWaiting) {
                    NSLog(@"lastOrder 监测到卡顿 Activity = %@", activityText(kCFRunLoopBeforeSources));
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


