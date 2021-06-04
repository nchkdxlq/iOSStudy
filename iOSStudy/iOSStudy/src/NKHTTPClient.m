//
//  NKHTTPClient.m
//  iOSStudy
//
//  Created by Knox on 2021/6/4.
//

#import "NKHTTPClient.h"

@implementation NKLogin

- (void)loginWithAccount:(NSString *)account
                 success:(void(^)(NSString *token))success
                 failure:(void(^)(NSError *))failure {
    [[NKHTTPClient sharedInstance] httpLoginWithAccount:account success:^(NSDictionary * _Nonnull response) {
        NSString *token = response[@"token"];
        !success ?: success(token);
    } failure:failure];
}

@end


@implementation NKHTTPClient


+ (instancetype)sharedInstance {
    static NKHTTPClient *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [NKHTTPClient new];
    });
    return instance;
}


- (NSString *)logout {
    return @"success";
}

- (nullable NSURLSessionTask *)httpLoginWithAccount:(NSString *)acount
                                            success:(void(^)(NSDictionary *response))success
                                            failure:(void(^)(NSError *))failure {
    NSDictionary *info = @{@"token":@"xxxx"};
    !success ?: success(info);
    return nil;
}

@end
