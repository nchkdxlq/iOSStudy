//
//  NSURLSessionDelegateProxy.h
//  iOSStudy
//
//  Created by Knox on 2021/12/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURLSessionDelegateProxy : NSProxy<NSURLSessionDelegate>

@property (nonatomic, strong, readonly) id<NSURLSessionDelegate> target;

- (instancetype)initWithTarget:(id<NSURLSessionDelegate>)target;

+ (instancetype)proxyWithTarget:(id<NSURLSessionDelegate>)target;

@end

NS_ASSUME_NONNULL_END
