//
//  ASTextNodeViewController.m
//  iOSStudy
//
//  Created by Knox on 2021/12/8.
//

#import "ASTextNodeViewController.h"
#import <AsyncDisplayKit/AsyncDisplayKit.h>

@implementation ASTextNodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self textNode];
}

- (void)textNode {
    
    ASTextNode *nameNode = [ASTextNode new];
    nameNode.backgroundColor = [UIColor redColor];
    nameNode.attributedText = [[NSAttributedString alloc] initWithString:@"AsyncDisplayKit" attributes:[self textStyle]];
    
    ASDisplayNode *paddingNode = [ASDisplayNode new];
    paddingNode.backgroundColor = [UIColor blueColor];
    [paddingNode addSubnode:nameNode];
    [self.node addSubnode:paddingNode];
    
    [paddingNode setLayoutSpecBlock:^ASLayoutSpec * _Nonnull(__kindof ASDisplayNode * _Nonnull node, ASSizeRange constrainedSize) {
        UIEdgeInsets inset = UIEdgeInsetsMake(10, 20, 10, 20);
        return [ASInsetLayoutSpec insetLayoutSpecWithInsets:inset child:nameNode];
    }];
    
    ASCenterLayoutSpec *center = [ASCenterLayoutSpec centerLayoutSpecWithCenteringOptions:ASCenterLayoutSpecCenteringXY
                                                                            sizingOptions:ASCenterLayoutSpecSizingOptionDefault
                                                                                    child:paddingNode];
    [self.node setLayoutSpecBlock:^ASLayoutSpec * _Nonnull(__kindof ASDisplayNode * _Nonnull node, ASSizeRange constrainedSize) {
        return center;
    }];
    
    [self.node setNeedsLayout];
}

- (NSDictionary *)textStyle {
    return @{
        NSFontAttributeName:[UIFont systemFontOfSize:17 weight:UIFontWeightBold],
        NSForegroundColorAttributeName: UIColor.blueColor
    };
}


@end
