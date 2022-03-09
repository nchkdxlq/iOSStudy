//
//  NKLaunchMetrics.m
//  iOSStudy
//
//  Created by Knox on 2022/3/5.
//

#import "NKLaunchMetrics.h"
#import <sys/sysctl.h>

// 返回进程创建的时间戳(ms)
NSTimeInterval processStartTime(void) {
    int pid = [NSProcessInfo processInfo].processIdentifier;
    int cmd[4] = {CTL_KERN, KERN_PROC, KERN_PROC_PID, pid};
    
    struct kinfo_proc procInfo;
    size_t size = sizeof(procInfo);
    int ret = sysctl(cmd, sizeof(cmd)/sizeof(*cmd), &procInfo, &size, NULL, 0);
    if (ret == 0) {
        struct timeval startime = procInfo.kp_proc.p_un.__p_starttime;
        return startime.tv_sec * 1000.0 + startime.tv_usec / 1000.0;
    } else {
        NSLog(@"无法取得进程的信息");
        return -1;
    }
}


// 记录各节点的时间戳(ms)
static NSTimeInterval g_mainTime = 0;
static NSTimeInterval g_didFinishEndTime = 0;

@implementation NKLaunchMetrics

+ (void)main {
    g_mainTime = [[NSDate date] timeIntervalSince1970] * 1000;
}

+ (void)didFinishLaunchingEnd {
    g_didFinishEndTime = [[NSDate date] timeIntervalSince1970] * 1000;
}

+ (void)initialFrameDidRender {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self internalInitialFrameDidRender];
    });
}

+ (void)internalInitialFrameDidRender {
    NSTimeInterval initialFrameDidRender = [[NSDate date] timeIntervalSince1970] * 1000;
    NSTimeInterval startTime = processStartTime();
    
    NSTimeInterval total = initialFrameDidRender - startTime;
    NSTimeInterval prevMain = g_mainTime - startTime;
    NSTimeInterval didFinishLaunch = g_didFinishEndTime - g_mainTime; // 非常接近Instruments统计结果
    NSTimeInterval initialFrame = initialFrameDidRender - g_didFinishEndTime;
    
    NSLog(@"\n\
          AppLaunch Metrics           total = %.3f ms \n\
          AppLaunch Metrics        prevMain = %.3f ms \n\
          AppLaunch Metrics didFinishLaunch = %.3f ms \n\
          AppLaunch Metrics    initialFrame = %.3f ms", total, prevMain, didFinishLaunch, initialFrame);
}

@end
