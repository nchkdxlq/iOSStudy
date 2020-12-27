//
//  MDHTMLViewController.m
//  iOSStudy
//
//  Created by Knox on 2020/12/26.
//  Copyright © 2020 Knox. All rights reserved.
//

#import "MDHTMLViewController.h"
#import "MDHTMLLabel.h"
#import "UIScreen+NKExtension.h"

/*
 背景
 在做卡片需求过程中, 遇到需要展示html片段的需求.
 在开发过程中, 遇到以下问题
 1. MDHTMLLabel字符串处理越界闪退
 2. CardMessageCell点击事件处理无法响应
 3. 计算文本高度不准确
 4. YYLabel alignment属性失效, 在滚动消息列表过程中, 文本有时居中, 有时居左
 5. YYLabel 计算Label的Size不对, 比文本实际需要占用的size要大
 6. MDHTMLLabel计算富文本size时, 没使用html片段中的fontSize属性
 
 */

@interface MDHTMLViewController () <MDHTMLLabelDelegate>

@property (nonatomic, copy) NSString *html1;


@property (nonatomic, strong) MDHTMLLabel *htmlLabel;

@end

@implementation MDHTMLViewController


- (NSString *)html1 {
    return @"我是文本<a href=\"https://www.baidu.com\">百度一下</a>我是文本我是文本我是文本<font size='19'>早上好</font><font size='29'>我是文本</font>";
}

- (MDHTMLLabel *)htmlLabel {
    if (!_htmlLabel) {
        MDHTMLLabel *htmlLabel = [MDHTMLLabel new];
        htmlLabel.font = [UIFont systemFontOfSize:13];
        htmlLabel.textColor = [UIColor whiteColor];
        htmlLabel.backgroundColor = UIColor.grayColor;
        htmlLabel.numberOfLines = 0;
        htmlLabel.delegate = self;
        htmlLabel.linkAttributes = @{
            NSFontAttributeName:[UIFont systemFontOfSize:15],
            NSForegroundColorAttributeName:[UIColor redColor],
        };
        
        htmlLabel.activeLinkAttributes = @{
            NSFontAttributeName:[UIFont boldSystemFontOfSize:15],
            NSForegroundColorAttributeName: [UIColor blueColor]
        };
        
        _htmlLabel = htmlLabel;
    }
    return _htmlLabel;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"MDHTMLLabel";

    [self test1];
}

- (void)test1 {
    [self.view addSubview:self.htmlLabel];
    self.htmlLabel.htmlText = self.html1;
    
    CGFloat leftRightMargin = 10;
    CGFloat maxWidth = UIScreen.width - leftRightMargin;
    CGSize fitSize = CGSizeMake(maxWidth, MAXFLOAT);
    CGSize size = [self.htmlLabel sizeThatFits:fitSize];
    self.htmlLabel.frame = CGRectMake(leftRightMargin, 120, size.width, size.height);
}


#pragma mark - MDHTMLLabelDelegate

- (void)HTMLLabel:(MDHTMLLabel *)label didSelectLinkWithURL:(NSURL*)URL {
    NSLog(@"didSelectLinkWithURL url = %@", URL);
}

- (void)HTMLLabel:(MDHTMLLabel *)label didHoldLinkWithURL:(NSURL*)URL {
    NSLog(@"didHoldLinkWithURL url = %@", URL);
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
