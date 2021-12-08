//
//  NKTextureViewController.m
//  iOSStudy
//
//  Created by Knox on 2021/12/7.
//

#import "NKTextureViewController.h"
#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface NKTextureViewController ()


@end

@implementation NKTextureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ASTextNode *nameNode = [ASTextNode new];
    nameNode.backgroundColor = [UIColor redColor];
    nameNode.attributedText = [[NSAttributedString alloc] initWithString:@"AsyncDisplayKit" attributes:[self textStyle]];
    [self.view addSubnode:nameNode];
    ASSizeRange sizeRange = ASSizeRangeMake(CGSizeZero, CGSizeMake(300, 100));
//    sizeRange = ASSizeRangeMake(CGSizeMake(200, 200));
    CGSize size = [nameNode calculateLayoutLayoutSpec:sizeRange].size;
    nameNode.frame = CGRectMake(100, 100, size.width, size.height);
}

- (NSDictionary *)textStyle {
    return @{
        NSFontAttributeName:[UIFont systemFontOfSize:17 weight:UIFontWeightBold],
        NSForegroundColorAttributeName: UIColor.blueColor
    };
}


@end
