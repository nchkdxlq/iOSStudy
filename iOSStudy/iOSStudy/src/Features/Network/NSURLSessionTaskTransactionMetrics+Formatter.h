//
//  NSURLSessionTaskTransactionMetrics+Formatter.h
//  iOSStudy
//
//  Created by Knox on 2021/11/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURLSessionTaskTransactionMetrics (Formatter)

/// 请求总耗时
@property (nonatomic, assign, readonly) NSTimeInterval duration;

/// DNS解析耗时
@property (nonatomic, assign, readonly) NSTimeInterval dns;

/// TCP建立连接耗时 + TLS握手耗时
@property (nonatomic, assign, readonly) NSTimeInterval connecte;

/// TLS握手耗时
@property (nonatomic, assign, readonly) NSTimeInterval tlsHandShake;

/// 请求头+请求体字节数
@property (nonatomic, assign, readonly) int64_t countOfRequestBytesSent;

/// 响应头+响应体字节数
@property (nonatomic, assign, readonly) int64_t countOfResponseBytesReceived;

/// HTTP响应状态码
@property (nonatomic, assign, readonly) NSInteger statusCode;


- (NSString *)metricsDescription;

@end

NS_ASSUME_NONNULL_END
