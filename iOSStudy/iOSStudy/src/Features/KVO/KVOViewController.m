//
//  KVOViewController.m
//  iOSStudy
//
//  Created by Knox on 2021/12/13.
//

#import "KVOViewController.h"
#import <objc/runtime.h>

@interface KVOTest : NSObject

@property (nonatomic, assign) NSInteger age;

@end


@implementation KVOTest

- (void)setAge:(NSInteger)age {
    NSLog(@"%s", __func__);
    _age = age;
}

@end


/////////////////////////////////////////////


@interface KVOViewController ()

@property (nonatomic, strong) KVOTest *obj;

@end

@implementation KVOViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _obj = [KVOTest new];
    
    Class originCls = object_getClass(_obj.class);
    IMP originSEL = [_obj methodForSelector:@selector(setAge:)];
    NSLog(@"before RetainCount = %ld", [_obj getRetainCount]);
    [_obj addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionNew context:NULL];
    NSLog(@"after RetainCount = %ld", [_obj getRetainCount]);
    
    Class newCls = object_getClass(_obj);
    IMP newSEL = [_obj methodForSelector:@selector(setAge:)];
    
    // 添加KVO后对象的Class发生了变化
    NSLog(@"originCls = %@,  newCls = %@", originCls, newCls); // originCls = KVOTest,  newCls = NSKVONotifying_KVOTest
    
    // set方法地址也发生了变化
    NSLog(@"originSEL = %p,  newSEL = %p", originSEL, newSEL); // originSEL = 0x105cd1b80,  newSEL = 0x7fff207a3e45
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"%@", change);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    _obj.age = arc4random() % 30;
}


@end
