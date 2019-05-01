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
#import "XCChainRequestManager.h"
#import "CCManager.h"

@interface TestViewController ()

@property (nonatomic, strong) XCChainRequestManager *chainRequest;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    //button.backgroundColor = [UIColor yellowColor];
    [button setTitle:@"request1" forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 100, 100, 50);
    [button addTarget:self action:@selector(addNewRequest:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];

    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    //button.backgroundColor = [UIColor yellowColor];
    [button2 setTitle:@"request1" forState:UIControlStateNormal];
    button2.frame = CGRectMake(0, 200, 100, 50);
    [button2 addTarget:self action:@selector(addNewRequest2:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
    
//    CCManager *manager = [CCManager sharedInstance];
//    NSLog(@"%@", manager);
    
    YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
    config.baseUrl = @"http://fe.corp.daling.com/";
    
    __weak typeof(self) weakSelf = self;
    
    XCChainRequestManager *m = [[XCChainRequestManager alloc] initWithRequestCompareBlk:^BOOL(YTKBaseRequest *requst1, YTKBaseRequest *requst2) {
        return [weakSelf compareRequestA:requst1 withRequestB:requst2];
    }];
    
    NSLog(@"123");
    
    TestRequest *request = [[TestRequest alloc] init];
    [m addRequest:request success:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"1 success!");
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"1 fail!");
    }];
    
    TestRequest *request2 = [[TestRequest alloc] init];
    [m addRequest:request2 success:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"2 success!");
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"2 fail!");
    }];

    Test2Request *request3 = [[Test2Request alloc] init];
    [m addRequest:request3 success:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"3 success!");
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"3 failed!");
    }];

    TestRequest *request4 = [[TestRequest alloc] init];
    [m addRequest:request4 success:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"4 sucess!");
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"4 fail!");
    }];
    
    self.chainRequest = m;
}

- (void)dealloc {
    NSLog(@"testVC dealloc!");
}

- (void)addNewRequest:(id)sender {
    static int a = 100;
    TestRequest *request = [[TestRequest alloc] init];
    [self.chainRequest addRequest:request success:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"--%d 成功!", a);
        a += 1;
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"--%d 失败!, %@", a, request.error.userInfo[NSLocalizedDescriptionKey]);
        a += 1;
    }];
}

- (void)addNewRequest2:(id)sender {
    static int b = 50;
    Test2Request *request = [[Test2Request alloc] init];
    [self.chainRequest addRequest:request success:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"--%d 成功!", b);
        b += 1;
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"--%d 失败!, %@", b, request.error.userInfo[NSLocalizedDescriptionKey]);
        b += 1;
    }];
}


/**
 测试不会非重复网络请求能够正常发送
 */
- (void)test2 {
    __weak typeof(self) weakSelf = self;
    
    XCChainRequestManager *m = [[XCChainRequestManager alloc] initWithRequestCompareBlk:^BOOL(YTKBaseRequest *requst1, YTKBaseRequest *requst2) {
        return [weakSelf compareRequestA:requst1 withRequestB:requst2];
    }];
    
    NSLog(@"123");
    
    TestRequest *request = [[TestRequest alloc] init];
    [m addRequest:request success:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"1 sucess!");
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"1 fail!");
    }];
    
    TestRequest *request2 = [[TestRequest alloc] init];
    [m addRequest:request2 success:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"2 sucess!");
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"2 fail!");
    }];
    
    Test2Request *request3 = [[Test2Request alloc] init];
    [m addRequest:request3 success:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"3 success!");
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"3 failed!");
    }];
    
    TestRequest *request4 = [[TestRequest alloc] init];
    [m addRequest:request4 success:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"4 sucess!");
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"4 fail!");
    }];
}

/**
 测试重复网络请求删除
 */
- (void)test1 {
    __weak typeof(self) weakSelf = self;
    XCChainRequestManager *m = [[XCChainRequestManager alloc] initWithRequestCompareBlk:^BOOL(YTKBaseRequest *requst1, YTKBaseRequest *requst2) {
        return [weakSelf compareRequestA:requst1 withRequestB:requst2];
    }];
    
    TestRequest *request = [[TestRequest alloc] init];
    [m addRequest:request success:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"1 sucess!");
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"1 fail!");
    }];
    
    TestRequest *request2 = [[TestRequest alloc] init];
    [m addRequest:request2 success:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"2 sucess!");
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"2 fail!");
    }];
    
    TestRequest *request3 = [[TestRequest alloc] init];
    [m addRequest:request3 success:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"3 sucess!");
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"3 fail!");
    }];
    
    self.chainRequest = m;
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
