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

- (void)play {
    NSLog(@"%s", __func__);
}

- (void)stuPlay {
    NSLog(@"%s", __func__);
}

@end


//////////////////////////////////////////////////////

@interface NKRuntime ()

- (void)play;

+ ()run;

@property (nullable, strong) NKStudent *stu;

@end


void test(id obj, SEL _cmd) {
    NSLog(@"%d 动态添加的方法被调用了", [obj isKindOfClass:NKRuntime.class]);
}

@implementation NKRuntime


+ (void)entry {
//    NKStudent *st = [NKStudent new];
//    [st setValue:nil forKey:@"name"];
    
    NKRuntime *obj = [NKRuntime new];
    obj.stu = [NKStudent new];
    [obj play];
//    [NKRuntime run];
}


+ (BOOL)resolveInstanceMethod:(SEL)sel {
    NSLog(@"%s", __func__);
    // 步骤二 : 方法动态解析
    // class_addMethod(self, sel, (IMP)test, "v@:");
    return NO;
}

+ (BOOL)resolveClassMethod:(SEL)sel {
    NSLog(@"%s", __func__);
    Class metaClass = object_getClass(self);
    class_addMethod(metaClass, sel, (IMP)test, "v@:");
    return YES;
}

// 下面是步骤三: 消息转发
- (id)forwardingTargetForSelector:(SEL)aSelector {
    NSLog(@"%s", __func__);
//    return self.stu;
    return nil;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSLog(@"%s", __func__);
    return [NSMethodSignature signatureWithObjCTypes:"v@:"];
//    return nil;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    NSLog(@"%s", __func__);
    anInvocation.target = self.stu;
    anInvocation.selector = @selector(stuPlay);
    [anInvocation invoke];
}

- (void)doesNotRecognizeSelector:(SEL)aSelector {
    NSLog(@"%s", __func__);
}


- (void)playIMPL {
    NSLog(@"%s", __func__);
}

@end
