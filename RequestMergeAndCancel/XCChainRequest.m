//
//  XCChainRequest.m
//  RequestMergeAndCancel
//
//  Created by tongleiming on 2019/4/23.
//  Copyright © 2019 tongleiming. All rights reserved.
//

#import "XCChainRequest.h"
#import "YTKBaseRequest.h"

typedef NS_ENUM(NSInteger, XCChainRequestState) {
    XCChainRequestStopped = 0,
    XCChainRequestStarted = 1
};

@interface XCChainRequest () <YTKRequestDelegate>

// 网络请求队列
@property (nonatomic, strong) NSMutableArray<YTKBaseRequest *> *requestArray;
// 网络请求回调队列
@property (nonatomic, strong) NSMutableArray<XCChainCallback> *requestCallbackArray;
// 一个空的网络请求回调
@property (nonatomic, strong) XCChainCallback emptyCallback;
// 当前执行的网络请求
@property (nonatomic, strong) YTKBaseRequest *currentRequest;
// 当前执行的网络请求回调
@property (nonatomic, copy) XCChainCallback currentCallback;
// request请求生产和消费信号量
@property (nonatomic, strong) dispatch_semaphore_t requestSemaphore;
// request处理中信号量
@property (nonatomic, strong) dispatch_semaphore_t requestProcessSemaphore;
// requestArray读写锁
@property (nonatomic, strong) dispatch_semaphore_t requestArrayLock;
// 判断request是否重复的block
@property (nonatomic, copy) XCRequestCompareBlk compareBlk;
// 添加网络请求的队列
@property (nonatomic, strong) dispatch_queue_t addRequstQueue;
// 处理网络请求的队列
@property (nonatomic, strong) dispatch_queue_t processRequestQueue;
// 当前状态
@property (nonatomic, assign) XCChainRequestState currentState;

@end

@implementation XCChainRequest

- (instancetype)initWithRequestCompareBlk:(XCRequestCompareBlk)blk {
    self = [super init];
    if (self) {
        _requestArray = [NSMutableArray array];
        _requestCallbackArray = [NSMutableArray array];
        _emptyCallback = ^(XCChainRequest *chainRequest, YTKBaseRequest *baseRequest) {};
        _requestProcessSemaphore = dispatch_semaphore_create(1);
        _requestSemaphore = dispatch_semaphore_create(0);
        _requestArrayLock = dispatch_semaphore_create(1);
        _compareBlk = blk;
        // 添加网络请求的队列，为了保证有序添加，需要串行队列
        _addRequstQueue = dispatch_queue_create("XCChainRequestAddRequestQueue", DISPATCH_QUEUE_SERIAL);
        // 处理网络请求的队列，由于是死循环，所以串行队列就可以
        _processRequestQueue = dispatch_queue_create("XChainRequestProcessQueue", DISPATCH_QUEUE_SERIAL);
        
        _currentState = XCChainRequestStarted;
        [self start];
    }
    return self;
}

- (instancetype)init {
    return [self initWithRequestCompareBlk:nil];
}

- (void)stop {
    dispatch_semaphore_wait(self.requestArrayLock, DISPATCH_TIME_FOREVER);
    // 设置状态为停止
    self.currentState = XCChainRequestStopped;
    // 移出网络请求和回调
    [self.requestArray removeAllObjects];
    [self.requestCallbackArray removeAllObjects];
    // 停止当前网络请求
    [self.currentRequest stop];
    // 添加网络请求信号量和网络请求处理信号量+1，以便于start中的while循环进行下去
    dispatch_semaphore_signal(self.requestProcessSemaphore);
    dispatch_semaphore_signal(self.requestSemaphore);
    dispatch_semaphore_signal(self.requestArrayLock);
}

- (void)dealloc {
    NSLog(@"dealloc调用，被销毁");
}

