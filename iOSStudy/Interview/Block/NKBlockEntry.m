//
//  NKBlockEntry.m
//  Interview
//
//  Created by Knox on 2021/5/4.
//

#import "NKBlockEntry.h"
#import "NKBlockCaptureObject.h"


@implementation NKBlockEntry

+ (void)entry {
    entry();
}

+ (void)testBlockType {
    int age = 10;
    void(^block1)(void) = ^{
        NSLog(@"age = %d", age);
    };
    __unsafe_unretained void(^block2)(void) = ^{
        NSLog(@"age = %d", age);
    };
    NSLog(@"block1 = %@, block2 = %@", [block1 class], [block2 class]);
}


@end
