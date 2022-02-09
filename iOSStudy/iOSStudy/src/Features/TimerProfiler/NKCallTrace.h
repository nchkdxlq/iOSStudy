//
//  NKCallTrace.h
//  iOSStudy
//
//  Created by Knox on 2022/1/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NKCallTrace : NSObject

+ (void)start;

+ (void)stop;


+ (void)getCallRecords;


@end

NS_ASSUME_NONNULL_END
