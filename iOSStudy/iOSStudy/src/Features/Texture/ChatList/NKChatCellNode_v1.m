//
//  NKChatCellNode.m
//  iOSStudy
//
//  Created by Knox on 2021/12/8.
//

#import "NKChatCellNode_v1.h"

@interface NKChatCellNode_v1 ()

@property (nonatomic, strong) ASImageNode *avatarNode;

@property (nonatomic, strong) ASTextNode *nameNode;

@property (nonatomic, strong) ASTextNode *descNode;

@property (nonatomic, strong) ASTextNode *timeNode;

@end

@implementation NKChatCellNode_v1

- (NSDictionary *)nameStyle {
    return @{
        NSFontAttributeName: [UIFont systemFontOfSize:16],
        NSForegroundColorAttributeName: UIColor.blueColor
    };
}

- (NSDictionary *)descStyle {
    return @{
        NSFontAttributeName: [UIFont systemFontOfSize:14],
        NSForegroundColorAttributeName: UIColor.lightGrayColor
    };
}

- (NSDictionary *)timeStyle {
    return @{
        NSFontAttributeName: [UIFont systemFontOfSize:14],
        NSForegroundColorAttributeName: UIColor.lightGrayColor
    };
}

- (instancetype)initWithChat:(NKChat *)chat {
    self = [super init];
    if (self) {
        _avatarNode = [ASImageNode new];
        [self addSubnode:_avatarNode];
        
        _nameNode = [ASTextNode new];
        _nameNode.attributedText = [[NSAttributedString alloc] initWithString:chat.name attributes:[self nameStyle]];
        [self addSubnode:_nameNode];
        
        _descNode = [ASTextNode new];
        _descNode.attributedText = [[NSAttributedString alloc] initWithString:chat.desc attributes:[self descStyle]];
        [self addSubnode:_descNode];
        
        _timeNode = [ASTextNode new];
        _timeNode.attributedText = [[NSAttributedString alloc] initWithString:@"23:12" attributes:[self timeStyle]];
        [self addSubnode:_timeNode];
    }
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    
    ASStackLayoutSpec *nameTimeStack =
    [ASStackLayoutSpec
     stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
     spacing:10
     justifyContent:ASStackLayoutJustifyContentSpaceBetween
     alignItems:ASStackLayoutAlignItemsStart
     children:@[_nameNode, _timeNode]];
    
    ASStackLayoutSpec *nameDescStack =
    [ASStackLayoutSpec
     stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
     spacing:10
     justifyContent:ASStackLayoutJustifyContentSpaceBetween
     alignItems:ASStackLayoutAlignItemsCenter
     children:@[nameTimeStack, _descNode]];
    
    ASStackLayoutSpec *avatarStack =
    [ASStackLayoutSpec
     stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
     spacing:10
     justifyContent:ASStackLayoutJustifyContentSpaceBetween
     alignItems:ASStackLayoutAlignItemsCenter
     children:@[_avatarNode, nameDescStack]];
    
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(10, 10, 10, 10) child:avatarStack];
}

@end
