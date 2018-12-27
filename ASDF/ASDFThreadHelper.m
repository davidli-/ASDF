//
//  ASDFThreadHelper.m
//  ASDF
//
//  Created by Macmafia on 2018/12/21.
//  Copyright © 2018 Macmafia. All rights reserved.
//

#import "ASDFThreadHelper.h"

@interface ASDFThreadHelper()
@property (nonatomic, strong) NSThread *thread;
@end

@implementation ASDFThreadHelper

-(instancetype)initWithName:(NSString*)name{
    if (self = [super init]) {
        _thread = [[NSThread alloc] initWithTarget:self selector:@selector(onThreadInit:) object:nil];
        _thread.name = name;
        [_thread start];
    }
    return self;
}

-(NSThread *)getThread{
    return _thread;
}

- (void)onThreadInit:(id)obj{
//    CFRunLoopRun();
}

- (void)start{
    [_thread start];
}

- (void)finish{
    CFRunLoopStop(CFRunLoopGetCurrent());
}
@end
