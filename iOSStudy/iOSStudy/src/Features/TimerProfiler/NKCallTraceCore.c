//
//  NKCallTraceCore.c
//  iOSStudy
//
//  Created by Knox on 2022/1/26.
//

#include "NKCallTraceCore.h"
#include "fishhook.h"

#include <objc/runtime.h>
#include <pthread.h>
#include <dispatch/dispatch.h>
#include <sys/time.h>


typedef struct {
    id self;    //通过 object_getClass 能够得到 Class 再通过 NSStringFromClass 能够得到类名
    Class cls;
    SEL cmd;    //通过 NSStringFromSelector 方法能够得到方法名
    uint64_t time;  //us
    uintptr_t lr;   // link register
} thread_call_record;

typedef struct {
    thread_call_record *stack;
    int allocated_length;
    int index;
    bool is_main_thread;
} thread_call_stack;


static pthread_key_t _thread_key;
static uint64_t g_min_time_cost = 1000; //us
static int g_max_call_depth = 3;


static int g_record_num;
static int g_record_capacity;


static inline thread_call_stack * get_thread_call_stack() {
    thread_call_stack *cs = (thread_call_stack *)pthread_getspecific(_thread_key);
    if (cs == NULL) {
        cs = (thread_call_stack *)malloc(sizeof(thread_call_stack));
        cs->stack = (thread_call_record *)calloc(128, sizeof(thread_call_record));
        cs->allocated_length = 64;
        cs->index = -1;
        cs->is_main_thread = pthread_main_np();
        pthread_setspecific(_thread_key, cs);
    }
    return cs;
}

static void release_thread_call_stack(void *ptr) {
    thread_call_stack *cs = (thread_call_stack *)ptr;
    if (!cs) return;
    if (cs->stack) free(cs->stack);
    free(cs);
}

static inline void push_call_record(id _self, Class _cls, SEL _cmd, uintptr_t lr) {
    thread_call_stack *cs = get_thread_call_stack();
    if (cs == NULL) return;
    
    int nextIndex = (++cs->index);
    if (nextIndex >= cs->allocated_length) {
        cs->allocated_length += 64;
        cs->stack = (thread_call_record *)realloc(cs->stack, cs->allocated_length * sizeof(thread_call_record));
    }
    thread_call_record *newRecord = &cs->stack[nextIndex];
    newRecord->self = _self;
    newRecord->cls = _cls;
    newRecord->cmd = _cmd;
    newRecord->lr = lr;
    if (cs->is_main_thread) {
        struct timeval now;
        gettimeofday(&now, NULL);
        newRecord->time = (now.tv_sec % 100) * 1000000 + now.tv_usec;
    }
}

static inline uintptr_t pop_call_record(void) {
    thread_call_stack *cs = get_thread_call_stack();
    int curIndex = cs->index;
    int nextIndex = curIndex--;
    thread_call_record *pRecord = &cs->stack[nextIndex];
    
    return pRecord->lr;
}


#if 0
__unused static id (*origin_objc_msgSend)(id, SEL, ...);

void before_objc_msgSend(id self, SEL _cmd, uintptr_t lr) {
    const char *selName = sel_getName(_cmd);
    printf("%s", selName);
    push_call_record(self, object_getClass(self), _cmd, lr);
}

uintptr_t after_objc_msgSend(void) {
    return pop_call_record();
}


