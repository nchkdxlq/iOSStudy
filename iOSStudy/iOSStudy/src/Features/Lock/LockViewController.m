//
//  LockViewController.m
//  iOSStudy
//
//  Created by Knox on 2021/8/14.
//

#import "LockViewController.h"
#import "NSObject+RetainCount.h"

@interface LockViewController ()

@property (nonatomic, strong) NSObject *obj;

@end


@implementation LockViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.obj = [NSObject new];
    
    NSObject *tmpObj = self.obj;
    NSLog(@"1 retainCount = %ld", [tmpObj getRetainCount]);
    @synchronized (tmpObj) {
        NSLog(@"2 retainCount = %ld", [tmpObj getRetainCount]);
        tmpObj = nil;
    }
    NSLog(@"3 retainCount = %ld", [self.obj getRetainCount]);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @synchronized (self.obj) {
            NSLog(@"获得了锁, 正在实行任务...");
        }
    });
}

@end
