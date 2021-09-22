//
//  NKViewA.m
//  iOSStudy
//
//  Created by Knox on 2021/9/20.
//

#import "NKViewA.h"
#import "NKTapGestureRecognizer.h"

@interface NKViewBase () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) NKTapGestureRecognizer *tap;

- (void)singleTapHandler:(NKTapGestureRecognizer *)tap;

- (NSString *)className;

@end

@implementation NKViewBase

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *label = [UILabel new];
        [self addSubview:label];
        label.text = @"BaseView";
        [label sizeToFit];
        CGRect rect = label.frame;
        rect.origin.x = 10;
        rect.origin.y = 5;
        label.frame = rect;
        _textLabel = label;
        
        NKTapGestureRecognizer *tap = [[NKTapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapHandler:)];
        tap.name = [NSString stringWithFormat:@"%@ Tap", self.className];
        [self addGestureRecognizer:tap];
        tap.delegate = self;
        self.tap = tap;
    }
    return self;
}

- (NSString *)className {
    return NSStringFromClass(self.class);
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"begin --- [%@ %@]", self.className, NSStringFromSelector(_cmd));
    [super touchesBegan:touches withEvent:event];
    NSLog(@"end   --- [%@ %@]", self.className, NSStringFromSelector(_cmd));
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"begin --- [%@ %@]", self.className, NSStringFromSelector(_cmd));
    [super touchesMoved:touches withEvent:event];
    NSLog(@"end   --- [%@ %@]", self.className, NSStringFromSelector(_cmd));
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"begin --- [%@ %@]", self.className, NSStringFromSelector(_cmd));
    [super touchesEnded:touches withEvent:event];
    NSLog(@"end   --- [%@ %@]", self.className, NSStringFromSelector(_cmd));
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"begin --- [%@ %@]", self.className, NSStringFromSelector(_cmd));
    [super touchesCancelled:touches withEvent:event];
    NSLog(@"end   --- [%@ %@]", self.className, NSStringFromSelector(_cmd));
}

- (void)singleTapHandler:(NKTapGestureRecognizer *)tap {
    NSLog(@"%@ --- singleTapHandler: %@ ", self.className, tap.name);
}


//- (void)requireGestureRecognizerToFail:(UIGestureRecognizer *)otherGestureRecognizer {
//
//}
//
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    return NO;
//}
//
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer  {
//    return NO;
//}
//
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveEvent:(UIEvent *)event {
//    return YES;
//}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    NSLog(@"shouldReceiveTouch %@ -- %@", self.className, gestureRecognizer.name);
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    NSLog(@"gestureRecognizerShouldBegin %@ -- %@", self.className, gestureRecognizer.name);
//    return self.tap == gestureRecognizer;
    return YES;
}

// Simultaneously 同时，子View的手势会通过第二个参数传递过来
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    NSLog(@"%@ --- gestureRecognizer: %@ otherGestureRecognizer: %@ ---", self.className, gestureRecognizer.name, otherGestureRecognizer.name);
    return NO;
}


@end

#pragma mark - NKViewA

@implementation NKViewA

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.lightGrayColor;
        self.textLabel.text = @"ViewA";
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"ViewA <%p>", self];
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    NSLog(@"begin --- [%@ %@]", self.className, NSStringFromSelector(_cmd));
    UIView *targetView = [super hitTest:point withEvent:event];
    NSLog(@"end   --- [%@ %@],  targetView = %@", self.className, NSStringFromSelector(_cmd), targetView);
    return targetView;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    NSLog(@"begin --- [%@ %@]", self.className, NSStringFromSelector(_cmd));
    BOOL ret = [super pointInside:point withEvent:event];
    NSLog(@"end   --- [%@ %@],  isInside = %d", self.className, NSStringFromSelector(_cmd), ret);
    return ret;
}


@end



#pragma mark - NKViewB

