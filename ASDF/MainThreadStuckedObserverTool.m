//
//  MainThreadStuckedObserverTool.m
//  ASDF
//
//  Created by Macmafia on 2018/12/18.
//  Copyright © 2018 Macmafia. All rights reserved.
//

#import "MainThreadStuckedObserverTool.h"
#import <libkern/OSAtomic.h>
#import <execinfo.h>

static MainThreadStuckedObserverTool *mTool;

@interface MainThreadStuckedObserverTool()
{
    dispatch_queue_t mConcurrentQueue;
    NSDate *lastDate;
    BOOL isMainExcuting;
    NSMutableArray *backtraces;
}
@end

@implementation MainThreadStuckedObserverTool

+ (instancetype)shareTool{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mTool = [[MainThreadStuckedObserverTool alloc] init];
    });
    return mTool;
}

- (void)addObserverToMainThread{
    //创建观察者
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        //观察者回调
        switch (activity) {
            case kCFRunLoopEntry:
                NSLog(@"observer： kCFRunLoopEntry...");
                break;
                
            case kCFRunLoopBeforeTimers:
                NSLog(@"observer： kCFRunLoopBeforeTimers...");
                break;
            //开始处理事件
            case kCFRunLoopBeforeSources:
                isMainExcuting = YES;
                lastDate = [NSDate date];
                NSLog(@"observer： kCFRunLoopBeforeSources...");
                break;
            //处理完事件，即将休眠
            case kCFRunLoopBeforeWaiting:
                isMainExcuting = NO;
                lastDate = nil;
                NSLog(@"observer： kCFRunLoopBeforeWaiting...");
                break;
            //将被唤醒
            case kCFRunLoopAfterWaiting:
                isMainExcuting = YES;
                NSLog(@"observer： kCFRunLoopAfterWaiting...");
                break;
                
            case kCFRunLoopExit:
                NSLog(@"observer： kCFRunLoopExit...");
                break;
                
            default:
                break;
        }
    });
    CFRunLoopAddObserver(CFRunLoopGetMain(), observer, kCFRunLoopCommonModes);
    
    //定时器隔一段时间检测一次主线程是否卡顿
    if (!mConcurrentQueue) {
        mConcurrentQueue = dispatch_queue_create("addObserverQueue", DISPATCH_QUEUE_CONCURRENT);
    }
    dispatch_async(mConcurrentQueue, ^{
        dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, mConcurrentQueue);
        dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
        dispatch_source_set_event_handler(timer, ^{
            if (isMainExcuting && lastDate) {//如果主线程在执行任务
                NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:lastDate];
                NSLog(@"++++time:%f",interval);
                if (interval > 1) {
                    NSLog(@"+++卡顿了~~~~");
                    [self callStack];
                }
            }
        });
        dispatch_resume(timer);
        
        //启动子线程的runloop
        [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSRunLoopCommonModes];
        CFRunLoopRun();
    });
}

- (void)callStack{
    void* callstack[128];
    int frames = backtrace(callstack, 128);
    char **strs = backtrace_symbols(callstack, frames);
    int i;
    if (!backtraces) {
        backtraces = [NSMutableArray arrayWithCapacity:frames];
    }
    for ( i = 0 ; i < frames ; i++ ){
        [backtraces addObject:[NSString stringWithUTF8String:strs[i]]];
    }
    NSLog(@"+++堆栈信息:%@",backtraces);
    free(strs);
}

+ (void)monitorBussy
{
    NSLog(@"++++模拟卡顿执行开始");
    for (NSInteger i = 0; i < 1000000000; i++) {
    }
    NSLog(@"++++模拟卡顿执行完成");
}
@end
