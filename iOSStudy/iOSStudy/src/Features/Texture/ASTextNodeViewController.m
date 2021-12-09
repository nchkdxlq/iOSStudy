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
    [self.view addSubnode:nameNode];
    ASSizeRange sizeRange = ASSizeRangeMake(CGSizeZero, CGSizeMake(300, 100));
    CGSize size = [nameNode calculateLayoutLayoutSpec:sizeRange].size;
    nameNode.frame = CGRectMake(100, 200, size.width, size.height);
}

- (NSDictionary *)textStyle {
    return @{
        NSFontAttributeName:[UIFont systemFontOfSize:17 weight:UIFontWeightBold],
        NSForegroundColorAttributeName: UIColor.blueColor
    };
}


@end
