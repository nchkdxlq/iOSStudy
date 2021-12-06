//
//  NetworkViewController.m
//  iOSStudy
//
//  Created by Knox on 2021/11/26.
//

#import "NetworkViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "UIDeviceMetrics.h"
#import "HTTPMetricsManager.h"

@interface NetworkViewController () <HTTPMetricsManagerDelegate>

@end

@implementation NetworkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[HTTPMetricsManager sharedMetrics] addObserver:self];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:@"https://www.baidu.com" parameters:nil headers:nil progress:NULL success:NULL failure:NULL];
    
    NSDate *begin = [NSDate date];
    float cpuUsage = [UIDeviceMetrics appCpuUsage];
    NSTimeInterval cost = [[NSDate date] timeIntervalSinceDate:begin];
    NSLog(@"cpuUsage = %f, cost = %f", cpuUsage, cost);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[HTTPMetricsManager sharedMetrics] removeObserver:self];
}

- (void)metricsManager:(HTTPMetricsManager *)manager didCollectedMetrics:(HMHTTPTransactionMetrics *)metrics {
    NSLog(@"%@", [metrics description]);
}


@end
