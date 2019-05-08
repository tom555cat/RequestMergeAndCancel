//
//  XCChainRequestManager.m
//  RequestMergeAndCancel
//
//  Created by tom555cat on 2019/4/23.
//  Copyright © 2019年 tongleiming. All rights reserved.
//

#import "XCChainRequestManager.h"
#import "XCChainRequest.h"

@interface XCChainRequestManager ()

@property (nonatomic, strong) XCChainRequest *chainRequest;

@end

@implementation XCChainRequestManager

- (instancetype)initWithRequestCompareBlk:(BOOL (^)(YTKBaseRequest *, YTKBaseRequest *))cmpBlk {
    self = [super init];
    if (self) {
        self.chainRequest = [[XCChainRequest alloc] initWithRequestCompareBlk:cmpBlk];
    }
    return self;
}

- (instancetype)init {
    return [self initWithRequestCompareBlk:nil];
}

- (void)dealloc {
    [self.chainRequest stop];
}

- (void)addRequest:(YTKBaseRequest *)request
           success:(YTKRequestCompletionBlock)successBlk
           failure:(YTKRequestCompletionBlock)failureBlk {
    [self.chainRequest addRequest:request success:successBlk failure:failureBlk];
}

- (void)cancelAllRequests {
    [self.chainRequest cancelAllRequests];
}

@end