@implementation NKViewB

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.purpleColor;
        self.textLabel.text = @"ViewB";
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"ViewB <%p>", self];
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    NSLog(@"begin --- [%@ %@]", self.className, NSStringFromSelector(_cmd));
    UIView *targetView = [super hitTest:point withEvent:event];
    NSLog(@"end   --- [%@ %@],  targetView = %@", self.className, NSStringFromSelector(_cmd), targetView);
    return targetView;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    NSLog(@"begin --- [%@ %@]", self.className, NSStringFromSelector(_cmd));
    BOOL ret = [super pointInside:point withEvent:event];
    NSLog(@"end   --- [%@ %@],  isInside = %d", self.className, NSStringFromSelector(_cmd), ret);
    return ret;
}

@end



#pragma mark - NKViewC

@implementation NKViewC

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.blueColor;
        self.textLabel.text = @"ViewC";
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"ViewC <%p>", self];
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    NSLog(@"begin --- [%@ %@]", self.className, NSStringFromSelector(_cmd));
    UIView *targetView = [super hitTest:point withEvent:event];
    NSLog(@"end   --- [%@ %@],  targetView = %@", self.className, NSStringFromSelector(_cmd), targetView);
    return targetView;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    NSLog(@"begin --- [%@ %@]", self.className, NSStringFromSelector(_cmd));
    BOOL ret = [super pointInside:point withEvent:event];
    NSLog(@"end   --- [%@ %@],  isInside = %d", self.className, NSStringFromSelector(_cmd), ret);
    return ret;
}


@end

#pragma mark - NKViewD

@implementation NKViewD

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.brownColor;
        self.textLabel.text = @"ViewD";
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"ViewD <%p>", self];
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    NSLog(@"begin --- [%@ %@]", self.className, NSStringFromSelector(_cmd));
    UIView *targetView = [super hitTest:point withEvent:event];
    NSLog(@"end   --- [%@ %@],  targetView = %@", self.className, NSStringFromSelector(_cmd), targetView);
    return targetView;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    NSLog(@"begin --- [%@ %@]", self.className, NSStringFromSelector(_cmd));
    BOOL ret = [super pointInside:point withEvent:event];
    NSLog(@"end   --- [%@ %@],  isInside = %d", self.className, NSStringFromSelector(_cmd), ret);
    return ret;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"begin --- [%@ %@]", self.className, NSStringFromSelector(_cmd));
//    [super touchesBegan:touches withEvent:event];
//    [self.nextResponder touchesBegan:touches withEvent:event];
    NSLog(@"end   --- [%@ %@]", self.className, NSStringFromSelector(_cmd));
}

@end



#pragma mark - NKViewE

@implementation NKViewE

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.orangeColor;
        self.textLabel.text = @"ViewE";
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"ViewE <%p>", self];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    NSLog(@"begin --- [%@ %@]", self.className, NSStringFromSelector(_cmd));
    UIView *targetView = [super hitTest:point withEvent:event];
    NSLog(@"end   --- [%@ %@],  targetView = %@", self.className, NSStringFromSelector(_cmd), targetView);
    return targetView;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    NSLog(@"begin --- [%@ %@]", self.className, NSStringFromSelector(_cmd));
    BOOL ret = [super pointInside:point withEvent:event];
    NSLog(@"end   --- [%@ %@],  isInside = %d", self.className, NSStringFromSelector(_cmd), ret);
    return ret;
}

@end



@implementation NKButton

- (NSString *)className {
    return NSStringFromClass(self.class);
}

- (NSString *)description {
    return [NSString stringWithFormat:@"NKButton <%p>", self];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    NSLog(@"begin --- [%@ %@]", self.className, NSStringFromSelector(_cmd));
    UIView *targetView = [super hitTest:point withEvent:event];
    NSLog(@"end   --- [%@ %@],  targetView = %@", self.className, NSStringFromSelector(_cmd), targetView);
    return targetView;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    NSLog(@"begin --- [%@ %@]", self.className, NSStringFromSelector(_cmd));
    BOOL ret = [super pointInside:point withEvent:event];
    NSLog(@"end   --- [%@ %@],  isInside = %d", self.className, NSStringFromSelector(_cmd), ret);
    return ret;
}

@end


