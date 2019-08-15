//
//  ASDLock.m
//  ASDF
//
//  Created by Macmafia on 2019/7/14.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import "ASDLockTool.h"

@interface ASDLockTool ()
// 读写锁示范
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) dispatch_queue_t mQueue;
@end

@implementation ASDLockTool

@synthesize name = _name;

- (instancetype)init {
    if (self = [super init]) {
        _mQueue = dispatch_queue_create("mQueue", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

// getter 需要同步，因为要立刻返回属性的值
- (NSString *)name{
    __block NSString *bName;
    dispatch_sync(_mQueue, ^{
        bName = _name;
    });
    return bName;
}

// setter 需要排他性，写时不允许其他写操作或者读操作，所以使用栅栏
- (void)setName:(NSString *)name{
    dispatch_barrier_async(_mQueue, ^{
        _name = name;
    });
}

@end
