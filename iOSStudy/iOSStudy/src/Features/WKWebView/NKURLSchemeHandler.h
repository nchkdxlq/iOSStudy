//
//  NKURLSchemeHandler.h
//  iOSStudy
//
//  Created by Knox on 2022/3/10.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>


NS_ASSUME_NONNULL_BEGIN


@interface NKURLSchemeHandler : NSObject <WKURLSchemeHandler>

@property (nonatomic, copy, readonly, class) NSString *scheme;

@end

NS_ASSUME_NONNULL_END
