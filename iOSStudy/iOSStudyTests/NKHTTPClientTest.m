//
//  NKHTTPClientTest.m
//  iOSStudyTests
//
//  Created by Knox on 2021/6/4.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "NKHTTPClient.h"

@interface NKHTTPClientTest : XCTestCase

@end

@implementation NKHTTPClientTest

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}


- (void)testLogin {
    id mockManager = OCMPartialMock(NKHTTPClient.sharedInstance);
    
    [[[mockManager expect] andDo:^(NSInvocation *invocation) {
        void(^successCallback)(NSDictionary *) = nil;
        [invocation getArgument:&successCallback atIndex:3];
        NSDictionary *response = @{@"token":@"123456"};
        successCallback(response);
    }] httpLoginWithAccount:[OCMArg any] success:[OCMArg any] failure:[OCMArg any]];
    
    NKLogin *login = [NKLogin new];
    [login loginWithAccount:@"zhangsan" success:^(NSString * _Nonnull token) {
        XCTAssertTrue([token isEqualToString:@"123456"]);
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)testLogout {
    id mockManager = OCMPartialMock(NKHTTPClient.sharedInstance);
    [OCMStub([mockManager logout]) andReturn:@"123"];
    NSString *ret = [[NKHTTPClient sharedInstance] logout];
    XCTAssertTrue([ret isEqualToString:@"123"]);
}


- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
