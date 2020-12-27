//
//  YYKitViewController.m
//  iOSStudy
//
//  Created by Knox on 2020/12/26.
//  Copyright © 2020 Knox. All rights reserved.
//

#import "YYKitViewController.h"
#import <YYKit/YYLabel.h>

@interface YYKitViewController ()

@end

@implementation YYKitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"YYKit";
    
    YYLabel *yyLabel = [YYLabel new];
    yyLabel.text = @"yyLabel";
    yyLabel.backgroundColor = UIColor.lightGrayColor;
    [self.view addSubview:yyLabel];
    
    yyLabel.frame = CGRectMake(10, 100, 200, 200);
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
