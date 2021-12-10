//
//  NKChatCellNode.h
//  iOSStudy
//
//  Created by Knox on 2021/12/8.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "NKChat.h"

NS_ASSUME_NONNULL_BEGIN

@interface NKChatCellNode_v1 : ASCellNode

- (instancetype)initWithChat:(NKChat *)chat;

@end

NS_ASSUME_NONNULL_END
