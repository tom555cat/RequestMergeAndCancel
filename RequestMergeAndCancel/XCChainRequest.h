//
//  XCChainRequest.h
//  RequestMergeAndCancel
//
//  Created by tongleiming on 2019/4/23.
//  Copyright © 2019 tongleiming. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class XCChainRequest;
@class YTKBaseRequest;



typedef BOOL(^XCRequestCompareBlk)(YTKBaseRequest *requestA, YTKBaseRequest *requestB);

@interface XCChainRequest : NSObject

///**
// 启动链式队里请求
// */
//- (void)start;
//
///**
// 结束链式请求队列
// */
- (void)stop;

- (instancetype)initWithRequestCompareBlk:(nullable XCRequestCompareBlk)blk NS_DESIGNATED_INITIALIZER;

/**
 增加网络请求到链式请求中

 @param request 网络请求
 @param callback 网络请求执行完毕的回调
 */
- (void)addRequest:(YTKBaseRequest *)request callback:(nullable XCChainCallback)callback;

@end

NS_ASSUME_NONNULL_END
