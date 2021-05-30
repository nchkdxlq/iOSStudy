//
//  NKRuntime.m
//  Interview
//
//  Created by Knox on 2021/5/16.
//

#import "NKRuntime.h"
#import <objc/runtime.h>

//////////////////////////////////////////////////////
@interface NKPerson : NSObject

@property (nonatomic, assign) int age;
@property (nonatomic, copy) NSString *name;


@end

@implementation NKPerson

@end


//////////////////////////////////////////////////////
@interface NKStudent : NKPerson

@end


@implementation NKStudent

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSLog(@"[self class] = %@ ", [self class]); // [self class] = NKStudent
        NSLog(@"[super class] = %@ ", [super class]); // [super class] = NKStudent
        NSLog(@"[self superclass] = %@ ", [self superclass]); // [self superclass] = NKPerson
        NSLog(@"[super superclass] = %@ ", [super superclass]); // [super superclass] = NKPerson
    }
    return self;
}

@end


//////////////////////////////////////////////////////

@implementation NKRuntime


+ (void)entry {
    NKStudent *st = [NKStudent new];
    [st setValue:nil forKey:@"name"];
}


+ (BOOL)resolveInstanceMethod:(SEL)sel {
    return YES;
}

+ (BOOL)resolveClassMethod:(SEL)sel {
    return YES;
}


- (id)forwardingTargetForSelector:(SEL)aSelector {
    return nil;
}


- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    return nil;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    
}

- (void)doesNotRecognizeSelector:(SEL)aSelector {
    
}


@end
