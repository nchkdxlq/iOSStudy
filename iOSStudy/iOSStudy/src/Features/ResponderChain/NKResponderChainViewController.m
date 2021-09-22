//
//  NKResponderChainViewController.m
//  iOSStudy
//
//  Created by Knox on 2021/9/20.
//

#import "NKResponderChainViewController.h"
#import "NKViewA.h"


@implementation NKResponderChainViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIEdgeInsets padding = UIEdgeInsetsMake(30, 30, 30, 30);
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    
    NKViewA *viewA = [[NKViewA alloc] init];
    [self.view addSubview:viewA];
    viewA.frame = CGRectMake(padding.left, 120, width - padding.left-padding.right, 550);
    
    NKViewB *viewB = [[NKViewB alloc] init];
    [viewA addSubview:viewB];
    viewB.frame = CGRectMake(padding.left, padding.top, CGRectGetWidth(viewA.frame) - padding.left - padding.right, 150);
    

    NKViewC *viewC = [[NKViewC alloc] init];
    [viewA addSubview:viewC];
    viewC.frame = CGRectMake(padding.left, CGRectGetMaxY(viewB.frame) + 30, CGRectGetWidth(viewB.frame), 300);
    
    
    NKViewD *viewD = [[NKViewD alloc] init];
    [viewC addSubview:viewD];
    viewD.frame = CGRectMake(padding.left, padding.top, CGRectGetWidth(viewC.frame) - padding.left - padding.right, 100);
    
    NKViewE *viewE = [[NKViewE alloc] init];
    [viewC addSubview:viewE];
    viewE.frame = CGRectMake(padding.left, CGRectGetMaxY(viewD.frame) + 30, CGRectGetWidth(viewD.frame), 100);
    
    
    NKButton *button = [NKButton buttonWithType:UIButtonTypeContactAdd];
    [viewE addSubview:button];
    button.center = CGPointMake(viewE.bounds.size.width/2, viewE.bounds.size.height/2);
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)buttonAction:(UIButton *)button {
    NSLog(@"buttonAction");
}

@end
