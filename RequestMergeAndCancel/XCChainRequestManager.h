//
//  XCChainRequestManager.h
//  RequestMergeAndCancel
//
//  Created by tom555cat on 2019/4/23.
//  Copyright © 2019年 tongleiming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YTKBaseRequest.h"

@interface XCChainRequestManager : NSObject

- (instancetype)initWithRequestCompareBlk:(BOOL(^)(YTKBaseRequest *requst1, YTKBaseRequest *requst2))cmpBlk NS_DESIGNATED_INITIALIZER;


/**
 增加网络请求到串行队列中

 @param request 新增网络请求
 @param successBlk 网络请求成功回调
 @param failureBlk 网络请求失败回调
 */
- (void)addRequest:(YTKBaseRequest *)request
           success:(YTKRequestCompletionBlock)successBlk
           failure:(YTKRequestCompletionBlock)failureBlk;

@end
