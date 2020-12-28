//
//  NKTextLayout.h
//  iOSStudy
//
//  Created by Knox on 2020/12/27.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGGeometry.h>

NS_ASSUME_NONNULL_BEGIN

@class NKTextContainer;

@interface NKTextLayout : NSObject

@property (nonatomic, strong, readonly) NKTextContainer *container;
@property (nonatomic, strong, readonly) NSAttributedString *text;
@property (nonatomic, assign, readonly) NSRange range;


+ (nullable instancetype)layoutWithContainerSize:(CGSize)size text:(NSAttributedString *)text;

+ (nullable instancetype)layoutWithContainer:(NKTextContainer *)container text:(NSAttributedString *)text;

@end

NS_ASSUME_NONNULL_END
