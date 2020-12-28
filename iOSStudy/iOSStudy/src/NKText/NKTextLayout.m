//
//  NKTextLayout.m
//  iOSStudy
//
//  Created by Knox on 2020/12/27.
//

#import "NKTextLayout.h"
#import <CoreText/CoreText.h>


#import "NKTextContainer.h"
#import "NKTextMacro.h"


@interface NKTextLayout ()

@property (nonatomic, strong, readwrite) NKTextContainer *container;
@property (nonatomic, strong, readwrite) NSAttributedString *text;
@property (nonatomic, assign, readwrite) NSRange range;

@end

@implementation NKTextLayout

+ (instancetype)layoutWithContainerSize:(CGSize)size text:(NSAttributedString *)text {
    NKTextContainer *container = [NKTextContainer containerWithSize:size];
    return [self layoutWithContainer:container text:text];
}


+ (instancetype)layoutWithContainer:(NKTextContainer *)container text:(NSAttributedString *)text {
    return [self layoutWithContainer:container text:text range:NSMakeRange(0, text.length)];
}

+ (instancetype)layoutWithContainer:(NKTextContainer *)container text:(NSAttributedString *)text range:(NSRange)range {
    NKTextLayout *layout = nil;
    CGPathRef cgPath = nil;
    CGRect cgPathBox = {0};
    
    CTFramesetterRef ctSetter = NULL;
    CTFrameRef ctFrame = NULL;
    NSMutableDictionary *frameAttrs = nil;
    CFArrayRef ctLines = nil;
    CGPoint *lineOrigins = NULL;
    CFIndex lineCount = 0;
    
    container = container.copy;
    text = text.copy;
    if (container == nil || text == nil) return nil;
    if (range.location + range.length > text.length) return nil;
    
    layout = [NKTextLayout new];
    layout.text = text;
    layout.container = container;
    layout.range = range;
    
    CGRect rect = (CGRect) {CGPointZero, container.size };
    rect = CGRectStandardize(rect);
    cgPathBox = rect;
    rect = CGRectApplyAffineTransform(rect, CGAffineTransformMakeScale(1, -1));
    cgPath = CGPathCreateWithRect(rect, NULL); // let CGPathIsRect() returns true
    
    
    frameAttrs = [NSMutableDictionary new];
    ctSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)text);
    ctFrame = CTFramesetterCreateFrame(ctSetter, NKCFRangeFromNSRange(range), cgPath, (CFDictionaryRef)frameAttrs);
    
    ctLines = CTFrameGetLines(ctFrame);
    lineCount = CFArrayGetCount(ctLines);
    if (lineCount > 0) {
        lineOrigins = malloc(lineCount * sizeof(CGPoint));
        CTFrameGetLineOrigins(ctFrame, CFRangeMake(0, lineCount), lineOrigins);
    }
    
    CGRect textBoundingRect = CGRectZero;
    CGSize textBoundingSize = CGSizeZero;
    NSInteger rowIdx = -1;
    NSUInteger rowCount = 0;
    CGRect lastRect = CGRectMake(0, -FLT_MAX, 0, 0);
    CGPoint lastPosition = CGPointMake(0, -FLT_MAX);
    CGFloat cgPathBoxMaxY = cgPathBox.size.height + cgPathBox.origin.y;
    
    for (CFIndex i = 0; i < lineCount; i++) {
        CTLineRef ctLine = CFArrayGetValueAtIndex(ctLines, i);
        CFArrayRef ctRuns = CTLineGetGlyphRuns(ctLine);
        if (!ctRuns || CFArrayGetCount(ctRuns) == 0) continue;
        
        // CoreText coordinate system
        CGPoint ctLineOrigin = lineOrigins[i];
        
        // UIKit coordinate system, CoreText坐标转换为UIKIt坐标.
        CGPoint position;
        position.x = cgPathBox.origin.x + ctLineOrigin.x;
        position.y = cgPathBoxMaxY - ctLineOrigin.y;
        NSLog(@"ctLineOrigin = %@, position = %@", NSStringFromCGPoint(ctLineOrigin), NSStringFromCGPoint(position));
    }
    
    
    return nil;
}



@end
