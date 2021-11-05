//
//  NKProcessInfo.h
//  iOSStudy
//
//  Created by Knox on 2021/11/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class NKThread;

@interface NKProcessInfo : NSObject

@property (nonatomic, assign, readonly) NSArray<NKThread *> *threads;

+ (nullable instancetype)processInfo;

+ (instancetype)processWithThreadCount:(NSInteger)threadCount threads:(thread_act_array_t)threads;
- (instancetype)initWithThreadCount:(NSInteger)threadCount threads:(thread_act_array_t)threads;

@end

NS_ASSUME_NONNULL_END
