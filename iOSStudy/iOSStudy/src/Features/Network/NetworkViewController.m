//
//  NetworkViewController.m
//  iOSStudy
//
//  Created by Knox on 2021/11/26.
//

#import "NetworkViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "MetricsAFHTTPSessionManager.h"
#import "UIDeviceMetrics.h"

@implementation NetworkViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    AFHTTPSessionManager *manager = [MetricsAFHTTPSessionManager manager];
    [manager GET:@"https://www.baidu.com" parameters:nil headers:nil progress:NULL success:NULL failure:NULL];
    
    NSDate *begin = [NSDate date];
    float cpuUsage = [UIDeviceMetrics appCpuUsage];
    NSTimeInterval cost = [[NSDate date] timeIntervalSinceDate:begin];
    NSLog(@"cpuUsage = %f, cost = %f", cpuUsage, cost);
}


@end
