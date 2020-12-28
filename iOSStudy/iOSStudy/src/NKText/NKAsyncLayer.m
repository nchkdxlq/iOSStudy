//
//  NKAsyncLayer.m
//  iOSStudy
//
//  Created by Knox on 2020/12/27.
//

#import "NKAsyncLayer.h"
#import <UIKit/UIKit.h>

#pragma mark - NKAsyncLayerDisplayTask

@implementation NKAsyncLayerDisplayTask


@end



#pragma mark - NKAsyncLayer

////////////////////////////////////////////////////////////////////////////////////////////////

@interface NKAsyncLayer ()


@end


@implementation NKAsyncLayer


- (instancetype)init {
    self = [super init];
    if (self) {
        self.contentsScale = UIScreen.mainScreen.scale;
    }
    return self;
}


- (void)setNeedsDisplay {
    [self _cancelAsyncDisplay];
    [super setNeedsDisplay];
}

- (void)_cancelAsyncDisplay {
    
}

- (void)display {
    [self _displayAsync:_displaysAsynchronously];
}


- (void)_displayAsync:(BOOL)async {
    id<NKAsyncLayerDelegate> delegate = (id<NKAsyncLayerDelegate>)self.delegate;
    NKAsyncLayerDisplayTask *task = [delegate newAsyncDisplayTask];
    
    // 如果绘制操作block为空, 清空内容
    if (!task.display) {
        if (task.willDisplay) task.willDisplay(self);
        self.contents = nil;
        if (task.didDisplay) task.didDisplay(self, YES);
        return;
    }
    
    
    if (_displaysAsynchronously) {
        
    } else {
        if (task.willDisplay) task.willDisplay(self);
        
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, self.contentsScale);
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        if (self.opaque) { // 为什么要这么处理, 没搞懂 [?]
            CGSize size = self.bounds.size;
            size.width *= self.contentsScale;
            size.height *= self.contentsScale;
            CGContextSaveGState(context); {
                if (!self.backgroundColor || CGColorGetAlpha(self.backgroundColor) < 1) {
                    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
                    CGContextAddRect(context, CGRectMake(0, 0, size.width, size.height));
                    CGContextFillPath(context);
                }
                if (self.backgroundColor) {
                    CGContextSetFillColorWithColor(context, self.backgroundColor);
                    CGContextAddRect(context, CGRectMake(0, 0, size.width, size.height));
                    CGContextFillPath(context);
                }
            } CGContextRestoreGState(context);
        }
        task.display(context, self.bounds.size, ^{return NO;});
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self.contents = (__bridge id)(image.CGImage);
        if (task.didDisplay) task.didDisplay(self, YES);
    }
}

@end
