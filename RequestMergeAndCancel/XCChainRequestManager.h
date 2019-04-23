//
//  XCChainRequestManager.h
//  RequestMergeAndCancel
//
//  Created by tom555cat on 2019/4/23.
//  Copyright © 2019年 tongleiming. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YTKBaseRequest;

typedef void(^XCChainCallback)(XCChainRequest *chainRequest, YTKBaseRequest *baseRequest);

@interface XCChainRequestManager : NSObject

- (void)addRequest:(YTKBaseRequest *)request callback:(nullable XCChainCallback)callback;

@end
