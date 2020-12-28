//
//  NKTextMacro.h
//  iOSStudy
//
//  Created by Knox on 2020/12/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

static inline CFRange NKCFRangeFromNSRange(NSRange range) {
    return CFRangeMake(range.location, range.length);
}

@interface NKTextMacro : NSObject

@end

NS_ASSUME_NONNULL_END
