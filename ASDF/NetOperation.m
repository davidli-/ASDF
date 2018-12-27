//
//  NetOperation.m
//  ASDF
//
//  Created by Macmafia on 2017/11/17.
//  Copyright © 2017年 Macmafia. All rights reserved.
//

#import "NetOperation.h"

@interface NetOperation()

@property (nonatomic, copy) NSString *mUrlStr;
@property (nonatomic, weak) id<NetOperationDelegate>delegate;
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;
@end

@implementation NetOperation
//因为父类的属性是readonly的，重载时如果需要setter的话则需要手动合成。
@synthesize finished = _finished, executing = _executing;

// 这里需要实现KVO相关的方法，NSOperationQueue是通过KVO来判断任务状态的
- (void)setFinished:(BOOL)finished {
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}

- (void)setExecuting:(BOOL)executing {
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

- (instancetype)initWithUrl:(NSString *)url
                   delegate:(id<NetOperationDelegate>)delegate{
    if (self = [super init]) {
        _delegate = delegate;
        _mUrlStr = url;
    }
    return self;
}

- (BOOL)isAsynchronous{
    return YES;
}

- (void)dealloc{
    _delegate = nil;
}

#pragma mark -重载start方法 实现业务需求
- (void)start {
    if (self.isCancelled) {
        self.finished = YES;
        return;
    }
    NSLog(@"+++start:%@",[NSThread currentThread]);
    [self main];
    self.executing = YES;
}

//- (void)main
//{
//    NSLog(@"+++++main:%@",[NSThread currentThread]);
//    if (self.isCancelled) return;
//    NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:_mUrlStr]];
//    if (self.isCancelled) {
//        imageData = nil;
//        return;
//    }
//    if (self.isCancelled) return;
//    if ([_delegate respondsToSelector:@selector(downloadFinishedWithData:)]) {
//        [_delegate downloadFinishedWithData:imageData];
//    }
//}

- (void)cancel {
    [super cancel];
    // 如果正在执行中则表示已经start过，可以将isFinished设为yes
    if (self.isExecuting) {
        self.finished = YES;
        self.executing = NO;
    }
    [_dataTask cancel];
}

#pragma mark -BUSINESS
- (void)main{
    NSURLSession *session = [NSURLSession sharedSession];
    __weak typeof(self) weakSelf = self;
    _dataTask = [session dataTaskWithURL:[NSURL URLWithString:_mUrlStr]
                       completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.finished = YES;
            strongSelf.executing = NO;
            NSLog(@"+++dataBack:%@",[NSThread currentThread]);
            if ([strongSelf.delegate respondsToSelector:@selector(downloadFinishedWithData:)]) {
                [strongSelf.delegate downloadFinishedWithData:data];
            }
        }
    }];
    //开始任务
    [_dataTask resume];
}
@end
