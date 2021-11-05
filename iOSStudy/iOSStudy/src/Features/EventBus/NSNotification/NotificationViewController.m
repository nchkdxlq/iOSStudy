//
//  NotificationViewController.m
//  iOSStudy
//
//  Created by Knox on 2021/10/12.
//

#import "NotificationViewController.h"


static NSString * const kDidTapSend = @"didTapSend";

@interface NotificationViewController ()

@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didTapSendHandler:) name:kDidTapSend object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kDidTapSend
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification * _Nonnull note) {
        // do something
    }];
}


- (void)didTapSendHandler:(NSNotification *)noti {
    NSLog(@"%@, activityText = %@", noti, NKRunLoopActivityMonitor.activityText);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"begin post activityText = %@", NKRunLoopActivityMonitor.activityText);
    NSNotificationQueue *queue = [NSNotificationQueue defaultQueue];
    for (NSInteger i = 0; i < 5; i++) {
        NSNotification *noti = [NSNotification notificationWithName:kDidTapSend object:nil];
        [queue enqueueNotification:noti postingStyle:NSPostASAP
                      coalesceMask:NSNotificationCoalescingOnName
                          forModes:nil];
    }
    NSLog(@"end   post activityText = %@", NKRunLoopActivityMonitor.activityText);
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
