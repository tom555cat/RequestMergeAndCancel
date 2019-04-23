//
//  Test2Request.m
//  RequestMergeAndCancel
//
//  Created by tongleiming on 2019/4/23.
//  Copyright © 2019 tongleiming. All rights reserved.
//

#import "Test2Request.h"

@implementation Test2Request

- (NSString *)requestUrl {
    return @"mock/9/xc_sale/resource/app/version/updateCheck.do";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}


@end
