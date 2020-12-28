//
//  NKAsyncLayer.h
//  iOSStudy
//
//  Created by Knox on 2020/12/27.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - NKAsyncLayerDisplayTask

@interface NKAsyncLayerDisplayTask : NSObject

@property (nullable, nonatomic, copy) void(^willDisplay)(CALayer *layer);

@property (nullable, nonatomic, copy) void(^display)(CGContextRef context, CGSize size, BOOL(^isCancelled)(void));

@property (nullable, nonatomic, copy) void(^didDisplay)(CALayer *layer, BOOL finished);

@end

#pragma mark -

@protocol NKAsyncLayerDelegate <NSObject>

@required
- (NKAsyncLayerDisplayTask *)newAsyncDisplayTask;

@end

#pragma mark - NKAsyncLayer

@interface NKAsyncLayer : CALayer

@property (nonatomic, assign) BOOL displaysAsynchronously;

@end

NS_ASSUME_NONNULL_END
