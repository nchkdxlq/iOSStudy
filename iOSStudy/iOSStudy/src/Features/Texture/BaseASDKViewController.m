//
//  BaseASDKViewController.m
//  iOSStudy
//
//  Created by Knox on 2021/12/11.
//

#import "BaseASDKViewController.h"

@implementation BaseASDKViewController

- (instancetype)init {
    self = [super initWithNode:[self displayNode]];
    if (self) {
        self.node.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (ASDisplayNode *)displayNode {
    return [ASDisplayNode new];
}

- (void)dealloc {
    NSLog(@"<dealloc> %@", self);
}

@end
