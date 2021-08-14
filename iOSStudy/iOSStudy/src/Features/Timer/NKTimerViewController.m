//
//  NKTimerViewController.m
//  iOSStudy
//
//  Created by Knox on 2021/6/5.
//

#import "NKTimerViewController.h"
#import "NKWeakProxy.h"

@interface NKTimerViewController()

@property (nonatomic, strong) CADisplayLink *link;

@end



@implementation NKTimerViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self testLink];
}

- (void)testLink {
    NKWeakProxy *proxy = [NKWeakProxy proxyWithTarget:self];
    self.link = [CADisplayLink displayLinkWithTarget:proxy selector:@selector(linkAction:)];
    [self.link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)linkAction:(CADisplayLink *)link {
    NSLog(@"%s", __func__);
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSNumber *num1 = [NSNumber numberWithLong:0xff];
    NSNumber *num2 = [NSNumber numberWithUnsignedLongLong:0xffffffffffffff];
    NSLog(@"num1 = %p, num2 = %p", num1, num2);
    
    NSString *str1 = [NSString stringWithFormat:@"123456789"];
    NSLog(@"str1 = %@", str1.class); // NSTaggedPointerString
}

- (void)dealloc {
    NSLog(@"%s", __func__);
    [self.link invalidate];
}

@end
