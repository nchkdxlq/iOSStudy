//
//  UINavigationBar+NKExtension.m
//  iOSStudy
//
//  Created by Knox on 2021/12/12.
//

#import "UINavigationBar+NKExtension.h"

@implementation UINavigationBar (NKExtension)

- (CGFloat)fullHeight {
    for (UIView *view in self.subviews) {
        if ([NSStringFromClass(view.class) isEqualToString:@"_UIBarBackground"]) {
            return CGRectGetHeight(view.bounds);
        }
    }
    return CGRectGetHeight(self.bounds);
}


@end
