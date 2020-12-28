//
//  NKTextViewController.m
//  iOSStudy
//
//  Created by Knox on 2020/12/27.
//

#import "NKTextViewController.h"
#import "NKTextLayout.h"


@interface NKTextViewController ()

@end

@implementation NKTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"NKText";
    
    CGRect rect = CGRectMake(10, 10, 100, 100);
    CGRect newRect = CGRectApplyAffineTransform(rect, CGAffineTransformMakeScale(1, -1));
    NSLog(@"rect = %@, newRect = %@", NSStringFromCGRect(rect), NSStringFromCGRect(newRect));
    
    NSString *text = @"Every developer needs to configure their environment, so let's get your GitHub experience optimized for you.";
    NSAttributedString *attr = [[NSAttributedString alloc] initWithString:text];
    NKTextLayout *layout = [NKTextLayout layoutWithContainerSize:CGSizeMake(100, 1000) text:attr];
    
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