- (void)start {
    __weak typeof(self) weakSelf = self;
    dispatch_async(self.processRequestQueue, ^{
        while (weakSelf && weakSelf.currentState == XCChainRequestStarted) {
            
            // 等待提交的请求
            dispatch_semaphore_wait(weakSelf.requestSemaphore, DISPATCH_TIME_FOREVER);
            
            // 等待当前网络请求执行完成
            if (weakSelf) {
                dispatch_semaphore_wait(weakSelf.requestProcessSemaphore, DISPATCH_TIME_FOREVER);
            } else {
                return;
            }
            
            // 网络请求队列加锁
            if (weakSelf) {
                dispatch_semaphore_wait(weakSelf.requestArrayLock, DISPATCH_TIME_FOREVER);
            } else {
                return;
            }
            
            
            // 由于会删除”重复“的请求，所以在最后几次进入时requestArray中已经没有元素了
            if (weakSelf.requestArray.count > 0) {
                weakSelf.currentRequest = [weakSelf.requestArray firstObject];
                weakSelf.currentCallback = [weakSelf.requestCallbackArray firstObject];
                [weakSelf.requestArray removeObjectAtIndex:0];
                [weakSelf.requestCallbackArray removeObjectAtIndex:0];
                weakSelf.currentRequest.delegate = weakSelf;
                [weakSelf.currentRequest clearCompletionBlock];
                [weakSelf.currentRequest start];
                NSLog(@"%@:当前执行的网络请求: %@", [NSThread currentThread], weakSelf.currentRequest);
            }
            
            // 网络请求队列锁释放
            if (weakSelf) {
                dispatch_semaphore_signal(weakSelf.requestArrayLock);
            } else {
                return;
            }
            
        }
    });
}

- (void)addRequest:(YTKBaseRequest *)request callback:(XCChainCallback)callback {
    __weak typeof(self) weakSelf = self;
    dispatch_async(self.addRequstQueue, ^{
        
        // 网络请求队列加锁
        dispatch_semaphore_wait(weakSelf.requestArrayLock, DISPATCH_TIME_FOREVER);
        
        if (weakSelf.compareBlk) {
            // 比较新加网络请求和当前网络请求是否可以复用
            if (weakSelf.currentRequest && weakSelf.compareBlk(weakSelf.currentRequest, request)) {
                NSLog(@"%@:删除当前网络请求: %@", [NSThread currentThread], weakSelf.currentRequest);
                [weakSelf.currentRequest stop];
                // 取消的任务YTKNetwork不会去执行request的失败回调，需要手动调用
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf requestFailed:weakSelf.currentRequest];
                });
            }
            // 比较新加网络请求和请求列表中的网络请求是否可以复用
            for (NSInteger i = weakSelf.requestArray.count - 1; i >= 0; i--) {
                if (weakSelf.compareBlk(weakSelf.requestArray[i], request)) {
                    NSLog(@"%@:删除网络请求队列中的网络请求: %@", [NSThread currentThread], weakSelf.requestArray[i]);
                    [weakSelf.requestArray removeObjectAtIndex:i];
                    [weakSelf.requestCallbackArray removeObjectAtIndex:i];
                }
            }
        }
        
        [weakSelf.requestArray addObject:request];
        if (callback != nil) {
            [weakSelf.requestCallbackArray addObject:callback];
        } else {
            [weakSelf.requestCallbackArray addObject:weakSelf.emptyCallback];
        }
        
        // 网络请求队列锁释放
        dispatch_semaphore_signal(weakSelf.requestArrayLock);
        
        // 请求信号量+1
        dispatch_semaphore_signal(weakSelf.requestSemaphore);
    });
}

- (void)resetCurrentRequest {
    self.currentRequest = nil;
    self.currentCallback = nil;
}

#pragma mark - YTKRequestDelegate

- (void)requestFinished:(__kindof YTKBaseRequest *)request {
    if (self.currentCallback) {
        self.currentCallback(self, request);
    }
    NSLog(@"%@:当前网络请求执行完成: %@", [NSThread currentThread], self.currentRequest);
    [self resetCurrentRequest];
    dispatch_semaphore_signal(self.requestProcessSemaphore);
}

- (void)requestFailed:(__kindof YTKBaseRequest *)request {
    NSLog(@"%@:当前网络请求执行失败: %@", [NSThread currentThread], self.currentRequest);
    [self resetCurrentRequest];
    dispatch_semaphore_signal(self.requestProcessSemaphore);
}

@end
