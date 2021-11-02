//
//  NKRunLoopActivityMonitor.m
//  iOSStudy
//
//  Created by Knox on 2021/10/13.
//

#import "NKRunLoopActivityMonitor.h"

void activitiesObserverCallback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info);

@interface NKRunLoopActivityMonitor ()

@property (nonatomic, assign) CFRunLoopActivity activity;
@property (nonatomic, assign) unsigned long long loopCount;

@end

@implementation NKRunLoopActivityMonitor

+ (CFRunLoopActivity)activity {
    return [NKRunLoopActivityMonitor sharedMonitor].activity;
}

+ (NSString *)activityText {
    NSString *text = nil;
    switch (self.activity) {
        case kCFRunLoopEntry:
            text = @"kCFRunLoopEntry";
            break;
        case kCFRunLoopBeforeTimers:
            text = @"kCFRunLoopBeforeTimers";
            break;
        case kCFRunLoopBeforeSources:
            text = @"kCFRunLoopBeforeSources";
            break;
        case kCFRunLoopBeforeWaiting:
            text = @"kCFRunLoopBeforeWaiting";
            break;
        case kCFRunLoopAfterWaiting:
            text = @"kCFRunLoopAfterWaiting";
            break;
        case kCFRunLoopExit:
            text = @"kCFRunLoopExit";
            break;
        default:
            text = @"kCFRunLoop_UnKnow";
            break;
    }
    return [NSString stringWithFormat:@"%@ [ %lld ]", text, [NKRunLoopActivityMonitor sharedMonitor].loopCount];
}


+ (instancetype)sharedMonitor {
    static NKRunLoopActivityMonitor *monitor;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        monitor = [NKRunLoopActivityMonitor new];
    });
    return monitor;
}

+ (void)startMonitor {
    [NKRunLoopActivityMonitor sharedMonitor];
}


- (instancetype)init {
    self = [super init];
    if (self) {
        CFRunLoopObserverContext context = {0, (__bridge void*)self, NULL, NULL};
        CFRunLoopObserverRef observer = CFRunLoopObserverCreate(kCFAllocatorDefault,
                                                                kCFRunLoopAllActivities,
                                                                YES, INT_MIN,
                                                                &activitiesObserverCallback,
                                                                &context);
        CFRunLoopAddObserver(CFRunLoopGetMain(), observer, kCFRunLoopCommonModes);
    }
    return self;
}


@end

void activitiesObserverCallback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    NKRunLoopActivityMonitor *monitor = (__bridge NKRunLoopActivityMonitor*)info;
    monitor.activity = activity;
    monitor.loopCount++;
}
