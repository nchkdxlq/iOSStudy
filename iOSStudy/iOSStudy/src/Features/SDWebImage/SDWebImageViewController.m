//
//  SDWebImageViewController.m
//  iOSStudy
//
//  Created by Knox on 2021/1/8.
//  Copyright © 2020 Knox. All rights reserved.
//

#import "SDWebImageViewController.h"
#import <SDWebImage/SDWebImage.h>
#import <Masonry/Masonry.h>


@interface SDWebImageViewController ()

@end

@implementation SDWebImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIImageView *imageView = [UIImageView new];
    imageView.backgroundColor = UIColor.lightGrayColor;
    imageView.contentMode = UIViewContentModeCenter;
    imageView.layer.masksToBounds = YES;
    [self.view addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(@(200));
        make.height.equalTo(@(200));
    }];
    
    imageView.image = [UIImage imageNamed:@"小蛮腰"];
    
    NSURL *url = [NSURL URLWithString:@"https://ww1.sinaimg.cn/orj360/006amZe7ly1gmfzh6lfa7j30n01dsalp.jpg"];
    SDWebImageOptions options = SDWebImageFromLoaderOnly;
    [imageView sd_setImageWithURL:url placeholderImage:nil options:options completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (error) {
            NSLog(@"%@", error);
        }
    }];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [imageView sd_cancelCurrentImageLoad];
//    });
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
