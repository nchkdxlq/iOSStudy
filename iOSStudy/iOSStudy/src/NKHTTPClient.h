//
//  NKHTTPClient.h
//  iOSStudy
//
//  Created by Knox on 2021/6/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN



@interface NKLogin : NSObject

- (void)loginWithAccount:(NSString *)acount
                 success:(void(^)(NSString *token))success
                 failure:(void(^)(NSError *))failure;



@end


@interface NKHTTPClient : NSObject

+ (instancetype)sharedInstance;


- (NSString *)logout;

- (nullable NSURLSessionTask *)httpLoginWithAccount:(NSString *)acount
                                            success:(void(^)(NSDictionary *response))success
                                            failure:(void(^)(NSError *))failure;



@end

NS_ASSUME_NONNULL_END
