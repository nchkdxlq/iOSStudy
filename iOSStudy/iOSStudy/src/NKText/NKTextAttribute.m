//
//  NKTextAttribute.m
//  iOSStudy
//
//  Created by Knox on 2021/1/14.
//

#import "NKTextAttribute.h"


NSString *const NKTextAttachmentAttributeName = @"NKTextAttachment";

@implementation NKTextAttachment

+ (instancetype)attachmentWithContent:(id)content {
    NKTextAttachment *ins = [self new];
    ins.content = content;
    return ins;
}


- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.content forKey:@"content"];
    [coder encodeObject:[NSValue valueWithUIEdgeInsets:self.contentInsets] forKey:@"contentInsets"];
    [coder encodeObject:self.userInfo forKey:@"userInfo"];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    _content = [coder decodeObjectForKey:@"content"];
    _contentInsets = [(NSValue *)[coder decodeObjectForKey:@"contentInsets"] UIEdgeInsetsValue];
    _userInfo = [coder decodeObjectForKey:@"userInfo"];
    return self;
}


- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    NKTextAttachment *ins = [NKTextAttachment new];
    if ([_content respondsToSelector:@selector(copy)]) {
        ins.content = [_content copy];
    } else {
        ins.content = _content;
    }
    ins.contentInsets = _contentInsets;
    ins.userInfo = _userInfo;
    return ins;
}

@end
