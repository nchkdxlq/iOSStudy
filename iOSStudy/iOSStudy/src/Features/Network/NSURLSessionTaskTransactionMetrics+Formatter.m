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

#pragma makr - request

- (NSUInteger)requestLength {
    NSUInteger lineLength = [self _requestLineLength];
    NSUInteger headerLength = [self _requestHeaderLength];
    NSUInteger cookieLength = [self _reqeustCookieLength];
    NSUInteger bodyLength = [self.request.HTTPBody length];
    return lineLength + headerLength + cookieLength + bodyLength;
}

- (NSUInteger)_requestLineLength {
    // GET /index.html HTTP/1.1 \r\n   最后再加上 \r\n 的长度2 和 中间的2个空格
    return self.request.HTTPMethod.length + self.request.URL.path.length + self.networkProtocolName.length + 4;
}

- (NSUInteger)_requestHeaderLength {
    return [self _headerLengthForHeaders:self.request.allHTTPHeaderFields];
}

- (NSUInteger)_reqeustCookieLength {
    NSArray<NSHTTPCookie *> * cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:self.request.URL];
    NSUInteger length = 0;
    for (NSHTTPCookie *cookie in cookies) {
        // PSTM=1567952440;
        length += (cookie.name.length + cookie.value.length + 1);
    }
    length += (2 * (cookies.count - 1)); // n-1个 ;空格
    // Cookie: PSTM=1567952440 \r\n
    length += 10;
    return length;
}

- (NSUInteger)_requestBodyLength {
    return [self.request.HTTPBody length];
}

#pragma makr - response

- (NSUInteger)responseLength {
    NSUInteger lineLength = [self _responseLineLength];
    NSUInteger headerLength = [self _responseHeaderLength];
    NSUInteger bodyLength = [self _responseBodyLength];
    return lineLength + headerLength + bodyLength;
}

- (NSUInteger)_responseLineLength {
    // HTTP/1.1 200 OK \r\n   最后再加上 \r\n 的长度2 和 中间的2个空格
    NSString *msg = [NSHTTPURLResponse localizedStringForStatusCode:self.statusCode];
    return self.networkProtocolName.length + 3 + msg.length + 4;
}

- (NSUInteger)_responseHeaderLength {
    return [self _headerLengthForHeaders:[(NSHTTPURLResponse *)self.response allHeaderFields]];
}

- (NSUInteger)_responseBodyLength {
    if (self.response.expectedContentLength != NSURLResponseUnknownLength) {
        return self.response.expectedContentLength;
    } else {
        return 0;
    }
}

- (NSUInteger)_headerLengthForHeaders:(NSDictionary<NSString *, NSString *> *)headers {
    /**
     Accept-Language: zh-cn
     Accept-Encoding: gzip, deflate
     */
    __block NSUInteger length = 0;
    [headers enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        // key: value\r\n
        length += (key.length + obj.length + 4);
    }];
    return length;
}


- (NSUInteger)upSpeed {
    if (self.requestStartDate == nil || self.requestEndDate == nil) return 0;
    NSTimeInterval cost = [self.requestEndDate timeIntervalSinceDate:self.requestStartDate];
    if (cost > 0) {
        return self.requestLength / cost;;
    } else {
        return 0;
    }
}

- (NSUInteger)downSpeed {
    if (self.responseStartDate == nil || self.responseEndDate == nil) return 0;
    NSTimeInterval cost = [self.responseEndDate timeIntervalSinceDate:self.responseStartDate];
    if (cost > 0) {
        return self.responseLength / cost;;
    } else {
        return 0;
    }
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
  statusCode: %ld \n\
     upSpeed: %@ \n\
   downSpeed: %@ \n",
            [self fetchType],
            self.duration,
            self.dns,
            self.connecte,
            self.tlsHandShake,
            self.statusCode,
            [self fileSizeForBytes:self.upSpeed],
            [self fileSizeForBytes:self.downSpeed]];
}

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

- (NSString *)fileSizeForBytes:(NSUInteger)bytes {
    const NSUInteger KB = 1024;
    const NSUInteger MB = 1024 * 1024;
    const NSUInteger TB = 1024 * 1024 * 1024;
    
    if (bytes < KB) {
        return [NSString stringWithFormat:@"%lu B", bytes];
    } else if (bytes < MB) {
        return [NSString stringWithFormat:@"%.2f KB", bytes / (double)KB];
    } else if (bytes < TB) {
        return [NSString stringWithFormat:@"%.2f MB", bytes / (double)MB];
    } else {
        return [NSString stringWithFormat:@"%.2f TB", bytes / (double)TB];
    }
}

@end
