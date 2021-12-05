//
//  HMHTTPTransactionMetrics.m
//  iOSStudy
//
//  Created by Knox on 2021/11/27.
//

#import "HMHTTPTransactionMetrics.h"

@interface HMHTTPTransactionMetrics ()

@end

@implementation HMHTTPTransactionMetrics

+ (instancetype)metricsWithTaskTransactionMetrics:(NSURLSessionTaskTransactionMetrics *)transactionMetrics {
    return [[self alloc] initWithTaskTransactionMetrics:transactionMetrics];
}

- (instancetype)initWithTaskTransactionMetrics:(NSURLSessionTaskTransactionMetrics *)transactionMetrics {
    self = [super init];
    if (self) {
        _transactionMetrics = transactionMetrics;
        [self timing];
        [self setupRequest];
        [self setupResponse];
    }
    return self;
}

#pragma makr - timing

- (void)timing {
    [self setupDuration];
    [self setupDNS];
    [self setupConnect];
    [self setupTLSHandShake];
}


// 从开始请求开始 -> 接收到响应体的最后一个字节
- (void)setupDuration {
    NSDate *fetchStartDate = self.transactionMetrics.fetchStartDate;
    NSDate *responseEndDate = self.transactionMetrics.responseEndDate;
    if (fetchStartDate && responseEndDate) {
        _duration = [responseEndDate timeIntervalSinceDate:fetchStartDate];
    } else {
        _duration = -1;
    }
}

- (void)setupDNS {
    NSDate *domainLookupStartDate = self.transactionMetrics.domainLookupStartDate;
    NSDate *domainLookupEndDate = self.transactionMetrics.domainLookupEndDate;
    if (domainLookupStartDate && domainLookupEndDate) {
        _dns = [domainLookupEndDate timeIntervalSinceDate:domainLookupStartDate];
    } else {
        _dns = -1;
    }
}

- (void)setupConnect {
    NSDate *connectStartDate = self.transactionMetrics.connectStartDate;
    NSDate *connectEndDate = self.transactionMetrics.connectEndDate;
    if (connectStartDate && connectEndDate) {
        _connect = [connectEndDate timeIntervalSinceDate:connectStartDate];
    } else {
        _connect = -1;
    }
}

- (void)setupTLSHandShake {
    NSDate *secureConnectionStartDate = self.transactionMetrics.secureConnectionStartDate;
    NSDate *secureConnectionEndDate = self.transactionMetrics.secureConnectionEndDate;
    if (secureConnectionStartDate && secureConnectionEndDate) {
        _tlsHandShake = [secureConnectionEndDate timeIntervalSinceDate:secureConnectionStartDate];
    } else {
        _tlsHandShake = -1;
    }
}


#pragma makr - request

- (void)setupRequest {
    // 1. 请求数据字节大小
    NSUInteger lineLength = [self _requestLineLength];
    NSUInteger headerLength = [self _requestHeaderLength];
    NSUInteger cookieLength = [self _reqeustCookieLength];
    NSUInteger bodyLength = [self _requestBodyLength];
    _requestLength = lineLength + headerLength + cookieLength + bodyLength;
    
    // 2. 上行速率
    NSDate *requestStartDate = self.transactionMetrics.requestStartDate;
    NSDate *requestEndDate = self.transactionMetrics.requestEndDate;
    if (requestStartDate && requestEndDate) {
        NSTimeInterval cost = [requestEndDate timeIntervalSinceDate:requestStartDate];
        _outStreamSpeed =_requestLength / cost;;
    } else {
        _outStreamSpeed = 0;
    }
}

- (NSUInteger)_requestLineLength {
    NSURLRequest *request = self.transactionMetrics.request;
    // GET /index.html HTTP/1.1 \r\n   最后再加上 \r\n 的长度2 和 中间的2个空格
    return request.HTTPMethod.length + request.URL.path.length + self.transactionMetrics.networkProtocolName.length + 4;
}

- (NSUInteger)_requestHeaderLength {
    return [self _headerLengthForHeaders:self.transactionMetrics.request.allHTTPHeaderFields];
}

- (NSUInteger)_reqeustCookieLength {
    NSURLRequest *request = self.transactionMetrics.request;
    NSArray<NSHTTPCookie *> * cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:request.URL];
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
    return [self.transactionMetrics.request.HTTPBody length];
}

#pragma makr - response


- (void)setupResponse {
    _statusCode = [(NSHTTPURLResponse *)self.transactionMetrics.response statusCode];
    // 响应数据字节数
    NSUInteger lineLength = [self _responseLineLength];
    NSUInteger headerLength = [self _responseHeaderLength];
    NSUInteger bodyLength = [self _responseBodyLength];
    _responseLength = lineLength + headerLength + bodyLength;
    
    // 下行速率
    NSDate *responseStartDate = self.transactionMetrics.responseStartDate;
    NSDate *responseEndDate = self.transactionMetrics.responseEndDate;
    if (responseStartDate && responseEndDate) {
        NSTimeInterval cost = [responseEndDate timeIntervalSinceDate:responseStartDate];
        _inStreamSpeed = _responseLength / cost;
    } else {
        _inStreamSpeed = 0;
    }
}

- (NSUInteger)_responseLineLength {
    // HTTP/1.1 200 OK \r\n   最后再加上 \r\n 的长度2 和 中间的2个空格
    NSString *msg = [NSHTTPURLResponse localizedStringForStatusCode:self.statusCode];
    return self.transactionMetrics.networkProtocolName.length + 3 + msg.length + 4;
}

- (NSUInteger)_responseHeaderLength {
    return [self _headerLengthForHeaders:[(NSHTTPURLResponse *)self.transactionMetrics.response allHeaderFields]];
}

- (NSUInteger)_responseBodyLength {
    if (self.transactionMetrics.response.expectedContentLength != NSURLResponseUnknownLength) {
        return self.transactionMetrics.response.expectedContentLength;
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


- (NSString *)resourceFetchType {
    NSURLSessionTaskMetricsResourceFetchType resourceFetchType = self.transactionMetrics.resourceFetchType;
    if (resourceFetchType == NSURLSessionTaskMetricsResourceFetchTypeNetworkLoad) {
        return @"NetworkLoad";
    } else if (resourceFetchType == NSURLSessionTaskMetricsResourceFetchTypeServerPush) {
        return @"ServerPush";
    } else if (resourceFetchType == NSURLSessionTaskMetricsResourceFetchTypeLocalCache) {
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

- (NSString *)description {
    return [NSString stringWithFormat:@"\n\
>>>>>>>>> ResourceFetchType%@ <<<<<<<<<\n\
      duration: %.3f s \n\
           dns: %.3f s \n\
       connect: %.3f s \n\
  tlsHandShake: %.3f s \n\
    statusCode: %ld \n\
outStreamSpeed: %@ \n\
 inStreamSpeed: %@ \n",
            [self resourceFetchType],
            self.duration,
            self.dns,
            self.connect,
            self.tlsHandShake,
            self.statusCode,
            [self fileSizeForBytes:self.outStreamSpeed],
            [self fileSizeForBytes:self.inStreamSpeed]];
}

@end
