//
//  NKThread.m
//  iOSStudy
//
//  Created by Knox on 2021/11/1.
//

#import "NKThread.h"
#import <mach/mach.h>
#import "NKStackFrameMacro.h"

// 栈帧抽象结构体,只关注有用的两个指针
typedef struct StackFrame {
    const struct StackFrame *const framePoint; // FP: *FP 上一个函数起始
    const uintptr_t linkRegister; // LR: *(FP + 8) 此函数结束后返回的上一个函数的下一条指令的地址
} StackFrame;


// 获取线程信息
BOOL fillThreadStateInfoMachineContext(thread_t thread, _STRUCT_MCONTEXT *machineContext) {
    mach_msg_type_number_t state_count = NK_THREAD_STATE_COUNT;
    kern_return_t kr = thread_get_state(thread, NK_THREAD_STATE, (thread_state_t)&machineContext->__ss, &state_count);
    return kr == KERN_SUCCESS;
}

// 获取指令指针(Program Counter) pc
uintptr_t mach_instructionAddress(mcontext_t const machineContext) {
    return machineContext->__ss.NK_INSTRUCTION_ADDRESS;
}

// 获取栈帧指针(Frame Point) fp
uintptr_t mach_framePointer(mcontext_t const machineContext) {
    return machineContext->__ss.NK_FRAME_POINTER;
}

// 获取栈顶指针(Stack Point) sp
uintptr_t mach_stackPointer(mcontext_t const machineContext) {
    return machineContext->__ss.NK_STACK_POINTER;
}

// 获取当前函数调用栈的LR, 即返回地址，即函数调用的下一条指令的地址
uintptr_t mach_linkRegister(mcontext_t const machineContext) {
#if defined(__i386__) || defined(__x86_64__)
    return 0;
#else
    return machineContext->__ss.__lr;
#endif
}

//
kern_return_t mach_copyMemory(const void *const src, void *const dst, const size_t numBytes) {
    vm_size_t bytesCopied = 0;
    return vm_read_overwrite(mach_task_self(), (vm_address_t)src, (vm_size_t)numBytes, (vm_address_t)dst, &bytesCopied);
}


@implementation NKThread

+ (instancetype)threadWithThread:(thread_t)thread {
    return [[self alloc] initWithThread:thread];
}

- (instancetype)initWithThread:(thread_t)thread {
    if (self) {
        _thread = thread;
        [self fillThreadState];
    }
    return self;
}

- (void)fillThreadState {
    _STRUCT_MCONTEXT machineContext;
    uintptr_t backtraceBuffer[50];
    int i = 0;
    // 1. 把线程上下文信息填充到 _STRUCT_MCONTEXT 结构体中
    BOOL ret = fillThreadStateInfoMachineContext(_thread, &machineContext);
    if (ret == NO) {
        NSLog(@"Fail to get information about thread: %u", _thread);
        return;
    }
    
    // 2. 获取当前线程的指令指针, // ❓为什么要先加入PC? 因为在符号化的时候可以找到当前函数地址.如果只有LR,当前函数没有指针指向了.
    const uintptr_t instructionAddress = mach_instructionAddress(&machineContext);
    if(instructionAddress == 0) {
        NSLog(@"Fail to get instruction address");
        return;
    }
    backtraceBuffer[i++] = instructionAddress;
    
    // LR寄存器,函数返回地址.用于递归符号化堆栈
    uintptr_t linkRegister = mach_linkRegister(&machineContext);
    if (linkRegister > 0) {
        backtraceBuffer[i++] = linkRegister;
    }
    
    StackFrame frame = {0};
    const uintptr_t framePtr = mach_framePointer(&machineContext);
    if (framePtr == 0) { // 获取栈帧指针FP失败
        NSLog(@"Fail to get frame pointer from register");
        return;
    }
    if(mach_copyMemory((void *)framePtr, &frame, sizeof(frame)) != KERN_SUCCESS) {
        NSLog(@"Fail to get frame pointer from Memory");
        return;
    }
    
    // 递归获取函数调用栈
    while (frame.linkRegister > 0) {
        backtraceBuffer[i++] = frame.linkRegister;
        if (frame.framePoint == NULL) { // 递归到底了, 到了第一个函数
            break;
        }
        
        if(mach_copyMemory(frame.framePoint, &frame, sizeof(frame)) != KERN_SUCCESS) {
            NSLog(@"Fail to get frame pointer from Memory");
            break;
        }
    }
    
    
    
}

//#pragma -mark HandleMachineContext
//bool bs_fillThreadStateIntoMachineContext(thread_t thread, _STRUCT_MCONTEXT *machineContext) {
//    mach_msg_type_number_t state_count = BS_THREAD_STATE_COUNT;
//    kern_return_t kr = thread_get_state(thread, BS_THREAD_STATE, (thread_state_t)&machineContext->__ss, &state_count);
//    return (kr == KERN_SUCCESS);
//}
//

@end
