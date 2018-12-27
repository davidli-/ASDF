//
//  RunloopHelper.m
//  ASDF
//
//  Created by Macmafia on 2018/12/14.
//  Copyright © 2018 Macmafia. All rights reserved.
//

#import "RunloopHelper.h"
#import "MyWorkerClass.h"

@interface RunloopHelper()<NSPortDelegate>
@property CFRunLoopRef mRunLoopRef;
@property CFRunLoopSourceRef mSourceRef;
@property (nonatomic, strong) NSThread *thread;
@end

@implementation RunloopHelper

static void sourcePerformor(void* info)
{
    NSLog(@"处理自定义输入源事件");
}

void DoNothingRunLoopCallback()
{
    NSLog(@"+++");
}

- (void)customInputsource
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSLog(@"开启线程.......");
        
        _mRunLoopRef = CFRunLoopGetCurrent();
        
        //创建CFRunLoopSourceContext对象
        CFRunLoopSourceContext mContext;
        bzero(&mContext, sizeof(mContext));
        
        //给context对象绑定一个函数
        mContext.perform = sourcePerformor;
        mContext.info = "information";
        
        //创建CFRunLoopSourceRef对象
        _mSourceRef = CFRunLoopSourceCreate(NULL, 0, &mContext);
        
        //将source添加到当前RunLoop中
        CFRunLoopAddSource(_mRunLoopRef, _mSourceRef, kCFRunLoopDefaultMode);
        
        //开启Runloop
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, 10000, YES);
        
        NSLog(@"线程结束.......");
    });
    
    //2秒后执行
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (CFRunLoopIsWaiting(_mRunLoopRef)) {
            NSLog(@"RunLoop正在等待事件输入+++");
            //添加输入事件
            CFRunLoopSourceSignal(_mSourceRef);
            //唤醒线程，线程唤醒后发现由事件需要处理，于是立即处理事件
            CFRunLoopWakeUp(_mRunLoopRef);
        }else {
            NSLog(@"RunLoop正在处理事件+++");
            //添加输入事件，当前正在处理一个事件，当前事件处理完成后，立即处理当前新输入的事件
            CFRunLoopSourceSignal(_mSourceRef);
        }
    });
}

- (void)testDemo1
{
    dispatch_async(dispatch_get_global_queue(0,0), ^ {
        NSLog(@"线程开始");
        // 获取当前线程
        self.thread = [NSThread currentThread];
        NSRunLoop *runloop = [NSRunLoop currentRunLoop];
        // 添加一个Port，同理为了防止runloop没事干直接退出
        [runloop addPort: [NSMachPort port] forMode: NSDefaultRunLoopMode];
        // 运行一个runloop， [NSDate distantFuture]:很久很久以后才让它失效
        [runloop runMode:NSDefaultRunLoopMode beforeDate: [NSDate distantFuture]];
        NSLog(@"线程结束");
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,(int64_t)(2*NSEC_PER_SEC)), dispatch_get_main_queue(), ^ {
        // 在我们开启的异步线程调用方法
        [self performSelector:@selector(recieveMsg) onThread: self.thread withObject: nil waitUntilDone: NO];
    });
}


- (void)recieveMsg
{
    NSLog(@"收到消息了，在这个线程：%@", [NSThread currentThread]);
}


- (void)runloopReturnTest
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSRunLoop *mRunloop = [NSRunLoop currentRunLoop];
        
        // Create a run loop observer and attach it to the run loop.
        CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault,
                                                                           kCFRunLoopAllActivities,
                                                                           YES, 0,
                                                                           ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
                                                                               switch (activity) {
                                                                                   case kCFRunLoopEntry:
                                                                                       NSLog(@"observer： kCFRunLoopEntry...");
                                                                                       break;
                                                                                       
                                                                                   case kCFRunLoopBeforeTimers:
                                                                                       NSLog(@"observer： kCFRunLoopBeforeTimers...");
                                                                                       break;
                                                                                       
                                                                                   case kCFRunLoopBeforeSources:
                                                                                       NSLog(@"observer： kCFRunLoopBeforeSources...");
                                                                                       break;
                                                                                       
                                                                                   case kCFRunLoopBeforeWaiting:
                                                                                       NSLog(@"observer： kCFRunLoopBeforeWaiting...");
                                                                                       break;
                                                                                       
                                                                                   case kCFRunLoopAfterWaiting:
                                                                                       NSLog(@"observer： kCFRunLoopAfterWaiting...");
                                                                                       break;
                                                                                       
                                                                                   case kCFRunLoopExit:
                                                                                       NSLog(@"observer： kCFRunLoopExit...");
                                                                                       break;
                                                                                       
                                                                                   default:
                                                                                       break;
                                                                               }
                                                                           });
        
        if (observer)
        {
            CFRunLoopRef cfLoop = [mRunloop getCFRunLoop];
            CFRunLoopAddObserver(cfLoop, observer, kCFRunLoopDefaultMode);
        }
        
        NSLog(@"This thread starting.......");
        
        //新增计时器源并加入runloop
        NSTimer *timer = [NSTimer timerWithTimeInterval:5
                                                 target:self
                                               selector:@selector(onHandleTask:)
                                               userInfo:nil
                                                repeats:NO];
        [mRunloop addTimer:timer forMode:NSDefaultRunLoopMode];
        
        //最后一个参数：是否处理完事件返回，结束runLoop
        SInt32 result = CFRunLoopRunInMode(kCFRunLoopDefaultMode, 100, YES);
        
        switch (result) {
            case kCFRunLoopRunFinished:
                NSLog(@"kCFRunLoopRunFinished");
                break;
                
            case kCFRunLoopRunStopped:
                NSLog(@"kCFRunLoopRunStopped");
                break;
                
            case kCFRunLoopRunTimedOut:
                NSLog(@"kCFRunLoopRunTimedOut");
                break;
                
            case kCFRunLoopRunHandledSource:
                NSLog(@"kCFRunLoopRunHandledSource");
                break;
                
            default:
                break;
        }
        
        CFRelease(observer);
        NSLog(@"This thread end.......");
    });
    
}

