//
//  NKPortViewController.m
//  iOSStudy
//
//  Created by Knox on 2021/9/3.
//

#import "NKPortViewController.h"
#import <Foundation/NSPort.h>

@interface NKPortViewController () <NSPortDelegate>

@property (nonatomic, strong) NSPort *mainPort;

@property (nonatomic, strong) NSPort *threadPort;

@property (nonatomic, strong) NSThread *thread;

@end


@implementation NKPortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSPort *port = [NSMachPort port];
    port.delegate = self;
    self.mainPort = port;
    [[NSRunLoop currentRunLoop] addPort:port forMode:NSRunLoopCommonModes];
    
    [self detachNewThread];
}

- (void)detachNewThread {
    self.thread = [[NSThread alloc] initWithBlock:^{
        NSPort *port = [NSMachPort port];
        port.delegate = self;
        self.threadPort = port;
        NSLog(@"111 ---------");
        [[NSRunLoop currentRunLoop] addPort:port forMode:NSRunLoopCommonModes];
        [[NSRunLoop currentRunLoop] run];
        NSLog(@"222 ---------");
    }];
    self.thread.name = @"new";
    [self.thread start];
}

- (void)test {
    [self.mainPort sendBeforeDate:[NSDate date] components:nil from:self.threadPort reserved:0];
}

#pragma mark - NSPortDelegate

- (void)handlePortMessage:(NSPortMessage *)message {
    NSLog(@"%@", [NSThread currentThread]);
    NSLog(@"%@", message);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.threadPort sendBeforeDate:[NSDate date] components:nil from:self.mainPort reserved:0];
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self performSelector:@selector(test) onThread:self.thread withObject:nil waitUntilDone:NO];}

@end
