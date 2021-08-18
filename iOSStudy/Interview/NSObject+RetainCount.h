//
//  NSObject+RetainCount.h
//  Interview
//
//  Created by Knox on 2021/5/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (RetainCount)

- (NSUInteger)getRetainCount;

@end

NS_ASSUME_NONNULL_END
