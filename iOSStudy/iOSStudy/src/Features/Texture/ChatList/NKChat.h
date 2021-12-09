//
//  NKChat.h
//  iOSStudy
//
//  Created by Knox on 2021/12/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NKChat : NSObject

@property (nonatomic, copy) NSString *avatar;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *desc;

@property (nonatomic, strong) NSDate *updateTime;

@end

NS_ASSUME_NONNULL_END
