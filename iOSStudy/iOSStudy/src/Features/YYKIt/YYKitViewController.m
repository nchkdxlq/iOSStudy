//
//  YYKitViewController.m
//  iOSStudy
//
//  Created by Knox on 2020/12/26.
//  Copyright © 2020 Knox. All rights reserved.
//

#import "YYKitViewController.h"
#import <YYKit/YYKit.h>

#import "UIScreen+NKExtension.h"

@interface YYKitViewController ()

@end

@implementation YYKitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"YYKit";
    
    NSString *str1 = @"百度一下";
    NSString *str2 = @"https://www.baidu.com";
    NSString *text = [NSString stringWithFormat:@"%@%@", str1, str2];
    
    NSRange range1 = NSMakeRange(0, str1.length);
    NSRange range2 = NSMakeRange(str1.length, str2.length);
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:text];
    [attr setLineSpacing:2];
    [attr setFont:[UIFont systemFontOfSize:18]];
    
    YYTextHighlight *highlight1 = [YYTextHighlight new];
    [highlight1 setColor:UIColor.blueColor];
    [highlight1 setTapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        NSString *highlightStr = [text.string substringWithRange:range];
        NSLog(@"highlight1 TapAction = %@", highlightStr);
    }];
    [attr setTextHighlight:highlight1 range:range1];
    
    YYTextHighlight *highlight2 = [YYTextHighlight new];
    [highlight2 setColor:UIColor.redColor];
    [highlight2 setTapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        NSString *highlightStr = [text.string substringWithRange:range];
        NSLog(@"highlight2 TapAction = %@", highlightStr);
    }];
    [attr setTextHighlight:highlight2 range:range2];
    
    YYLabel *yyLabel = [YYLabel new];
    yyLabel.numberOfLines = 0;
    yyLabel.attributedText = attr;
    yyLabel.backgroundColor = UIColor.lightGrayColor;
    [self.view addSubview:yyLabel];
    
    CGFloat margin = 10;
    CGFloat width = UIScreen.width - 2 * margin;
    yyLabel.frame = CGRectMake(10, 100, width, 200);
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
