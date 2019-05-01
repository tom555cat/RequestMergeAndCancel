//
//  GCDViewController.m
//  RequestMergeAndCancel
//
//  Created by tongleiming on 2019/4/30.
//  Copyright © 2019 tongleiming. All rights reserved.
//

#import "GCDViewController.h"
#import "TestRequest.h"
#import "YTKNetworkConfig.h"

@interface GCDViewController ()

@end

@implementation GCDViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
    config.baseUrl = @"http://fe.corp.daling.com/";
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"%@", self);
    });
    NSLog(@"");
}

- (void)dealloc {
    NSLog(@"GCDViewController被释放!");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
