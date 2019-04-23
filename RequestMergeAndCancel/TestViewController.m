//
//  TestViewController.m
//  RequestMergeAndCancel
//
//  Created by tongleiming on 2019/4/23.
//  Copyright © 2019 tongleiming. All rights reserved.
//

#import "TestViewController.h"
#import "YTKNetworkConfig.h"
#import "XCChainRequest.h"
#import "TestRequest.h"
#import "Test2Request.h"

@interface TestViewController ()

@property (nonatomic, strong) XCChainRequest *chainRequest;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
    config.baseUrl = @"http://fe.corp.daling.com/";
    
    __weak typeof(self) weakSelf = self;
    XCChainRequest *xcchain = [[XCChainRequest alloc] initWithRequestCompareBlk:^BOOL(YTKBaseRequest * _Nonnull requestA, YTKBaseRequest * _Nonnull requestB) {
        return [weakSelf compareRequestA:requestA withRequestB:requestB];
    }];
    
    TestRequest *request = [[TestRequest alloc] init];
    [xcchain addRequest:request callback:^(XCChainRequest * _Nonnull chainRequest, YTKBaseRequest * _Nonnull baseRequest) {
        NSLog(@"1");
    }];
    
    TestRequest *request2 = [[TestRequest alloc] init];
    [xcchain addRequest:request2 callback:^(XCChainRequest * _Nonnull chainRequest, YTKBaseRequest * _Nonnull baseRequest) {
        NSLog(@"2");
    }];
    
    TestRequest *request3 = [[TestRequest alloc] init];
    [xcchain addRequest:request3 callback:^(XCChainRequest * _Nonnull chainRequest, YTKBaseRequest * _Nonnull baseRequest) {
        NSLog(@"3");
    }];
    
    self.chainRequest = xcchain;
}

- (void)dealloc {
    NSLog(@"testVC dealloc!");
    [self.chainRequest stop];
    self.chainRequest = nil;
}

- (BOOL)compareRequestA:(YTKBaseRequest *)requestA
           withRequestB:(YTKBaseRequest *)requestB {
    if ([requestA.requestUrl isEqualToString:requestB.requestUrl] &&
        [requestA.requestUrl isEqualToString:@"mock/9/xc_sale/goods/defaultAddress.do"]
        ) {
        // 参数相同
        NSDictionary *paramsA = [requestA.requestArgument copy];
        NSDictionary *paramsB = [requestB.requestArgument copy];
        for (NSString *key in paramsA) {
            NSString *valueA = paramsA[key];
            NSString *valueB = paramsB[key];
            if (![valueA isEqualToString:valueB]) {
                return NO;
            }
        }
        return YES;
    }
    return NO;
}

@end
