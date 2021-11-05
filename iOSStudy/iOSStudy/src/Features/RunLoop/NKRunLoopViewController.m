//
//  NKRunLoopViewController.m
//  iOSStudy
//
//  Created by Knox on 2021/5/25.
//

#import "NKRunLoopViewController.h"
#import "NKMonitor.h"




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




@interface NKRunLoopViewController() <UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NKMonitor *monitor;

@end

@implementation NKRunLoopViewController

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"RunLoop";
    
//    [self addRunLoopObserver];
//    [self dispatchMainQueue];
//    [self timer];
//    [self buttonTap];
    [self gestureRecognizer];
//    [self performSelectorAfterDelay];
    
    self.monitor = [NKMonitor new];
    [self.monitor beginMonitor];
    
    [self setupSubView];
}

- (void)setupSubView {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [self.view addSubview:button];
    button.center = self.view.center;
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.tableView];
    CGSize size = UIScreen.mainScreen.bounds.size;
    size.height /= 3;
    self.tableView.frame = CGRectMake(0, 0, size.width, size.height);
}

- (void)buttonAction:(UIButton *)button {
    dispatch_async(dispatch_get_main_queue(), ^{
        int a = 8;
        NSLog(@"调试：大量计算 buttonAction");
        for (long i = 0; i < 999999999; i++) {
            a = a + 1;
        }
        NSLog(@"调试：大量计算结束");
    });
}

- (void)addRunLoopObserver {
    CFRunLoopRef runloopRef = CFRunLoopGetMain();
    CFRunLoopObserverRef observer = CFRunLoopObserverCreate(kCFAllocatorDefault,
                                                            kCFRunLoopAllActivities,
                                                            YES, 0,
                                                            runLoopObserverCallback, nil);
    CFRunLoopAddObserver(runloopRef, observer, kCFRunLoopCommonModes);
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
    NSLog(@"%s, %@", __func__, NKRunLoopActivityMonitor.activityText);
    return YES;
}

- (void)tapGestureHandler:(UITapGestureRecognizer *)tap {
    NSLog(@"%s, %@", __func__, NKRunLoopActivityMonitor.activityText);
}


#pragma mark - performSelector
- (void)performSelectorAfterDelay {
    [self performSelector:@selector(performHandler) withObject:nil afterDelay:1.0];
}

- (void)performHandler {
    NSLog(@"%s", __func__);
}

- (void)dealloc {
    NSLog(@"%s", __func__);
    [self.monitor endMonitor];
}


#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class)];
    cell.textLabel.text = [NSString stringWithFormat:@"row = %ld", indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    int a = 8;
    NSLog(@"调试：大量计算 didSelectRowAtIndexPath");
    for (long i = 0; i < 999999999; i++) {
        a = a + 1;
    }
    NSLog(@"调试：大量计算结束 didSelectRowAtIndexPath");
}


@end
