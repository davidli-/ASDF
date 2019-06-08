//
//  RACNetworker.m
//  ASDF
//
//  Created by Macmafia on 2019/5/26.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import "RACNetworker.h"
#import "RACModel.h"
#import "RACSubscriber.h"
#import "RACDisposable.h"

static RACNetworker *mNetWorker;

@implementation RACNetworker

+ (instancetype)shareIns {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mNetWorker = [[RACNetworker alloc] init];
    });
    return mNetWorker;
}

- (RACSignal*)fetchRequestWithPage:(int)page size:(int)size
{
    RACSignal *s = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"++RACNetworker doing fetch~");
        //模拟网络请求 5秒后返回数据
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"++++Http responsed!");
            int count = 20;
            NSMutableArray *mutArr = [NSMutableArray arrayWithCapacity:count];
            for (int i = 0; i < count; i++) {
                RACModel *model = [[RACModel alloc] init];
                model.title = [NSString stringWithFormat:@"%d",i];
                [mutArr addObject:model];
            }
            [subscriber sendNext:mutArr];
            //如果请求出错，这里回抛错误
            //[subscriber sendError:nil];
            [subscriber sendCompleted];//必须发送完成，否则请求所在的RACCommand的信号状态为未完成，就不能继续执行-execute:
        });
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"++cleaned net");
        }];
    }];
    
    return s;
}

@end
