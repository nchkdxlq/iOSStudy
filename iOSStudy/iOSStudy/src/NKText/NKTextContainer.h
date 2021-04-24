//
//  NKTextContainer.h
//  iOSStudy
//
//  Created by Knox on 2020/12/27.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGGeometry.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NKTextContainer : NSObject <NSCopying>


@property CGSize size;

@property UIEdgeInsets insets;

/// Custom constrained path. Set this property to ignore `size` and `insets`. Default is nil.
@property (nullable, copy) UIBezierPath *path;

/// Maximum number of rows, 0 means no limit. Default is 0.
@property NSUInteger maximumNumberOfRows;

/// Path line width. Default is 0;
@property CGFloat pathLineWidth;

/// Whether the text is vertical form (may used for CJK text layout). Default is NO.
@property (getter=isVerticalForm) BOOL verticalForm;

+ (instancetype)containerWithSize:(CGSize)size;

+ (instancetype)containerWithSize:(CGSize)size insets:(UIEdgeInsets)insets;

@end

NS_ASSUME_NONNULL_END
