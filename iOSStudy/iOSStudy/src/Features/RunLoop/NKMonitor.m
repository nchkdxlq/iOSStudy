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
            return @"unknow";
    }
}




@interface NKMonitor ()

@property (nonatomic, assign) CFRunLoopObserverRef beforeSourcesObserver;
@property (nonatomic, strong) dispatch_semaphore_t beforeSourcesSemaphore;
@property (nonatomic, assign) CFRunLoopActivity beforeSourcesRunLoopActivity;
@property (nonatomic, assign) NSInteger beforeSourcesTimeoutCount;

@property (nonatomic, assign) CFRunLoopObserverRef afterWaitingObserver;
@property (nonatomic, strong) dispatch_semaphore_t afterWaitingSemaphore;
@property (nonatomic, assign) CFRunLoopActivity afterWaitingRunLoopActivity;
@property (nonatomic, assign) NSInteger afterWaitingTimeoutCount;

@property (nonatomic, assign) BOOL stop;

@end



static void beforeSourcesObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info){
    NKMonitor *lagMonitor = (__bridge NKMonitor*)info;
    lagMonitor.beforeSourcesRunLoopActivity = activity;
    // NSLog(@"beforeSourcesObserverCallBack %@", activityText(activity));
    dispatch_semaphore_t semaphore = lagMonitor.beforeSourcesSemaphore;
    dispatch_semaphore_signal(semaphore);
}


static void afterWaitingObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info){
    NKMonitor *lagMonitor = (__bridge NKMonitor*)info;
    lagMonitor.afterWaitingRunLoopActivity = activity;
    // NSLog(@"afterWaitingObserverCallBack %@", activityText(activity));
    dispatch_semaphore_t semaphore = lagMonitor.afterWaitingSemaphore;
    dispatch_semaphore_signal(semaphore);
}

@implementation NKMonitor


- (instancetype)init {
    self = [super init];
    if (self) {
        self.beforeSourcesSemaphore = dispatch_semaphore_create(0);
        self.afterWaitingSemaphore = dispatch_semaphore_create(0);
        [self addRunLoopObserver];
    }
    return self;
}

- (void)addRunLoopObserver {
    CFRunLoopObserverContext context = {0,(__bridge void*)self, NULL, NULL};
    CFRunLoopObserverRef beforeSourcesObserver = CFRunLoopObserverCreate(kCFAllocatorDefault,
                                                                         kCFRunLoopAllActivities,
                                                                         YES,
                                                                         INT_MAX,
                                                                         &beforeSourcesObserverCallBack,
                                                                         &context);
     CFRunLoopAddObserver(CFRunLoopGetMain(), beforeSourcesObserver, kCFRunLoopCommonModes);
     self.beforeSourcesObserver = beforeSourcesObserver;
    
    
    CFRunLoopObserverRef afterWaitingObserver = CFRunLoopObserverCreate(kCFAllocatorDefault,
                                                                        kCFRunLoopAllActivities,
                                                                        YES,
                                                                        INT_MIN,
                                                                        &afterWaitingObserverCallBack,
                                                                        &context);
     CFRunLoopAddObserver(CFRunLoopGetMain(), afterWaitingObserver, kCFRunLoopCommonModes);
     self.afterWaitingObserver = afterWaitingObserver;
}

- (void)beginMonitor {
    self.stop = NO;
   //创建子线程监控
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        while (self.stop == NO) {
            long semaphoreWait = dispatch_semaphore_wait(self.beforeSourcesSemaphore,
                                                         dispatch_time(DISPATCH_TIME_NOW, 80 * NSEC_PER_MSEC));
            if (semaphoreWait != 0) {
                if (self.beforeSourcesRunLoopActivity == kCFRunLoopBeforeSources) {
                   //出现三次出结果
                    if (++self.beforeSourcesTimeoutCount < 3) {
                        continue;
                    }
                    NSLog(@"调试：监测到卡顿 beforeSourcesRunLoopActivity");
                }
            }
            self.beforeSourcesTimeoutCount = 0;
        }
    });
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        while (self.stop == NO) {
            long semaphoreWait = dispatch_semaphore_wait(self.afterWaitingSemaphore,
                                                         dispatch_time(DISPATCH_TIME_NOW, 80 * NSEC_PER_MSEC));
            if (semaphoreWait != 0) {
                if (self.afterWaitingRunLoopActivity == kCFRunLoopAfterWaiting) {
                    //出现三次出结果
                    if (++self.afterWaitingTimeoutCount < 3) {
                        continue;
                    }
                    NSLog(@"调试：监测到卡顿 afterWaitingRunLoopActivity");
                }
            }
            self.afterWaitingTimeoutCount = 0;
        }
    });
}

- (void)endMonitor {
    CFRunLoopRemoveObserver(CFRunLoopGetMain(), self.beforeSourcesObserver, kCFRunLoopCommonModes);
    CFRunLoopRemoveObserver(CFRunLoopGetMain(), self.afterWaitingObserver, kCFRunLoopCommonModes);
    self.stop = YES;
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

@end


