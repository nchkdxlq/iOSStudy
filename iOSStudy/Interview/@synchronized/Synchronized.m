//
//  Synchronized.m
//  Interview
//
//  Created by Knox on 2021/8/14.
//

#import "Synchronized.h"
//#import "NSObject+RetainCount.h"

@implementation Synchronized

+ (void)entry {
    
    NSObject *obj = [NSObject new];
    @synchronized (obj) {
        obj = nil;
    }
}

@end
