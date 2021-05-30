//
//  NKRunLoopViewController.m
//  iOSStudy
//
//  Created by Knox on 2021/5/25.
//

#import "NKRunLoopViewController.h"

void runLoopObserverCallback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    switch (activity) {
        case kCFRunLoopEntry:
            NSLog(@"kCFRunLoopEntry");
            break;
        case kCFRunLoopBeforeTimers:
            NSLog(@"kCFRunLoopBeforeTimers");
            break;
        case kCFRunLoopBeforeSources:
            NSLog(@"kCFRunLoopBeforeSources");
            break;
        case kCFRunLoopBeforeWaiting:
            NSLog(@"kCFRunLoopBeforeWaiting");
            break;
        case kCFRunLoopAfterWaiting:
            NSLog(@"kCFRunLoopAfterWaiting");
            break;
        case kCFRunLoopExit:
            NSLog(@"kCFRunLoopExit");
            break;
        default:
            break;
    }
}


@interface NKRunLoopViewController() <UIGestureRecognizerDelegate>

@end

@implementation NKRunLoopViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"RunLoop";
    
//    [self addRunLoopObserver];
    [self dispatchMainQueue];
    [self timer];
    [self buttonTap];
    [self gestureRecognizer];
    [self performSelectorAfterDelay];
}

- (void)addRunLoopObserver {
    CFRunLoopRef runloopRef = CFRunLoopGetMain();
    CFRunLoopObserverRef observer = CFRunLoopObserverCreate(kCFAllocatorDefault,
                                                            kCFRunLoopAllActivities,
                                                            YES, 0,
                                                            runLoopObserverCallback, nil);
    CFRunLoopAddObserver(runloopRef, observer, kCFRunLoopCommonModes);
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
}

#pragma mark - dispatchMainQueue
- (void)dispatchMainQueue {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"");
    });
}

#pragma mark - timer
- (void)timer {
    NSTimer *timer = [NSTimer timerWithTimeInterval:3 target:self selector:@selector(timerHandler:) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

- (void)timerHandler:(NSTimer *)timer {
    NSLog(@"");
}

#pragma mark - buttonTap
- (void)buttonTap {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [self.view addSubview:button];
    button.center = self.view.center;
    [button addTarget:self action:@selector(buttonTapAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)buttonTapAction:(UIButton *)button {
    NSLog(@"%s", __func__);
}


#pragma mark - GestureRecognizer
- (void)gestureRecognizer {
    UILabel *lable = [UILabel new];
    lable.userInteractionEnabled = YES;
    lable.text = @"TapGestureRecognizer";
    lable.backgroundColor = [UIColor redColor];
    [lable sizeToFit];
    [self.view addSubview:lable];
    lable.center = CGPointMake(self.view.center.x, self.view.center.y + 100);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHandler:)];
    tap.delegate = self;
    [lable addGestureRecognizer:tap];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    NSLog(@"%s", __func__);
    return YES;
}

- (void)tapGestureHandler:(UITapGestureRecognizer *)tap {
    NSLog(@"%s", __func__);
}


#pragma mark - performSelector
- (void)performSelectorAfterDelay {
    [self performSelector:@selector(performHandler) withObject:nil afterDelay:1.0];
}

- (void)performHandler {
    NSLog(@"%s", __func__);
}



@end
