//
//  NKTextLayout.m
//  iOSStudy
//
//  Created by Knox on 2020/12/27.
//

#import "NKTextLayout.h"

#import "NKTextContainer.h"
#import "NKTextMacro.h"
#import "NKTextLine.h"
#import "NKCGUtilities.h"


typedef struct {
    CGFloat head;
    CGFloat foot;
} NKRowEdge;


@interface NKTextLayout ()

@property (nonatomic, strong, readwrite) NKTextContainer *container;
@property (nonatomic, strong, readwrite) NSAttributedString *text;
@property (nonatomic, assign, readwrite) NSRange range;

@end

@implementation NKTextLayout {
    CTFramesetterRef _frameSetter;
    CTFrameRef _frame;
}

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
    BOOL rowMaySeparated = NO;
    
    CTFramesetterRef ctSetter = NULL;
    CTFrameRef ctFrame = NULL;
    NSMutableDictionary *frameAttrs = nil;
    CFArrayRef ctLines = nil;
    CGPoint *lineOrigins = NULL;
    CFIndex lineCount = 0;
    NSMutableArray<NKTextLine *> *lines = nil;
    BOOL needTruncation = NO;
    
    // 文本显示的最大行数
    NSUInteger maximumNumberOfRows = 0;
    
    NKRowEdge *lineRowsEdge = NULL;
    NSUInteger *lineRowsIndex = NULL;
    
    container = container.copy;
    text = text.copy;
    if (container == nil || text == nil) return nil;
    if (range.location + range.length > text.length) return nil;
    
//    maximumNumberOfRows = container
    
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
        // 获取每一行的baseline原点相对于ctFrame的坐标
        CTFrameGetLineOrigins(ctFrame, CFRangeMake(0, lineCount), lineOrigins);
    }
    
    CGRect textBoundingRect = CGRectZero;
    CGSize textBoundingSize = CGSizeZero;
    NSInteger rowIdx = -1;
    NSUInteger rowCount = 0;
    CGRect lastRect = CGRectMake(0, -FLT_MAX, 0, 0);
    CGPoint lastPosition = CGPointMake(0, -FLT_MAX);
    CGFloat cgPathBoxMaxY = cgPathBox.size.height + cgPathBox.origin.y;
    NSUInteger lineCurrentIdx = 0;
    if (lineCount > 0) lines = [NSMutableArray new];
    
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
        
        NKTextLine *line = [NKTextLine lineWithCTLine:ctLine position:position vertical:NO];
        CGRect rect = line.bounds;
        
        BOOL newRow = YES;
#if 0
        // 没看懂, 先不处理, 认为一个line就是新的一行
        if (rowMaySeparated && position.x != lastPosition.x) {
            if (rect.size.height > lastRect.size.height) {
                if (rect.origin.y > lastPosition.y && lastPosition.y < rect.origin.y + rect.size.height) newRow = NO;
            } else {
                if (lastRect.origin.y < position.y && position.y < lastRect.origin.y + lastRect.size.height) newRow = NO;
            }
        }
#endif
        if (newRow) rowIdx++;
        lastRect = rect;
        lastPosition = position;
        
        line.row = rowIdx;
        line.index = lineCurrentIdx;
        [lines addObject:line];
        lineCurrentIdx++;
        rowCount = rowIdx + 1;
        
        if (i == 0) {
            textBoundingRect = rect;
        } else {
            if (maximumNumberOfRows == 0 || rowIdx < maximumNumberOfRows) {
                textBoundingRect = CGRectUnion(textBoundingRect, rect);
            }
        }
    }
    
    
    if (rowCount > 0) {
        if (maximumNumberOfRows > 0) {
            // 限制了最大行数，并且文本内容的行数大于最大行数, 需要删除多余的CTLine
            if (rowCount > maximumNumberOfRows) {
                needTruncation = YES;
                rowCount = maximumNumberOfRows;
                do {
                    NKTextLine *line = lines.lastObject;
                    if (!line) break;
                    // 数组从后往前删除, 直到数组的小于最大行数退出循环
                    if (line.row < rowCount) break;
                    [lines removeLastObject];
                } while (1);
            }
        }
        
        NKTextLine *lastLine = lines.lastObject;
        if (!needTruncation && lastLine.range.location + lastLine.range.length < text.length) {
            needTruncation = YES;
        }
        
        lineRowsEdge = calloc(rowCount, sizeof(NKRowEdge));
        lineRowsIndex = calloc(rowCount, sizeof(NSUInteger));
        NSInteger lastRowIdx = -1;
        CGFloat lastHead = 0;
        CGFloat lastFoot = 0;
        
        for (NSInteger i = 0, max = lines.count; i < max; i++) {
            NKTextLine *line = lines[i];
            CGRect rect = line.bounds;
            
        }
        
        
        { // calculate bounding size
            CGRect rect = textBoundingRect;
            if (container.path) {
                // todo
            } else {
                rect = UIEdgeInsetsInsetRect(rect, UIEdgeInsetsInvert(container.insets));
            }
            rect = CGRectStandardize(rect);
            CGSize size = rect.size;
            if (container.verticalForm) {
                // todo
            } else {
                size.width += rect.origin.x;
            }
            size.height += rect.origin.y;
            if (size.width < 0) size.width = 0;
            if (size.height < 0) size.height = 0;
            size.width = ceil(size.width);
            size.height = ceil(size.height);
            textBoundingSize = size;
        }
        
    }
    
    layout.frameSetter = ctSetter;
    layout.frame = ctFrame;
    
    return layout;
}


- (void)setFrameSetter:(CTFramesetterRef _Nonnull)frameSetter {
    if (_frameSetter == frameSetter) return;
    
    if (frameSetter) CFRetain(frameSetter);
    if (_frameSetter) CFRelease(_frameSetter);
    _frameSetter = frameSetter;
}


- (void)setFrame:(CTFrameRef _Nonnull)frame {
    if (_frame == frame) return;
    
    if (frame) CFRetain(frame);
    if (_frame) CFRelease(_frame);
    _frame = frame;
}


- (void)dealloc {
    if (_frameSetter) CFRelease(_frameSetter);
    if (_frame) CFRelease(_frame);
}

@end
