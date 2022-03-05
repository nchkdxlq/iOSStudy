//
//  NKLaunchMetrics.h
//  iOSStudy
//
//  Created by Knox on 2022/3/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*
 
 整体启动耗时分为两部分, main还是之前, main函数到首帧渲染完成
 start -----> main ------> firstFrame
 
 */

@interface NKLaunchMetrics : NSObject


// mian函数
+ (void)main;

// AppDelegate didFinishLaunchingWithOptions 函数开始
+ (void)didFinishLaunchingBegin;

// AppDelegate didFinishLaunchingWithOptions 函数结束
+ (void)didFinishLaunchingEnd;

// 首帧渲染完成, 一般在首页控制器的 viewDidAppear 方法中调用
+ (void)firstFrameDidRender;


@end

NS_ASSUME_NONNULL_END
