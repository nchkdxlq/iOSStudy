//
//  NKTapGestureRecognizer.m
//  iOSStudy
//
//  Created by Knox on 2021/9/20.
//

#import "NKTapGestureRecognizer.h"

@implementation NKTapGestureRecognizer

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"%s --- %@", __func__, self.name);
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"%s --- %@", __func__, self.name);
    [super touchesMoved:touches withEvent:event];
}

// NSLog 要写在 super 后面来读取 state
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    NSLog(@"%s --- %@  state: %ld", __func__, self.name, self.state);
}

// NSLog 要写在 super 后面来读取 state
-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    NSLog(@"%s --- %@  state: %ld", __func__, self.name, self.state);
}

@end
