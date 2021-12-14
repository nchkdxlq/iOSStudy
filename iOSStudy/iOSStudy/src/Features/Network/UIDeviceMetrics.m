//
//  UIDeviceMetrics.m
//  iOSStudy
//
//  Created by Knox on 2021/11/27.
//

#import "UIDeviceMetrics.h"
#import <mach/mach.h>

@implementation UIDeviceMetrics

+ (float)appCpuUsage {
    thread_array_t threadList;
    mach_msg_type_number_t threadCount;
    
    thread_info_data_t threadInfo;
    mach_msg_type_number_t threadInfoCount;
    
    thread_basic_info_t threadBasicInfo;
    
    // 获取线程数量
    kern_return_t kr = task_threads(mach_task_self(), &threadList, &threadCount);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    
    integer_t totalCPU = 0;
    for (int i = 0; i < threadCount; i++) {
        threadInfoCount = THREAD_INFO_MAX;
        // 获取当前线程的信息
        kr = thread_info(threadList[i], THREAD_BASIC_INFO, (thread_info_t)threadInfo, &threadInfoCount);
        if (kr != KERN_SUCCESS) {
            return -1;
        }
        
        threadBasicInfo = (thread_basic_info_t)threadInfo;
        if (!(threadBasicInfo->flags & TH_FLAGS_IDLE)) { // 活跃(非休眠)的线程
            totalCPU += threadBasicInfo->cpu_usage;
        }
    }
    
    // 销毁内存
    kr = vm_deallocate(mach_task_self(), (vm_offset_t)threadList, threadCount * sizeof(thread_t));
    assert(kr == KERN_SUCCESS);
    
    return totalCPU / (float)TH_USAGE_SCALE;
}


+ (float)cpuUsage {
    kern_return_t kr;
    mach_msg_type_number_t count;
    static host_cpu_load_info_data_t previous_info = {0, 0, 0, 0};
    host_cpu_load_info_data_t info;
    
    count = HOST_CPU_LOAD_INFO_COUNT;
    
    kr = host_statistics(mach_host_self(), HOST_CPU_LOAD_INFO, (host_info_t)&info, &count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    
    natural_t user   = info.cpu_ticks[CPU_STATE_USER] - previous_info.cpu_ticks[CPU_STATE_USER];
    natural_t nice   = info.cpu_ticks[CPU_STATE_NICE] - previous_info.cpu_ticks[CPU_STATE_NICE];
    natural_t system = info.cpu_ticks[CPU_STATE_SYSTEM] - previous_info.cpu_ticks[CPU_STATE_SYSTEM];
    natural_t idle   = info.cpu_ticks[CPU_STATE_IDLE] - previous_info.cpu_ticks[CPU_STATE_IDLE];
    natural_t total  = user + nice + system + idle;
    previous_info    = info;
    
    return (user + nice + system) / total;
}

+ (NSUInteger)cpuCount {
    return [NSProcessInfo processInfo].activeProcessorCount;
}


- (unsigned long long)physicalMemory {
    return [NSProcessInfo processInfo].physicalMemory;
}

// 可以在主线程RunLoop的BeforeWaiting事件中获取内存, 这是内存autoreleasepool还未销毁，可获峰值
+ (unsigned long long)appUsedMemory {
    task_vm_info_data_t vmInfo;
    mach_msg_type_number_t count = TASK_VM_INFO_COUNT;
    kern_return_t kr = task_info(mach_task_self(), TASK_VM_INFO, (task_info_t)&vmInfo, &count);
    if (kr == KERN_SUCCESS) {
        return vmInfo.phys_footprint;
    } else {
        return 0;
    }
}


@end
