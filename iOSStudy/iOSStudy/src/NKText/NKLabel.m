//
//  NKLabel.m
//  iOSStudy
//
//  Created by Knox on 2020/12/27.
//

#import "NKLabel.h"
#import "NKAsyncLayer.h"

@interface NKLabel () <NKAsyncLayerDelegate>

@end


@implementation NKLabel {
    NSMutableAttributedString *_innerText;
}

+ (Class)layerClass {
    return [NKAsyncLayer class];
}


- (void)setAttributedText:(NSAttributedString *)attributedText {
    if (attributedText.length > 0) {
        _innerText = attributedText.mutableCopy;
    } else {
        _innerText = [NSMutableAttributedString new];
    }
    
    [self intrinsicContentSize];
}


#pragma mark - NKAsyncLayerDelegate

- (NKAsyncLayerDisplayTask *)newAsyncDisplayTask {
    NKAsyncLayerDisplayTask *task = [NKAsyncLayerDisplayTask new];
    
    task.display = ^(CGContextRef _Nonnull context, CGSize size, BOOL (^ _Nonnull isCancelled)(void)) {
        
    };
    
    return task;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
