//
//  NKBlockEntry.h
//  Interview
//
//  Created by Knox on 2021/5/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NKBlockEntry : NSObject

+ (void)entry;


@end


@interface NKBlockEntry ()

@property (nonatomic, assign) NSInteger age;

- (void)play;

@end


NS_ASSUME_NONNULL_END
