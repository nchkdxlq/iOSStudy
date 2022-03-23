//
//  UIScreen+SafeAreaInsets.h
//  iOSStudy
//
//  Created by Knox on 2021/12/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScreen (SafeAreaInsets)

@property (nonatomic, assign, readonly, class) UIEdgeInsets areaInsets;


/// 是否为刘海屏
@property (nonatomic, assign, readonly, class) BOOL isNotch;

@end

NS_ASSUME_NONNULL_END
