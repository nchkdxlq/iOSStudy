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

@property (nonatomic, strong) dispatch_semaphore_t dispatchSemaphore;

@property (nonatomic, assign) CFRunLoopActivity runLoopActivity;

@property (nonatomic, assign) NSInteger timeoutCount;

@property (nonatomic, assign) CFRunLoopObserverRef runLoopObserver;


@end


// 记录状态
static void runLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info){
    NKMonitor *lagMonitor = (__bridge NKMonitor*)info;
    lagMonitor.runLoopActivity = activity;
    NSLog(@"runLoopObserverCallBack %@", activityText(activity));
    dispatch_semaphore_t semaphore = lagMonitor.dispatchSemaphore;
    dispatch_semaphore_signal(semaphore);
}


@implementation NKMonitor


- (instancetype)init {
    self = [super init];
    if (self) {
        self.dispatchSemaphore = dispatch_semaphore_create(0);
    }
    return self;
}


// 注册
- (void)beginMonitor {
   CFRunLoopObserverContext context = {0,(__bridge void*)self,NULL,NULL};
   CFRunLoopObserverRef runLoopObserver = CFRunLoopObserverCreate(kCFAllocatorDefault,
                                             kCFRunLoopAllActivities,
                                             YES,
                                             LONG_MAX,
                                             &runLoopObserverCallBack,
                                             &context);
   //将观察者添加到主线程runloop的common模式下的观察中
    CFRunLoopAddObserver(CFRunLoopGetMain(), runLoopObserver, kCFRunLoopCommonModes);
    self.runLoopObserver = runLoopObserver;

   //创建子线程监控
   dispatch_async(dispatch_get_global_queue(0, 0), ^{
       //子线程开启一个持续的loop用来进行监控
       while (YES) {
           long semaphoreWait = dispatch_semaphore_wait(self.dispatchSemaphore, dispatch_time(DISPATCH_TIME_NOW, 80 * NSEC_PER_MSEC));
           NSLog(@"beginMonitor %@", activityText(self.runLoopActivity));
           if (semaphoreWait != 0) {
               if (!self.runLoopObserver) {
                   self.timeoutCount = 0;
                   self.dispatchSemaphore = NULL;
                   self.runLoopActivity = 0;
                   return;
               }
               //两个runloop的状态，BeforeSources和AfterWaiting这两个状态区间时间能够检测到是否卡顿
               if (self.runLoopActivity == kCFRunLoopBeforeSources || self.runLoopActivity == kCFRunLoopAfterWaiting) {
                   //出现三次出结果
                   if (++self.timeoutCount < 3) {
                       continue;
                   }
                   NSLog(@"调试：监测到卡顿");
               } //end activity
           }// end semaphore wait
           self.timeoutCount = 0;
       }// end while
   });
}



- (void)addRunLoopObserver
{
    NSRunLoop *curRunLoop = [NSRunLoop currentRunLoop];

    // 第一个监控，监控是否处于 **运行状态**
    CFRunLoopObserverContext context = {0, (__bridge void *) self, NULL, NULL, NULL};
    CFRunLoopObserverRef beginObserver = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, LONG_MIN, &myRunLoopBeginCallback, &context);
    CFRetain(beginObserver);
//    m_runLoopBeginObserver = beginObserver;

    //  第二个监控，监控是否处于 **睡眠状态**
    CFRunLoopObserverRef endObserver = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, LONG_MAX, &myRunLoopEndCallback, &context);
    CFRetain(endObserver);
//    m_runLoopEndObserver = endObserver;

    CFRunLoopRef runloop = [curRunLoop getCFRunLoop];
    CFRunLoopAddObserver(runloop, beginObserver, kCFRunLoopCommonModes);
    CFRunLoopAddObserver(runloop, endObserver, kCFRunLoopCommonModes);

}

// 第一个监控，监控是否处于 **运行状态**
void myRunLoopBeginCallback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info)
{
    g_runLoopActivity = activity;
    g_runLoopMode = eRunloopDefaultMode;
    switch (activity) {
        case kCFRunLoopEntry:
            g_bRun = YES;
            break;
        case kCFRunLoopBeforeTimers:
            if (g_bRun == NO) {
                gettimeofday(&g_tvRun, NULL);
            }
            g_bRun = YES;
            break;
        case kCFRunLoopBeforeSources:
            if (g_bRun == NO) {
                gettimeofday(&g_tvRun, NULL);
            }
            g_bRun = YES;
            break;
        case kCFRunLoopAfterWaiting:
            if (g_bRun == NO) {
                gettimeofday(&g_tvRun, NULL);
            }
            g_bRun = YES;
            break;
        case kCFRunLoopAllActivities:
            break;
        default:
            break;
    }
}

//  第二个监控，监控是否处于 **睡眠状态**
void myRunLoopEndCallback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info)
{
    g_runLoopActivity = activity;
    g_runLoopMode = eRunloopDefaultMode;
    switch (activity) {
        case kCFRunLoopBeforeWaiting:
            gettimeofday(&g_tvRun, NULL);
            g_bRun = NO;
            break;
        case kCFRunLoopExit:
            g_bRun = NO;
            break;
        case kCFRunLoopAllActivities:
            break;
        default:
            break;
    }
}



@end


