//
//  UIScreen+SafeAreaInsets.h
//  iOSStudy
//
//  Created by Knox on 2021/12/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScreen (SafeAreaInsets)

@property (nonatomic, assign, readonly, class) UIEdgeInsets safeAreaInset;

@end

NS_ASSUME_NONNULL_END
