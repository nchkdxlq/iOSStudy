//
//  NKTextContainer.m
//  iOSStudy
//
//  Created by Knox on 2020/12/27.
//

#import "NKTextContainer.h"


#define Getter(...) \
dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER); \
__VA_ARGS__; \
dispatch_semaphore_signal(_lock);


#define Setter(...) \
if (_readonly) { \
@throw [NSException exceptionWithName:NSInternalInconsistencyException \
reason:@"Cannot change the property of the 'container' in 'YYTextLayout'." userInfo:nil]; \
return; \
} \
dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER); \
__VA_ARGS__; \
dispatch_semaphore_signal(_lock);

@implementation NKTextContainer {
    
    BOOL _readonly; ///< used only in NKTextLayout.implementation
    UIBezierPath *_path;
    CGFloat _pathLineWidth;
    BOOL _verticalForm;
    dispatch_semaphore_t _lock;
}

+ (instancetype)containerWithSize:(CGSize)size {
    return [self containerWithSize:size insets:UIEdgeInsetsZero];
}

+ (instancetype)containerWithSize:(CGSize)size insets:(UIEdgeInsets)insets {
    NKTextContainer *one = [NKTextContainer new];
    one.size = size;
    one.insets = insets;
    return one;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _lock = dispatch_semaphore_create(1);
    }
    return self;
}

- (UIBezierPath *)path {
    Getter(UIBezierPath *path = _path) return path;
}

- (void)setPath:(UIBezierPath *)path {
    Setter(
           _path = path.copy;
           if (_path) {
               CGRect bounds = _path.bounds;
               CGSize size = bounds.size;
               UIEdgeInsets insets = UIEdgeInsetsZero;
               if (bounds.origin.x < 0) size.width += bounds.origin.x;
               if (bounds.origin.x > 0) insets.left = bounds.origin.x;
               if (bounds.origin.y < 0) size.height += bounds.origin.y;
               if (bounds.origin.y > 0) insets.top = bounds.origin.y;
               _size = size;
               _insets = insets;
           }
    );
}


- (CGFloat)pathLineWidth {
    Getter(CGFloat width = _pathLineWidth) return width;
}

- (void)setPathLineWidth:(CGFloat)pathLineWidth {
    Setter(_pathLineWidth = pathLineWidth);
}

- (BOOL)isVerticalForm {
    Getter(BOOL v = _verticalForm) return v;
}

- (void)setVerticalForm:(BOOL)verticalForm {
    Setter(_verticalForm = verticalForm);
}



- (id)copyWithZone:(NSZone *)zone {
    NKTextContainer *ins = [NKTextContainer new];
    ins.size = self.size;
    ins.insets = self.insets;
    return ins;
}


@end
