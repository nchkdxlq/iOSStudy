//
//  LayoutBgView.m
//  iOSStudy
//
//  Created by Knox on 2021/9/24.
//

#import "LayoutBgView.h"
#import "LayoutLayer.h"

@implementation LayoutBgView

+ (Class)layerClass {
    return LayoutLayer.class;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.grayColor;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    NSLog(@"%s", __func__);
}

- (void)drawRect:(CGRect)rect {
    NSLog(@"%s", __func__);
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    [super drawLayer:layer inContext:ctx];
}

@end
