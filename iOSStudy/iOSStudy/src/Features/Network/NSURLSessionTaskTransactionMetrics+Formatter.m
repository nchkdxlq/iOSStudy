//
//  NSURLSessionTaskTransactionMetrics+Formatter.m
//  iOSStudy
//
//  Created by Knox on 2021/11/26.
//

#import "NSURLSessionTaskTransactionMetrics+Formatter.h"

@implementation NSURLSessionTaskTransactionMetrics (Formatter)

// 从开始请求开始 -> 接收到响应体的最后一个字节
- (NSTimeInterval)duration {
    if (self.fetchStartDate && self.responseEndDate) {
        return [self.responseEndDate timeIntervalSinceDate:self.fetchStartDate];
    }
    return -1;
}

- (NSTimeInterval)dns {
    if (self.domainLookupStartDate && self.domainLookupEndDate) {
        return [self.domainLookupEndDate timeIntervalSinceDate:self.domainLookupStartDate];
    }
    return -1;
}

- (NSTimeInterval)connecte {
    if (self.connectStartDate && self.connectEndDate) {
        return [self.connectEndDate timeIntervalSinceDate:self.connectStartDate];
    }
    return -1;
}

- (NSTimeInterval)tlsHandShake {
    if (self.secureConnectionStartDate && self.secureConnectionEndDate) {
        return [self.secureConnectionEndDate timeIntervalSinceDate:self.secureConnectionStartDate];
    }
    return -1;
}

- (int64_t)countOfRequestBytesSent {
    return self.countOfRequestHeaderBytesSent + self.countOfRequestBodyBytesSent;
}

- (int64_t)countOfResponseBytesReceived {
    return self.countOfResponseHeaderBytesReceived + self.countOfResponseBodyBytesReceived;
}

- (NSInteger)statusCode {
    return [(NSHTTPURLResponse *)self.response statusCode];
}

- (NSString *)metricsDescription {
    return [NSString stringWithFormat:@"\n\
>>>>>>>>> ResourceFetchType%@ <<<<<<<<<\n\
    duration: %.3f s \n\
         dns: %.3f s \n\
    connecte: %.3f s \n\
tlsHandShake: %.3f s \n\
  statusCode: %ld",
            [self fetchType],
            self.duration,
            self.dns,
            self.connecte,
            self.tlsHandShake,
            self.statusCode];
}

/*
 NSURLSessionTaskMetricsResourceFetchTypeUnknown,
 NSURLSessionTaskMetricsResourceFetchTypeNetworkLoad,
 NSURLSessionTaskMetricsResourceFetchTypeServerPush,
 NSURLSessionTaskMetricsResourceFetchTypeLocalCache,
 
 */
- (NSString *)fetchType {
    if (self.resourceFetchType == NSURLSessionTaskMetricsResourceFetchTypeNetworkLoad) {
        return @"NetworkLoad";
    } else if (self.resourceFetchType == NSURLSessionTaskMetricsResourceFetchTypeServerPush) {
        return @"ServerPush";
    } else if (self.resourceFetchType == NSURLSessionTaskMetricsResourceFetchTypeLocalCache) {
        return @"LocalCache";
    } else {
        return @"Unknown";
    }
}
@end
