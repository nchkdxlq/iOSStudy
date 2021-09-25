//
//  LayoutViewController.m
//  iOSStudy
//
//  Created by Knox on 2021/9/24.
//

#import "LayoutViewController.h"
#import "LayoutBgView.h"
#import "NSObject+GCD.h"


@interface LayoutViewController()

@property (nonatomic, strong) LayoutBgView *bgView;

@end


@implementation LayoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    LayoutBgView *bgView = [LayoutBgView new];
    [self.view addSubview:bgView];
    UIEdgeInsets padding = UIEdgeInsetsMake(100, 20, 20, 20);
    CGFloat width = CGRectGetWidth(UIScreen.mainScreen.bounds) - padding.left - padding.right;
    CGFloat height = CGRectGetHeight(UIScreen.mainScreen.bounds) - padding.top - padding.bottom;
    bgView.frame = CGRectMake(padding.left, padding.top, width, height);
    self.bgView = bgView;
    
    [self dispatchMainQueueAfterInterval:6 block:^{
//        [self updateFrame];
        [self.bgView setNeedsDisplay];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    NSLog(@"setNeedsLayout begin");
//    [self.bgView setNeedsLayout];
//    [self.bgView layoutIfNeeded];
    NSLog(@"setNeedsLayout end");
    
//    [self.bgView setNeedsDisplay];
}

- (void)updateFrame {
    NSLog(@"%@ --- begin", NSStringFromSelector(_cmd));
    CGRect frame = self.bgView.frame;
    CGRect newFrame = CGRectInset(frame, 10, 10);
    self.bgView.frame = newFrame;
    NSLog(@"%@ --- end", NSStringFromSelector(_cmd));
}


@end
