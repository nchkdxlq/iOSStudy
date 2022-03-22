//
//  NKURLSchemeHandler.m
//  iOSStudy
//
//  Created by Knox on 2022/3/10.
//

#import "NKURLSchemeHandler.h"


@implementation NKURLSchemeHandler


+ (NSString *)scheme {
    return @"nk";
}

- (void)webView:(WKWebView *)webView startURLSchemeTask:(id<WKURLSchemeTask>)urlSchemeTask {
    
}


- (void)webView:(WKWebView *)webView stopURLSchemeTask:(id<WKURLSchemeTask>)urlSchemeTask {
    
}


@end
