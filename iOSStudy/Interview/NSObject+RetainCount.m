//
//  NSObject+RetainCount.m
//  Interview
//
//  Created by Knox on 2021/5/6.
//

#import "NSObject+RetainCount.h"

@implementation NSObject (RetainCount)

- (NSUInteger)getRetainCount {
    return self.retainCount;
}

@end
