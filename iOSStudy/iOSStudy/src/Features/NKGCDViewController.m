//
//  NKGCDViewController.m
//  iOSStudy
//
//  Created by Knox on 2021/5/30.
//

#import "NKGCDViewController.h"

@interface NKGCDViewController()

@property (nonatomic, strong) dispatch_source_t timer;

@end

@implementation NKGCDViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self serialQueue];
//    [self concurrentQueue];
    [self dispatch_group_enter_leave];
//    [self dispatch_group_enter_leave];
//    [self dispatch_barrier];
//    [self dispatch_apply];
//    [self dispatch_soruce];
//    [self dispatch_specific];
//    [self dispatch_set_queue_target];
//    [self interview2];
}


- (void)serialQueue {
    dispatch_queue_t queue = dispatch_queue_create("com.nk.serial.queue", NULL);
    dispatch_async(queue, ^{
        NSLog(@"SerialQueue dispatch_async %@", [NSThread currentThread]); // 开启新线程, 在子线程执行
    });
    
    dispatch_sync(queue, ^{
        NSLog(@"SerialQueue dispatch_sync  %@", [NSThread currentThread]); // 不开启新线程, 在主线程执行
    });
}


- (void)concurrentQueue {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSLog(@"ConcurrentQueue dispatch_async %@", [NSThread currentThread]);
    });
    
    for (int i = 0; i < 100; i++) {
        dispatch_sync(queue, ^{
            NSLog(@"ConcurrentQueue dispatch_sync %@", [NSThread currentThread]);
        });
    }
}

- (void)createQueue {
    dispatch_queue_t serialQueue = dispatch_queue_create("com.nk.serial", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t concurrentQueue = dispatch_queue_create("com.nk.concurrent", DISPATCH_QUEUE_CONCURRENT);
}



- (void)dispatch_group_enter_leave {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    dispatch_group_async(group, queue, ^{
        NSLog(@"Task111 begin");
        [NSThread sleepForTimeInterval:1];
        NSLog(@"Task111 end");
        dispatch_group_leave(group);
    });
    
    dispatch_group_enter(group);
    dispatch_group_async(group, queue, ^{
        NSLog(@"Task222 begin");
        [NSThread sleepForTimeInterval:2];
        NSLog(@"Task222 end");
        dispatch_group_leave(group);
    });
    
    NSLog(@"dispatch_group_notify begin");
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"All Task Complete");
    });
    NSLog(@"dispatch_group_notify end");
}


/// 信号量
- (void)dispatch_semaphore {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    // 等待信号量, 使信号量减1
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    // 发送一个信号量, 使信号量加1
    dispatch_semaphore_signal(semaphore);
}


- (void)dispatch_barrier {
    // 一定要是手动创建的并发队列, 不能是全局队列, 否则dispatch_barrier_async不起作用
    dispatch_queue_t queue = dispatch_queue_create("com.nk.concurrent", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        NSLog(@"dispatch_barrier Task111 begin");
        sleep(1);
        NSLog(@"dispatch_barrier Task111 end");
    });
    dispatch_async(queue, ^{
        NSLog(@"dispatch_barrier Task222 begin");
        sleep(1.2);
        NSLog(@"dispatch_barrier Task222 end");
    });
    
    dispatch_barrier_async(queue, ^{
        NSLog(@"dispatch_barrier Task-barrier begin");
        sleep(1);
        NSLog(@"dispatch_barrier Task-barrier end");
    });
    
    dispatch_async(queue, ^{
        NSLog(@"dispatch_barrier Task3 begin");
        sleep(1);
        NSLog(@"dispatch_barrier Task3 end");
    });
    dispatch_async(queue, ^{
        NSLog(@"dispatch_barrier Task4 begin");
        sleep(1.3);
        NSLog(@"dispatch_barrier Task4 end");
    });
}

- (void)dispatch_apply {
    dispatch_queue_t queue = dispatch_queue_create("com.nk.concurrent", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"dispatch_apply begin");
    dispatch_apply(10, queue, ^(size_t index) {
        NSLog(@"dispatch_apply index = %zu", index);
    });
    NSLog(@"dispatch_apply end");
}


- (void)dispatch_io {
    
}


