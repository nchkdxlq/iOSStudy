//
//  NetworkViewController.m
//  iOSStudy
//
//  Created by Knox on 2021/11/26.
//

#import "NetworkViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "NetworkMetrics.h"
#import "UIDeviceMetrics.h"

@implementation NetworkViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager setTaskDidFinishCollectingMetricsBlock:^(NSURLSession * _Nonnull session, NSURLSessionTask * _Nonnull task, NSURLSessionTaskMetrics * _Nullable metrics) {
        [[NetworkMetrics sharedMetrics] collectSessionTaskMetrics:metrics];
    }];
    
    [manager GET:@"https://www.baidu.com" parameters:nil headers:nil progress:NULL success:NULL failure:NULL];
}


@end
