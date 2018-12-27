//
//  ExceptionHandler.m
//  ASDF
//
//  Created by Macmafia on 2017/11/28.
//  Copyright © 2017年 Macmafia. All rights reserved.
//

#import "ExceptionHandler.h"
#import <UIKit/UIKit.h>
#include <libkern/OSAtomic.h>
#include <execinfo.h>
#include <sys/signal.h>

volatile int32_t UncaughtExceptionCount = 0;   //当前处理的异常个数
volatile int32_t UncaughtExceptionMaximum = 10;//最大能够处理的异常个数

const NSInteger ExceptionHandlerSkipAddressCount = 5;
const NSInteger ExceptionHandlerReportAddressCount = 10;

static   ExceptionHandler *mExceptionHandler =  nil;

#pragma mark -文件目录
NSString *exceptionFilePath()
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

#pragma mark -收到异常通知时的回调函数
void UncaughtExceptionHandler(NSException *exception)
{
    NSArray *arr = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    
    NSString *info = [NSString stringWithFormat:@"+异常崩溃报告+\nname:\n%@\nreason:\n%@\ncallStackSymbols:\n%@",name,reason,[arr componentsJoinedByString:@"\n"]];
    
    NSString *path = [exceptionFilePath() stringByAppendingPathComponent:@"Exception.txt"];
    
    [info writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
}


#pragma mark -捕获信号后的回调函数
void signalExceptionHandler(int signo)
{
    int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
    if (exceptionCount > UncaughtExceptionMaximum){
        return;
    }
    NSArray *callStack = [ExceptionHandler backtrace];
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:signo] forKey:@"signal"];
    [userInfo setValue:callStack forKey:@"callStack"];
    
    //创建一个OC异常对象
    NSException *ex = [NSException exceptionWithName:@"Name" reason:nil userInfo:userInfo];
    
    //处理异常消息
    [[ExceptionHandler shareInstance] performSelectorOnMainThread:@selector(onHandleSignalException:) withObject:ex waitUntilDone:YES];
}


@implementation ExceptionHandler

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (mExceptionHandler == nil) {
            mExceptionHandler  =  [[ExceptionHandler alloc] init];
        }
    });
    return mExceptionHandler;
}

#pragma mark -开始监听异常
+ (void)setDefaultHandler{
    NSSetUncaughtExceptionHandler (&UncaughtExceptionHandler);
}


#pragma mark -注册异常处理回调
+ (void)installExceptionHandler
{
    //注册程序由于abort()函数调用发生的程序中止信号
    signal(SIGABRT, signalExceptionHandler);
    
    //注册程序由于非法指令产生的程序中止信号
    signal(SIGILL, signalExceptionHandler);
    
    //注册程序由于无效内存的引用导致的程序中止信号
    signal(SIGSEGV, signalExceptionHandler);
    
    //注册程序由于浮点数异常导致的程序中止信号
    signal(SIGFPE, signalExceptionHandler);
    
    //注册程序由于内存地址未对齐导致的程序中止信号
    signal(SIGBUS, signalExceptionHandler);
    
    //程序通过端口发送消息失败导致的程序中止信号
    signal(SIGPIPE, signalExceptionHandler);
}

#pragma mark -处理异常用到的方法
- (void)onHandleSignalException:(NSException *)exception
{
    NSLog(@"++++出现崩溃:\n%@",exception.userInfo);
    
    NSSetUncaughtExceptionHandler(NULL);
    
    signal(SIGABRT, SIG_DFL);
    signal(SIGILL, SIG_DFL);
    signal(SIGSEGV, SIG_DFL);
    signal(SIGFPE, SIG_DFL);
    signal(SIGBUS, SIG_DFL);
    signal(SIGPIPE, SIG_DFL);
}

#pragma mark -获取调用堆栈
+ (NSArray *)backtrace
{
    void* callstack[128];
    
    //该函数用于获取当前线程的调用堆栈
    int frames = backtrace(callstack, 128);
    
    //将从backtrace函数获取的信息转化为一个字符串数组
    char **strs = backtrace_symbols(callstack, frames);
    
    int i;
    
    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
    
    for (i = ExceptionHandlerSkipAddressCount; i < ExceptionHandlerSkipAddressCount + ExceptionHandlerReportAddressCount; i++){
        [backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
    }
    
    free(strs);
    return backtrace;
}
@end
