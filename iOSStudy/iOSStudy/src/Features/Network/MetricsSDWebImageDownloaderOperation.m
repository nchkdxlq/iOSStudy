//
//  MetricsSDWebImageDownloaderOperation.m
//  iOSStudy
//
//  Created by Knox on 2021/11/27.
//

#import "MetricsSDWebImageDownloaderOperation.h"
#import "HTTPMetricsManager.h"


@implementation MetricsSDWebImageDownloaderOperation

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didFinishCollectingMetrics:(NSURLSessionTaskMetrics *)metrics {
    [super URLSession:session task:task didFinishCollectingMetrics:metrics];
    [HTTPMetricsManager didFinishCollectingMetrics:metrics];
}

@end
