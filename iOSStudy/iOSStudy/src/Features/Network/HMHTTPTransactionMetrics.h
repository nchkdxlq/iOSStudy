//
//  HMHTTPTransactionMetrics.h
//  iOSStudy
//
//  Created by Knox on 2021/11/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


/// 单次网络请求性能指标数据
@interface HMHTTPTransactionMetrics : NSObject

@property (nonatomic, strong, readonly) NSURLSessionTaskTransactionMetrics *transactionMetrics;

/// 请求总耗时
@property (nonatomic, assign, readonly) NSTimeInterval duration;

/// DNS解析耗时
@property (nonatomic, assign, readonly) NSTimeInterval dns;

/// TCP建立连接耗时 + TLS握手耗时
@property (nonatomic, assign, readonly) NSTimeInterval connect;

/// TLS握手耗时
@property (nonatomic, assign, readonly) NSTimeInterval tlsHandShake;

/// 请求行 + 请求头 + 请求体字节数
@property (nonatomic, assign, readonly) NSUInteger requestLength;

/// 响应行 + 响应头 + 响应体字节数
@property (nonatomic, assign, readonly) NSUInteger responseLength;

/// HTTP响应状态码
@property (nonatomic, assign, readonly) NSInteger statusCode;

/// 上行速度
@property (nonatomic, assign, readonly) NSUInteger outStreamSpeed;

/// 下行速度
@property (nonatomic, assign, readonly) NSUInteger inStreamSpeed;


+ (instancetype)metricsWithTaskTransactionMetrics:(NSURLSessionTaskTransactionMetrics *)transactionMetrics;

@end

NS_ASSUME_NONNULL_END
