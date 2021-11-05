//
//  NKProcessInfo.m
//  iOSStudy
//
//  Created by Knox on 2021/11/1.
//

#import "NKProcessInfo.h"
#import <mach/mach.h>
#import "NKThread.h"

@implementation NKProcessInfo

+ (nullable instancetype)processInfo {
    thread_act_array_t threads;
    mach_msg_type_number_t thread_count = 0;
    const task_inspect_t this_task = mach_task_self();
    kern_return_t kr = task_threads(this_task, &threads, &thread_count);
    if(kr != KERN_SUCCESS) {
        return nil;
    }
    return [NKProcessInfo processWithThreadCount:thread_count threads:threads];
}


+ (instancetype)processWithThreadCount:(NSInteger)threadCount threads:(thread_act_array_t)threads {
    return [[NKProcessInfo alloc] initWithThreadCount:threadCount threads:threads];
}

- (instancetype)initWithThreadCount:(NSInteger)threadCount threads:(thread_act_array_t)threads {
    if (self) {
        NSMutableArray<NKThread *> *threadList = [NSMutableArray arrayWithCapacity:threadCount];
        for (NSInteger i = 0; i < threadCount; i++) {
            NKThread *nkThread = [NKThread threadWithThread:threads[i]];
            [threadList addObject:nkThread];
        }
        _threads = threadList.copy;
    }
    return self;
}


@end
