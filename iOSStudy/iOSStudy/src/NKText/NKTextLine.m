//
//  NKTextLine.m
//  iOSStudy
//
//  Created by Knox on 2020/12/28.
//

#import "NKTextLine.h"

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
    if (_CTLine) CFRetain(_CTLine);
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
    
}


@end