#define call(b, value) \
__asm volatile ("stp x8, x9, [sp, #-16]!\n"); \
__asm volatile ("mov x12, %0\n" :: "r"(value)); \
__asm volatile ("ldp x8, x9, [sp], #16\n"); \
__asm volatile (#b " x12\n");


#define saveRegisters() \
__asm volatile ( \
"stp x8, x9, [sp, #-16]!\n" \
"stp x6, x7, [sp, #-16]!\n" \
"stp x4, x5, [sp, #-16]!\n" \
"stp x2, x3, [sp, #-16]!\n" \
"stp x0, x1, [sp, #-16]!\n");


#define restoreRegisters() \
__asm volatile ( \
"ldp x0, x1, [sp], #16\n" \
"ldp x2, x3, [sp], #16\n" \
"ldp x4, x5, [sp], #16\n" \
"ldp x6, x7, [sp], #16\n" \
"ldp x8, x9, [sp], #16\n" );

__attribute__((__naked__))
static void hook_objc_msgSend() {
    // 保存参数
    saveRegisters()
 
    // before_objc_msgSend第三个删除是lr, 所有把lr 赋值给 x2
    __asm volatile ("mov x2, lr\n");
    
    // 这行代码不知道什么意思
    __asm volatile ("mov x3, x4\n");
 
    // call before
    call(blr, &before_objc_msgSend)
    
    // 恢复参数
    restoreRegisters()
    
    // call origin
    call(blr, origin_objc_msgSend)
    
    // save original objc_msgSend return value.
    saveRegisters()
    
    // call after
     call(blr, &after_objc_msgSend)
    
    // restore lr
    __asm volatile ("mov lr, x0\n");
    
    // restore original objc_msgSend return value.
    restoreRegisters()
    
    // return
    __asm volatile ("ret\n");
}

void NKCallTraceStart(void) {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pthread_key_create(&_thread_key, &release_thread_call_stack);
        struct rebinding msgSend;
        msgSend.name = "objc_msgSend";
        msgSend.replacement = hook_objc_msgSend;
        msgSend.replaced = (void *)&origin_objc_msgSend;

        struct rebinding rebs[1] = {msgSend};
        rebind_symbols(rebs, 1);
    });
}

#else

#define call(b, value) \
__asm volatile ("stp x8, x9, [sp, #-16]!\n"); \
__asm volatile ("mov x12, %0\n" :: "r"(value)); \
__asm volatile ("ldp x8, x9, [sp], #16\n"); \
__asm volatile (#b " x12\n");

#define save() \
__asm volatile ( \
"stp x8, x9, [sp, #-16]!\n" \
"stp x6, x7, [sp, #-16]!\n" \
"stp x4, x5, [sp, #-16]!\n" \
"stp x2, x3, [sp, #-16]!\n" \
"stp x0, x1, [sp, #-16]!\n");

#define load() \
__asm volatile ( \
"ldp x0, x1, [sp], #16\n" \
"ldp x2, x3, [sp], #16\n" \
"ldp x4, x5, [sp], #16\n" \
"ldp x6, x7, [sp], #16\n" \
"ldp x8, x9, [sp], #16\n" );

#define link(b, value) \
__asm volatile ("stp x8, lr, [sp, #-16]!\n"); \
__asm volatile ("sub sp, sp, #16\n"); \
call(b, value); \
__asm volatile ("add sp, sp, #16\n"); \
__asm volatile ("ldp x8, lr, [sp], #16\n");

#define ret() __asm volatile ("ret\n");

__unused static id (*orig_objc_msgSend)(id, SEL, ...);

void before_objc_msgSend(id self, SEL _cmd, uintptr_t lr) {
    push_call_record(self, object_getClass(self), _cmd, lr);
}

uintptr_t after_objc_msgSend(void) {
    return pop_call_record();
}

__attribute__((__naked__))
static void hook_Objc_msgSend() {
    // Save parameters.
    save()
    
    __asm volatile ("mov x2, lr\n");
    __asm volatile ("mov x3, x4\n");
    
    // Call our before_objc_msgSend.
    call(blr, &before_objc_msgSend)
    
    // Load parameters.
    load()
    
    // Call through to the original objc_msgSend.
    call(blr, orig_objc_msgSend)
    
    // Save original objc_msgSend return value.
    save()
    
    // Call our after_objc_msgSend.
    call(blr, &after_objc_msgSend)
    
    // restore lr
    __asm volatile ("mov lr, x0\n");
    
    // Load original objc_msgSend return value.
    load()
    
    // return
    ret()
}


void NKCallTraceStart(void) {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pthread_key_create(&_thread_key, &release_thread_call_stack);
        rebind_symbols((struct rebinding[6]){
            {"objc_msgSend", (void *)hook_Objc_msgSend, (void **)&orig_objc_msgSend},
        }, 1);
    });
}

#endif
