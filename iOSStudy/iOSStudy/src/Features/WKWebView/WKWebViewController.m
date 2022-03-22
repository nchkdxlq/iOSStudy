//
//  WKWebViewController.m
//  iOSStudy
//
//  Created by Knox on 2022/2/9.
//

#import "WKWebViewController.h"
#import <WebKit/WebKit.h>

#import "NKURLSchemeHandler.h"

/*
 
 结论:
 1. NSHTTPCookieStorage中的cookie不会自动同步到WKHTTPCookieStore, WKHTTPCookieStore中的cookie也不会自动同步到NSHTTPCookieStorage
 
 */

@interface WKWebViewController () <WKNavigationDelegate, WKHTTPCookieStoreObserver>

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation WKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self deleteCookies];
    [self printCookies];
    
    [self setupWebView];
    [self webViewCookies];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://www.baidu.com"]];
    [self.webView loadRequest:request];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_webView.configuration.websiteDataStore.httpCookieStore removeObserver:self];
}

- (void)setupWebView {
    CGFloat height = UIScreen.height - UIScreen.safeAreaInset.top - 200;
    CGRect frame = CGRectMake(0, UIScreen.safeAreaInset.top, UIScreen.width, height);
    WKWebViewConfiguration *config = [WKWebViewConfiguration new];
    [config setURLSchemeHandler:[NKURLSchemeHandler new] forURLScheme:NKURLSchemeHandler.scheme];
    WKUserScript *userScript = [[WKUserScript alloc] initWithSource:[self scriptString]
                                                      injectionTime:WKUserScriptInjectionTimeAtDocumentStart
                                                   forMainFrameOnly:NO];
    [config.userContentController addUserScript:userScript];
    _webView = [[WKWebView alloc] initWithFrame:frame configuration:config];
    [config.websiteDataStore.httpCookieStore addObserver:self];
    
    _webView.navigationDelegate = self;
    [self.view addSubview:_webView];
}

- (NSString *)scriptString {
    return @"document.cookie = 'testKey=100;domain=.baidu.com;path=/home';";
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self printCookies];
    [self webViewCookies];
}

#pragma mark - WKNavigationDelegate


- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    decisionHandler(WKNavigationResponsePolicyAllow);
}


- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
    
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
         NSURLCredential *credential = [[NSURLCredential alloc] initWithTrust:challenge.protectionSpace.serverTrust];
         completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
    } else {
        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:@{NSHTTPCookieName:@"testKey1",
                                                                NSHTTPCookieValue:@"hahha",
                                                                NSHTTPCookieDomain:@".baidu.com",
                                                                NSHTTPCookiePath:@"/user",
                                                              }];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
}


- (void)webViewCookies {
    [_webView.configuration.websiteDataStore.httpCookieStore getAllCookies:^(NSArray<NSHTTPCookie *> * _Nonnull cookies) {
        NSLog(@"websiteDataStore.httpCookieStore cookies count %ld", cookies.count);
        for (NSHTTPCookie *cookie in cookies) {
            NSLog(@"%@", [self descForCookie:cookie]);
        }
    }];
}

- (void)printCookies {
    NSArray<NSHTTPCookie *> *cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies;
    NSLog(@"NSHTTPCookieStorage cookies count %ld", cookies.count);
    
    for (NSHTTPCookie *cookie in cookies) {
        NSLog(@"%@", [self descForCookie:cookie]);
    }
}

- (void)deleteCookies {
    NSArray<NSHTTPCookie *> *cookis = [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies;
    for (NSHTTPCookie *cookie in cookis) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
    NSLog(@"delete cookies success");
}

- (NSString *)descForCookie:(NSHTTPCookie *)cookie {
    return [NSString stringWithFormat:@"%@=%@ domain:%@ path:%@", cookie.name, cookie.value, cookie.domain, cookie.path];
}

#pragma mark - WKHTTPCookieStoreObserver

- (void)cookiesDidChangeInCookieStore:(WKHTTPCookieStore *)cookieStore {
//    NSLog(@"%@", cookieStore);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
