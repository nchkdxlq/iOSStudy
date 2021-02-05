//
//  NKTextLine.m
//  iOSStudy
//
//  Created by Knox on 2020/12/28.
//

#import "NKTextLine.h"
#import "NKTextMacro.h"
#import "NKTextAttribute.h"

@implementation NKTextLine {
    CGFloat _firstGlyphPos; // first glyph position for baseline, typically 0.
}

+ (instancetype)lineWithCTLine:(CTLineRef)CTLine position:(CGPoint)position vertical:(BOOL)isVertical {
    if (!CTLine) return nil;
    NKTextLine *line = [self new];
    line->_position = position;
    line->_vertical = isVertical;
    [line setCTLine:CTLine];
    return line;
}

- (void)dealloc {
    if (_CTLine) CFRelease(_CTLine);
}

- (void)setCTLine:(CTLineRef _Nonnull)CTLine {
    if (_CTLine == CTLine) return;
    
    if (CTLine) CFRetain(CTLine);
    if (_CTLine) CFRelease(_CTLine);
    _CTLine = CTLine;
    
    if (CTLine) {
        _lineWidth = CTLineGetTypographicBounds(CTLine, &_ascent, &_descent, &_leading);
        CFRange cfRange = CTLineGetStringRange(CTLine);
        _range = NSMakeRange(cfRange.location, cfRange.length);
        if (CTLineGetGlyphCount(CTLine) > 0) {
            CFArrayRef runs = CTLineGetGlyphRuns(CTLine);
            CTRunRef run = CFArrayGetValueAtIndex(runs, 0);
            CGPoint pos;
            CTRunGetPositions(run, CFRangeMake(0, 1), &pos);
            _firstGlyphPos = pos.x;
        } else {
            _firstGlyphPos = 0;
        }
        // 一行尾部的空白部分
        _trailingWhitespaceWidth = CTLineGetTrailingWhitespaceWidth(CTLine);
    } else {
        _lineWidth = _ascent = _descent = _leading = _firstGlyphPos = _trailingWhitespaceWidth = 0;
        _range = NSMakeRange(0, 0);
    }
    [self realodBounds];
}


- (void)realodBounds {
    if (_vertical) {
        
    } else {
        _bounds = CGRectMake(_position.x, _position.y - _ascent, _lineWidth, _ascent + _descent);
        _bounds.origin.x += _firstGlyphPos;
    }
    
    _attachments = nil;
    _attachmentRects = nil;
    _attachmentRanges = nil;
    if (!_CTLine) return;
    CFArrayRef runs = CTLineGetGlyphRuns(_CTLine);
    NSUInteger runCount = CFArrayGetCount(runs);
    if (runCount == 0) return;
    
    NSMutableArray<NKTextAttachment *> *attachments = [NSMutableArray new];
    NSMutableArray<NSValue *> *attachmentRanges = [NSMutableArray new];
    NSMutableArray<NSValue *> *attachmentRects = [NSMutableArray new];
    
    for (NSUInteger i = 0; i < runCount; i++) {
        CTRunRef run = CFArrayGetValueAtIndex(runs, i);
        CFIndex glyphCount = CTRunGetGlyphCount(run);
        if (glyphCount == 0) continue;
        NSDictionary *attrs = (id)CTRunGetAttributes(run);
        NKTextAttachment *attachment = attrs[NKTextAttachmentAttributeName];
        if (attachment) {
            CGPoint runPosition = CGPointZero;
            // 获取run的坐标(run相对于当前line的坐标)
            CTRunGetPositions(run, CFRangeMake(0, 1), &runPosition);
            
            CGFloat ascent, descent, leading, runWidth;
            CGRect runTypoBounds = CGRectZero;
            runWidth = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, &leading);
            
            if (_vertical) {
                
            } else {
                // 把相对line的坐标转换为相对于CTFrame的坐标
                runPosition.x += _position.x;
                runPosition.y += _position.y;
                runTypoBounds = CGRectMake(runPosition.x, runPosition.y - ascent, runWidth, ascent + descent);
            }
            
            NSRange runRange = NKNSRangeFromCFRange(CTRunGetStringRange(run));
            [attachments addObject:attachment];
            [attachmentRanges addObject:[NSValue valueWithRange:runRange]];
            [attachmentRects addObject:[NSValue valueWithCGRect:runTypoBounds]];
        }
    }
    
    _attachments = attachments.count > 0 ? attachments.copy : nil;
    _attachmentRects = attachmentRects.count > 0 ? attachmentRects : nil;
    _attachmentRanges = attachmentRanges.count > 0 ? attachmentRanges.copy : nil;
}

- (CGFloat)width {
    return CGRectGetWidth(_bounds);
}

- (CGFloat)height {
    return CGRectGetHeight(_bounds);
}

- (CGFloat)top {
    return CGRectGetMinY(_bounds);
}

- (CGFloat)bottom {
    return CGRectGetMaxY(_bounds);
}

- (CGFloat)left {
    return CGRectGetMinY(_bounds);
}

- (CGFloat)right {
    return CGRectGetMaxX(_bounds);
}

- (CGSize)size {
    return _bounds.size;
}

@end
