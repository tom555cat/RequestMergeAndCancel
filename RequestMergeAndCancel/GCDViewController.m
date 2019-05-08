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

@property (nonatomic, strong) dispatch_semaphore_t semaphore;
@property (nonatomic, strong) dispatch_queue_t queue;

@end

@implementation GCDViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
    config.baseUrl = @"http://fe.corp.daling.com/";
    
    self.semaphore = dispatch_semaphore_create(1);
    self.queue = dispatch_queue_create("myqueu", DISPATCH_QUEUE_SERIAL);

    __weak typeof(self) weakSelf = self;
    dispatch_async(self.queue, ^{
        if (weakSelf == nil) {
            return;
        }
        __strong GCDViewController *strongSelf = weakSelf;
        dispatch_semaphore_wait(strongSelf.semaphore, DISPATCH_TIME_FOREVER);
        [NSThread sleepForTimeInterval:10];
        dispatch_semaphore_signal(strongSelf.semaphore);
    });

    dispatch_async(self.queue, ^{
        if (weakSelf == nil) {
            return;
        }
        __strong GCDViewController *strongSelf = weakSelf;
        dispatch_semaphore_wait(strongSelf.semaphore, DISPATCH_TIME_FOREVER);
        [NSThread sleepForTimeInterval:10];
        dispatch_semaphore_signal(strongSelf.semaphore);
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
