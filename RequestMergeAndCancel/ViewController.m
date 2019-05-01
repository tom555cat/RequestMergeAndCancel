//
//  ViewController.m
//  RequestMergeAndCancel
//
//  Created by tongleiming on 2019/4/23.
//  Copyright © 2019 tongleiming. All rights reserved.
//

#import "ViewController.h"
#import "TestRequest.h"
#import "YTKNetworkConfig.h"
#import "YTKChainRequest.h"
#import "Test2Request.h"
#import "XCChainRequest.h"
#import "TestViewController.h"
#import "GCDViewController.h"

@interface ViewController () <YTKChainRequestDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self test1];
//
//    XCChainRequest *xcchain = [[XCChainRequest alloc] initWithRequestCompareBlk:^BOOL(YTKBaseRequest * _Nonnull requestA, YTKBaseRequest * _Nonnull requestB) {
//        return [self compareRequestA:requestA withRequestB:requestB];
//    }];
//
//    TestRequest *request = [[TestRequest alloc] init];
//    [xcchain addRequest:request callback:^(XCChainRequest * _Nonnull chainRequest, YTKBaseRequest * _Nonnull baseRequest) {
//        NSLog(@"1");
//    }];
//
//    TestRequest *request2 = [[TestRequest alloc] init];
//    [xcchain addRequest:request2 callback:^(XCChainRequest * _Nonnull chainRequest, YTKBaseRequest * _Nonnull baseRequest) {
//        NSLog(@"2");
//    }];
//
//    TestRequest *request3 = [[TestRequest alloc] init];
//    [xcchain addRequest:request3 callback:^(XCChainRequest * _Nonnull chainRequest, YTKBaseRequest * _Nonnull baseRequest) {
//        NSLog(@"3");
//    }];
}

- (IBAction)jumpToAnother:(id)sender {
//    TestViewController *vc = [[TestViewController alloc] init];
//    vc.view.backgroundColor = [UIColor redColor];
//    [self.navigationController pushViewController:vc animated:YES];
    
    GCDViewController *vc = [[GCDViewController alloc] init];
    vc.view.backgroundColor = [UIColor yellowColor];
    [self.navigationController pushViewController:vc animated:YES];
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


//- (BOOL)compareRequestA:(YTKBaseRequest *)requestA
//           withRequestB:(YTKBaseRequest *)requestB {
//    if ([requestA.requestUrl isEqualToString:requestB.requestUrl] &&
//        [requestA.requestUrl isEqualToString:@"api/cartnew/edit"]
//        ) {
//        // 参数相同
//        NSDictionary *paramsA = [requestA.requestArgument copy];
//        NSDictionary *paramsB = [requestB.requestArgument copy];
//        for (NSString *key in paramsA) {
//            if (![key isEqualToString:@"quantity"]) {
//                NSString *valueA = paramsA[key];
//                NSString *valueB = paramsB[key];
//                if (![valueA isEqualToString:valueB]) {
//                    return NO;
//                }
//            }
//        }
//        return YES;
//    }
//    return NO;
//}

- (void)chainRequestFinished:(YTKChainRequest *)chainRequest {
    [chainRequest stop];
    NSLog(@"chainRequest finished!");
}

- (void)chainRequestFailed:(YTKChainRequest *)chainRequest failedBaseRequest:(YTKBaseRequest *)request {
    NSLog(@"chainRequest failed! Failed request is %@", request);
}


/**
 检查重复网络请求取消
 */
- (void)test3 {
//    XCChainRequest *xcchain = [[XCChainRequest alloc] initWithRequestCompareBlk:^BOOL(YTKBaseRequest * _Nonnull requestA, YTKBaseRequest * _Nonnull requestB) {
//        return [self compareRequestA:requestA withRequestB:requestB];
//    }];
//
//    TestRequest *request = [[TestRequest alloc] init];
//    [xcchain addRequest:request callback:^(XCChainRequest * _Nonnull chainRequest, YTKBaseRequest * _Nonnull baseRequest) {
//        NSLog(@"1");
//    }];
//
//    TestRequest *request2 = [[TestRequest alloc] init];
//    [xcchain addRequest:request2 callback:^(XCChainRequest * _Nonnull chainRequest, YTKBaseRequest * _Nonnull baseRequest) {
//        NSLog(@"2");
//    }];
//
//    TestRequest *request3 = [[TestRequest alloc] init];
//    [xcchain addRequest:request3 callback:^(XCChainRequest * _Nonnull chainRequest, YTKBaseRequest * _Nonnull baseRequest) {
//        NSLog(@"3");
//    }];
}

/**
 开启就会等待执行，如果没有网络请求加入，就进入睡眠；如果有网络请求则执行网络请求
 */
- (void)test2 {
//    XCChainRequest *xcchain = [[XCChainRequest alloc] init];
//    TestRequest *request = [[TestRequest alloc] init];
//    [xcchain addRequest:request callback:^(XCChainRequest * _Nonnull chainRequest, YTKBaseRequest * _Nonnull baseRequest) {
//        NSLog(@"1");
//    }];
//    
//    TestRequest *request2 = [[TestRequest alloc] init];
//    [xcchain addRequest:request2 callback:^(XCChainRequest * _Nonnull chainRequest, YTKBaseRequest * _Nonnull baseRequest) {
//        NSLog(@"2");
//        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            TestRequest *request3 = [[TestRequest alloc] init];
//            [xcchain addRequest:request3 callback:^(XCChainRequest * _Nonnull chainRequest, YTKBaseRequest * _Nonnull baseRequest) {
//                NSLog(@"3");
//            }];
//        });
//    }];
}


/**
 测试YTK的链式请求
 */
- (void)test1 {
    
    YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
    config.baseUrl = @"http://fe.corp.daling.com/";
    
    // 第一个请求
    TestRequest *request = [[TestRequest alloc] init];
    [request setCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"success! 1");
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"failed! 1");
    }];
    //[request start];
    
    // 第二个请求
    Test2Request *request2 = [[Test2Request alloc] init];
    [request2 setCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"success! 2");
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"failed! 2");
    }];
    
    
    // 链式请求
    YTKChainRequest *chainRequest = [[YTKChainRequest alloc] init];
    chainRequest.delegate = self;
    [chainRequest addRequest:request callback:^(YTKChainRequest * _Nonnull chainRequest, YTKBaseRequest * _Nonnull baseRequest) {
        NSLog(@"请求1完成");
    }];
    [chainRequest addRequest:request2 callback:^(YTKChainRequest * _Nonnull chainRequest, YTKBaseRequest * _Nonnull baseRequest) {
        NSLog(@"请求2完成");
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            // 第三个请求
            
            /*
             *  ！！！当链式请求中所有的请求结束，再添加新的请求，新的请求不会执行。！！！
             */
            Test2Request *request3 = [[Test2Request alloc] init];
            [chainRequest addRequest:request3 callback:^(YTKChainRequest * _Nonnull chainRequest, YTKBaseRequest * _Nonnull baseRequest) {
                NSLog(@"请求3完成");
            }];
            [chainRequest start];
            
        });
    }];
    
    
    [chainRequest start];
}

@end
