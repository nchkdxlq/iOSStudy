//
//  FishhookViewController.m
//  iOSStudy
//
//  Created by Knox on 2021/11/7.
//

#import "FishhookViewController.h"
#import "fishhook.h"

static void (*sys_nsLog)(NSString *format, ...);

void my_nsLog(NSString *format, ...) {
    format = [format stringByAppendingString:@"  >>>> NSLog 被 hook 了 <<<<"];
    sys_nsLog(format);
}

@implementation FishhookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    struct rebinding nslog;
    nslog.name = @"NSLog".UTF8String;
    nslog.replacement = my_nsLog;
    nslog.replaced = (void *)&sys_nsLog;

    struct rebinding rebs[1] = {nslog};
    rebind_symbols(rebs, 1);
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchesBegan");
}

@end
