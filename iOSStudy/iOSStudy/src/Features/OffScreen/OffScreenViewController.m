//
//  OffScreenViewController.m
//  iOSStudy
//
//  Created by Knox on 2021/10/10.
//

#import "OffScreenViewController.h"



@implementation OffScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self uiViewCornerRadius];
    [self imageViewCornerRadius];
    [self imageViewCornerRadius_v2];
    [self uiViewOpacity];
    [self uiViewShadow];
}

- (void)uiViewCornerRadius {
    // 不会触发离屏渲染
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(20, 130, 100, 100)];
    aView.backgroundColor = UIColor.lightGrayColor;
    // cornerRadius默认触发设置 backgroundColor 和 border 的圆角，而不会设置 content 的圆角
    aView.layer.cornerRadius = 20;
    aView.layer.borderWidth = 3;
    aView.layer.borderColor = UIColor.blueColor.CGColor;
    aView.layer.masksToBounds = YES;
    [self.view addSubview:aView];
}


- (void)imageViewCornerRadius {
    // 不会触发离屏渲染
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(150, 130, 100, 100)];
    imageView.image = [UIImage imageNamed:@"天空_草坪"];
    imageView.layer.cornerRadius = 20;
    imageView.layer.masksToBounds = YES;
    [self.view addSubview:imageView];
    
    // 如果没有设置backgroundColor 或者 border 图片圆角不会触发离屏渲染
//    imageView.backgroundColor = UIColor.redColor;
//    imageView.layer.borderWidth = 3;
}

- (void)imageViewCornerRadius_v2 {
    // 会触发离屏渲染
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(280, 130, 100, 100)];
    imageView.image = [UIImage imageNamed:@"天空_草坪"];
    imageView.layer.cornerRadius = 20;
    imageView.layer.masksToBounds = YES;
    [self.view addSubview:imageView];
    
    // 再设置backgroundColor 或者 border 图片圆角会触发离屏渲染
    imageView.backgroundColor = UIColor.redColor;
    // imageView.layer.borderWidth = 3;
}

- (void)uiViewOpacity {
    // 会触发离屏渲染？？？？
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(20, 260, 300, 60)];
    [self.view addSubview:view];
    view.layer.opacity = 0.5;
    view.layer.allowsGroupOpacity = YES;
    view.backgroundColor = UIColor.lightGrayColor;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(view.frame)+4, 300, 20)];
    label.text = @"layer.opacity = 0.5";
    [self.view addSubview:label];
}

- (void)uiViewShadow {
    // 会触发离屏渲染
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(20, 360, 300, 60)];
    [self.view addSubview:view];
    view.layer.shadowOffset = CGSizeMake(3, 5);
    view.layer.shadowColor = UIColor.redColor.CGColor;
    view.layer.shadowRadius = 10;
    view.layer.shadowOpacity = 0.5;
    view.backgroundColor = UIColor.lightGrayColor;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(view.frame)+4, 300, 20)];
    label.text = @"layer.shadowxxx";
    [self.view addSubview:label];
}

@end
