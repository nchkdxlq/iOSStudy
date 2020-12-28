//
//  NKTextContainer.h
//  iOSStudy
//
//  Created by Knox on 2020/12/27.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGGeometry.h>
#import <UIKit/UIGeometry.h>

NS_ASSUME_NONNULL_BEGIN

@interface NKTextContainer : NSObject <NSCopying>


@property (nonatomic, assign) CGSize size;

@property (nonatomic, assign) UIEdgeInsets insets;


+ (instancetype)containerWithSize:(CGSize)size;

+ (instancetype)containerWithSize:(CGSize)size insets:(UIEdgeInsets)insets;

@end

NS_ASSUME_NONNULL_END
