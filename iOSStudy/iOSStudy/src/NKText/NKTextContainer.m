//
//  NKTextContainer.m
//  iOSStudy
//
//  Created by Knox on 2020/12/27.
//

#import "NKTextContainer.h"

@implementation NKTextContainer

+ (instancetype)containerWithSize:(CGSize)size {
    return [self containerWithSize:size insets:UIEdgeInsetsZero];
}

+ (instancetype)containerWithSize:(CGSize)size insets:(UIEdgeInsets)insets {
    NKTextContainer *one = [NKTextContainer new];
    one.size = size;
    one.insets = insets;
    return one;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    NKTextContainer *ins = [NKTextContainer new];
    ins.size = self.size;
    ins.insets = self.insets;
    return ins;
}


@end
