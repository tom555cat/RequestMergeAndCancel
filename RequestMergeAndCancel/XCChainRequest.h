//
//  XCChainRequest.h
//  RequestMergeAndCancel
//
//  Created by tongleiming on 2019/4/23.
//  Copyright © 2019 tongleiming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YTKBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@class XCChainRequest;
@class YTKBaseRequest;


typedef BOOL(^XCRequestCompareBlk)(YTKBaseRequest *requestA, YTKBaseRequest *requestB);

@interface XCChainRequest : NSObject


/**
 结束链式请求队列
 */
- (void)stop;

/**
 初始化函数

 @param blk 比较网络请求是否是重复网络请求的block
 @return 返回对象
 */
- (instancetype)initWithRequestCompareBlk:(nullable XCRequestCompareBlk)blk NS_DESIGNATED_INITIALIZER;

/**
 添加网络请求

 @param request 新增加的网络请求
 @param successBlk 网络请求的成功回调
 @param failureBlk 网络请求的失败回调
 */
- (void)addRequest:(YTKBaseRequest *)request
           success:(YTKRequestCompletionBlock)successBlk
           failure:(YTKRequestCompletionBlock)failureBlk;

/**
 取消所有的网络请求
 */
- (void)cancelAllRequests;

@end

NS_ASSUME_NONNULL_END
