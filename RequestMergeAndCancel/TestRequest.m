//
//  TestRequest.m
//  RequestMergeAndCancel
//
//  Created by tongleiming on 2019/4/23.
//  Copyright © 2019 tongleiming. All rights reserved.
//

#import "TestRequest.h"

@implementation TestRequest

- (NSString *)requestUrl {
    return @"mock/9/xc_sale/goods/defaultAddress.do";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

@end
