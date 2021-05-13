//
//  NKBlockCaptureObject.m
//  Interview
//
//  Created by Knox on 2021/5/6.
//

#import "NKBlockCaptureObject.h"
#import "NSObject+RetainCount.h"

void stackBlock(void);
void mallocBlock(void);

void entry(void) {
    stackBlock();
    mallocBlock();
}

void stackBlock(void) {
    NSObject *obj = [NSObject new];
    __unsafe_unretained NSObject *unretainedObj = obj;
    NSLog(@"111 RetainCount = %zd", [obj getRetainCount]);
    __unsafe_unretained void(^block)(void) = ^{
        [unretainedObj class];
    };
    NSLog(@"block = %@", [block class]);
    NSLog(@"222 RetainCount = %zd", [obj getRetainCount]);
}

void mallocBlock(void) {
    NSObject *obj = [NSObject new];
    NSLog(@"111 RetainCount = %zd", [obj getRetainCount]);
    void(^block)(void) = ^{
        [obj class];
    };
    NSLog(@"block = %@", [block class]);
    NSLog(@"2222 RetainCount = %zd", [obj getRetainCount]);
}


