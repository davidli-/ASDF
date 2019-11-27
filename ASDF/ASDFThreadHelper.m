//
//  ASDFThreadHelper.m
//  ASDF
//
//  Created by Macmafia on 2018/12/21.
//  Copyright © 2018 Macmafia. All rights reserved.
//

#import "ASDFThreadHelper.h"
#import "ASDFThread.h"

@interface ASDFThreadHelper()
@property (nonatomic, strong) ASDFThread *mThread;
@property (nonatomic, strong) NSCondition *mConditionLock;
@end

@implementation ASDFThreadHelper

//MARK: -APIs
-(instancetype)initWithName:(NSString*)name{
    if (self = [super init]) {
//        _mConditionLock = [[NSCondition alloc] init];
        _mThread = [[ASDFThread alloc] initWithTarget:self selector:@selector(onThreadInit:) object:nil];
        _mThread.name = name;
    }
    return self;
}

- (void)start{
    // 加锁 防止多线程环境下 threadInit中尚未初始化完线程就调用其start的情况
    [_mConditionLock lock];
    [_mConditionLock wait];
    [_mThread start];
    [_mConditionLock unlock];
}

- (void)stop{
    // 回到所在线程 停止其runloop
    [self performSelector:@selector(finish) onThread:_mThread withObject:nil waitUntilDone:NO];
}

-(NSThread *)getThread{
    return _mThread;
}

//MARK: -Self Business
- (void)onThreadInit:(id)obj{
    NSLog(@"%@ ------ Start", [NSThread currentThread]);
    
    // 线程保活
    CFRunLoopSourceContext context = {0};
    context.perform = DoNothingRunLoopCallback;
    
    CFRunLoopSourceRef source = CFRunLoopSourceCreate(NULL, 0, &context);
    CFRunLoopAddSource(CFRunLoopGetCurrent(), source, kCFRunLoopCommonModes);
    
    [_mConditionLock lock];
    [_mConditionLock signal]; // 线程创建和设置已完成，告诉其他线程可以执行start了
    [_mConditionLock unlock];
    
    // 开启runloop，开始处理任务
    CFRunLoopRun(); // 开启循环，在被停止前会一直运行在这一行
    
    // runloop已被停止 执行清理任务
    CFRunLoopRemoveSource(CFRunLoopGetCurrent(), source, kCFRunLoopCommonModes);
    CFRelease(source);
    
    NSLog(@"%@ ------ End", [NSThread currentThread]);
}

- (void)finish{
    CFRunLoopStop(CFRunLoopGetCurrent());
}

static void DoNothingRunLoopCallback(void *info){
    NSLog(@"+++runloop 回调~");
}

@end
