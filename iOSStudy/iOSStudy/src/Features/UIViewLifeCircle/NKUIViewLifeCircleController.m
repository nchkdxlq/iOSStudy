//
//  NKUIViewLifeCircleController.m
//  iOSStudy
//
//  Created by Knox on 2021/9/2.
//

#import "NKUIViewLifeCircleController.h"


@interface NKView : UIView

@end


@implementation NKView

- (void)willMoveToSuperview:(UIView *)newSuperview {
    NSLog(@"%s", __func__);
    NSLog(@"superview = %p,  window = %p", self.superview, self.window);
}


- (void)didMoveToSuperview {
    NSLog(@"%s", __func__);
    NSLog(@"superview = %p,  window = %p", self.superview, self.window);
}


- (void)willMoveToWindow:(UIWindow *)newWindow {
    NSLog(@"%s", __func__);
    NSLog(@"superview = %p,  window = %p", self.superview, self.window);
}

- (void)didMoveToWindow {
    NSLog(@"%s", __func__);
    NSLog(@"superview = %p,  window = %p", self.superview, self.window);
}


- (void)layoutSubviews {
    [super layoutSubviews];
    NSLog(@"%s %p", __func__, self);
}


@end




@interface NKUIViewLifeCircleController ()

@property (nonatomic, strong) NKView *testView;

@end

@implementation NKUIViewLifeCircleController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    NKView *testView = [[NKView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    testView.backgroundColor = UIColor.lightGrayColor;
    [self.view addSubview:testView];
    self.testView = testView;
    NSLog(@"%@  %@", self.view, NSStringFromSelector(_cmd));
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"%@  %@", NSStringFromCGRect(self.view.frame), NSStringFromSelector(_cmd));
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"%@  %@", NSStringFromCGRect(self.view.frame), NSStringFromSelector(_cmd));
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"%@  %@", NSStringFromCGRect(self.view.frame), NSStringFromSelector(_cmd));
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"%@  %@", NSStringFromCGRect(self.view.frame), NSStringFromSelector(_cmd));
}


- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    NSLog(@"%@  %@", NSStringFromCGRect(self.view.frame), NSStringFromSelector(_cmd));
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    NSLog(@"%@  %@", NSStringFromCGRect(self.view.frame), NSStringFromSelector(_cmd));
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    NKView *testView = [[NKView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    testView.backgroundColor = UIColor.redColor;
    [self.testView addSubview:testView];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    [self.testView setNeedsLayout];
    [self.testView layoutIfNeeded];
}


@end
