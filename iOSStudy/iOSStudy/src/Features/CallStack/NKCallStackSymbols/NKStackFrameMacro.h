//
//  NKStackFrameMacro.h
//  iOSStudy
//
//  Created by Cookie on 2021/11/1.
//

#ifndef NKStackFrameMacro_h
#define NKStackFrameMacro_h


#if defined(__arm64__)
#define NK_THREAD_STATE_COUNT ARM_THREAD_STATE64_COUNT
#define NK_THREAD_STATE ARM_THREAD_STATE64
#define NK_INSTRUCTION_ADDRESS __pc
#define NK_FRAME_POINTER __fp
#define NK_STACK_POINTER __sp

#elif defined(__arm__)
#define NK_THREAD_STATE_COUNT ARM_THREAD_STATE_COUNT
#define NK_THREAD_STATE ARM_THREAD_STATE
#define NK_INSTRUCTION_ADDRESS __pc
#define NK_FRAME_POINTER __r[7]
#define NK_STACK_POINTER __sp

#elif defined(__x86_64__)
#define NK_THREAD_STATE_COUNT x86_THREAD_STATE64_COUNT
#define NK_THREAD_STATE x86_THREAD_STATE64
#define NK_INSTRUCTION_ADDRESS __rip
#define NK_FRAME_POINTER __rbp
#define NK_STACK_POINTER __rsp

#elif defined(__i386__)
#define NK_THREAD_STATE_COUNT x86_THREAD_STATE32_COUNT
#define NK_THREAD_STATE x86_THREAD_STATE32
#define NK_INSTRUCTION_ADDRESS __eip
#define NK_FRAME_POINTER __ebp
#define NK_STACK_POINTER __esp

#endif


#endif /* NKStackFrameMacro_h */
