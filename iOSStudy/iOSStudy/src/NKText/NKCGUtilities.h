//
//  NKCGUtilities.h
//  iOSStudy
//
//  Created by Knox on 2021/1/22.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN


/// Negates/inverts a UIEdgeInsets.
static inline UIEdgeInsets UIEdgeInsetsInvert(UIEdgeInsets insets) {
    return UIEdgeInsetsMake(-insets.top, -insets.left, -insets.bottom, -insets.right);
}


NS_ASSUME_NONNULL_END