- (void)onHandleTask:(NSTimer *)timer
{
    [timer invalidate];
    NSLog(@"timer Fired...");
}

- (void)runloopPortTest
{
    //创建端口
    NSPort *PORT1 = [NSMachPort new];
    NSPort *PORT2 = [NSMachPort port];
    
    NSLog(@"\nPORT1:%@ \nPORT2:%@",PORT1, PORT2);
    
    //设置端口的代理
    PORT1.delegate = self;
    PORT2.delegate = self;
    
    //给主线程runloop加一个端口
    [[NSRunLoop currentRunLoop] addPort:PORT1 forMode:NSDefaultRunLoopMode];
    
    //给辅助线程添加端口
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [[NSRunLoop currentRunLoop] addPort:PORT2 forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    });
    
    //component参数数组中只能包含两种类型的数据：一种是NSPort的子类，一种是NSData的子类；
    NSString *STR = @"III";
    NSData   *data = [STR dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableArray *array = [NSMutableArray arrayWithArray:@[PORT1,data]];
    
    //2秒后向PORT2发送消息
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [PORT2 sendBeforeDate:[NSDate date]
                        msgid:101
                   components:array
                         from:PORT1
                     reserved:0];
    });
}

#pragma mark -NSPortDelegate
- (void)handlePortMessage:(NSMessagePort*)message
{
    //1. 消息id
    NSUInteger msgId = [[message valueForKeyPath:@"msgid"] integerValue];
    //2. 当前主线程的port
    NSPort *localPort = [message valueForKeyPath:@"localPort"];
    
    //3. 接收到消息的port（来自其他线程）
    NSPort *remotePort = [message valueForKeyPath:@"remotePort"];
    
    NSLog(@"\n执行端口代理回调：\n端口ID = %lu \nlocalPort:%@ \nremotePort:%@",(unsigned long)msgId, localPort, remotePort);
    
    if (101 == msgId){
        //向子线的port发送消息
        [remotePort sendBeforeDate:[NSDate date]
                             msgid:102
                        components:nil
                              from:localPort
                          reserved:0];
        
    } else if (102 == msgId){
        //....
    }
}


//这个NSMachPort收到消息的回调，注意这个参数，可以先给一个id。如果用文档里的NSPortMessage会发现无法取值
//- (void)handlePortMessage:(id)message
//{
//    NSLog(@"收到消息了，线程为：%@",[NSThread currentThread]);
//
//    //只能用KVC的方式取值
//    NSArray *array = [message valueForKeyPath:@"components"];
//
//    NSData *data =  array[1];
//    NSString *s1 = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"%@",s1);
//
//    //    NSMachPort *localPort = [message valueForKeyPath:@"localPort"];
//    //    NSMachPort *remotePort = [message valueForKeyPath:@"remotePort"];
//
//}


- (void)runloopCommunicate
{
    ///1. 创建主线程的port
    // 子线程通过此端口发送消息给主线程
    NSPort *myPort = [NSMachPort port];
    
    //2. 设置port的代理回调对象
    myPort.delegate = self;
    
    //3. 把port加入runloop，接收port消息
    [[NSRunLoop currentRunLoop] addPort:myPort forMode:NSDefaultRunLoopMode];
    
    NSLog(@"---myport %@", myPort);
    //4. 启动次线程,并传入主线程的port
    MyWorkerClass *work = [[MyWorkerClass alloc] init];
    [NSThread detachNewThreadSelector:@selector(launchThreadWithPort:)
                             toTarget:work
                           withObject:myPort];
}

- (void)testRunloop{
    CFRunLoopSourceContext context = {0};
    context.perform = DoNothingRunLoopCallback;
    
    CFRunLoopSourceRef source = CFRunLoopSourceCreate(NULL, 0, &context);
    CFRunLoopAddSource(CFRunLoopGetCurrent(), source, kCFRunLoopCommonModes);
    
    // Keep processing events until the runloop is stopped.
    //CFRunLoopRun();
    
    NSLog(@"stopped");
    CFRunLoopRemoveSource(CFRunLoopGetCurrent(), source, kCFRunLoopCommonModes);
    CFRelease(source);
}
@end
