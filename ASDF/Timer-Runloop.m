//
//  Timer-Runloop.m
//  ASDF
//
//  Created by Macmafia on 2017/9/12.
//  Copyright © 2017年 Macmafia. All rights reserved.
//

#import "Timer-Runloop.h"

void onScheduleTimer()
{
    NSLog(@"++++1秒重复定时执行++++");
}


@implementation Timer_Runloop

- (void)scheduleTimer
{
    /*
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFRunLoopTimerContext context = {0, NULL, NULL, NULL, NULL};
    CFRunLoopTimerRef timer = CFRunLoopTimerCreate(kCFAllocatorDefault, 1, 1, 0, 0,
                                                   &onScheduleTimer, &context);
    CFRunLoopAddTimer(runLoop, timer, kCFRunLoopCommonModes);
     */

    //创建timer 间隔1秒
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onScheduleTimer) userInfo:nil repeats:YES];
    
    //在第3秒的时 模拟一个复杂运算
    [self performSelector:@selector(onMassTasks) withObject:nil afterDelay:3];
}



- (void)onScheduleTimer
{
    NSLog(@"++++1秒重复定时执行++++");
}


- (void)onMassTasks
{
    for (int i = 0; i< 0xffffffff; i++){
    }
    NSLog(@"++++复杂运算完成++++");
}

@end