- (void)dispatch_source {
    dispatch_queue_t queue = dispatch_queue_create("com.nk.concurrent", DISPATCH_QUEUE_CONCURRENT);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC, 1 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        NSLog(@"event_handler");
    });
    dispatch_source_set_cancel_handler(timer, ^{
        NSLog(@"cancel_handler");
    });
    dispatch_resume(timer);
    self.timer = timer;
}


#pragma mark - dispatch_specific

void go(void) {
    //使用dispatch_sync改变了当前的执行队列，所以这里可以检索到queueKey
    if(dispatch_get_specific("queueKey")) {
        NSLog(@"queue");
    } else if(dispatch_get_specific("queueKey2")) {
        NSLog(@"queue2");
    } else {
        NSLog(@"main queue");
    }
}

void queueFunction(void *info) {
    NSLog(@"__queueFunction");
}

- (void)dispatch_specific {
    
    const void * queueKey = "queueKey";
    const void * queueKey2 = "queueKey2";
    dispatch_queue_t queue = dispatch_queue_create(queueKey, NULL);
    dispatch_queue_t queue2 = dispatch_queue_create(queueKey2, NULL);
    
    //调用此方法会触发queueFunction函数，留个疑问queueFunction是在什么时候触发？
    dispatch_queue_set_specific(queue, queueKey, &queueKey, queueFunction);
    dispatch_queue_set_specific(queue2, queueKey2, &queueKey2, NULL);
    
    dispatch_sync(queue, ^{
        go();
    });
    dispatch_sync(queue2, ^{
        go();
    });
    
    if (dispatch_queue_get_specific(queue, queueKey)) {
        NSLog(@"__run in queue");
    }

    //main queue中找不到queueKey，所以这段Log不会触发，使用dispatch_get_specific(queueKey)的原理也一样
    if (dispatch_queue_get_specific(dispatch_get_main_queue(), queueKey)) {
        NSLog(@"__run in main queue");
    }
    if (dispatch_get_specific(queueKey)) {
        NSLog(@"__run in main queue");
    }
}

- (void)dispatch_set_queue_target {
    dispatch_queue_t targetQueue = dispatch_queue_create("com.iBinaryOrg.targetQueue", DISPATCH_QUEUE_SERIAL);
    
    //创建 3 个同步队列
    dispatch_queue_t queue1 = dispatch_queue_create("queue1", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue2 = dispatch_queue_create("queue2", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue3 = dispatch_queue_create("queue3", DISPATCH_QUEUE_SERIAL);

    //设置优先级(标记 1)
    dispatch_set_target_queue(queue1, targetQueue);
    dispatch_set_target_queue(queue2, targetQueue);
    dispatch_set_target_queue(queue3, targetQueue);
    
    dispatch_async(targetQueue, ^{
        NSLog(@"target queue in");
        [NSThread sleepForTimeInterval:4];
        NSLog(@"target queue out");
    });

    dispatch_async(queue1, ^{
        NSLog(@"1 in");
        [NSThread sleepForTimeInterval:3];
        NSLog(@"1 out");
    });

    dispatch_async(queue2, ^{
        NSLog(@"2 in");
        [NSThread sleepForTimeInterval:2];
        NSLog(@"2 out");
    });

    dispatch_async(queue3, ^{
        NSLog(@"3 in");
        [NSThread sleepForTimeInterval:1];
        NSLog(@"3 out");
    });
}


- (NSString *)get_queue_specific {
    if (dispatch_get_specific("queue1")) {
        return @"queue1";
    } else if (dispatch_get_specific("queue2")) {
        return @"queue2";
    } else if (dispatch_get_specific("targetQueue")) {
        return @"targetQueue";
    } else {
        return @"mainQueue";
    }
    
}


#pragma mark - 面试题

- (void)interview1 {
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_async(queue, ^{
        NSLog(@"1");
        [self performSelector:@selector(test) withObject:nil afterDelay:0];
        NSLog(@"3");
    });
}

- (void)test {
    NSLog(@"2");
}

- (void)interview2 {
    NSThread *thread = [[NSThread alloc] initWithBlock:^{
        NSLog(@"1");
    }];
    [thread start];
    [self performSelector:@selector(test) onThread:thread withObject:nil waitUntilDone:YES];
}


@end
