//
//  ASDFSingleton.m
//  ASDF
//
//  Created by Macmafia on 2019/1/4.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import "ASDFSingleton.h"

@interface ASDFSingleton ()
@property (nonatomic, copy) NSString *str;
@end

static ASDFSingleton *mSingleton = nil;

@implementation ASDFSingleton

// 声明单例的方式1：
+ (instancetype)shareInstance
{
    return [[self alloc] init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mSingleton = [super allocWithZone:zone];
    });
    return mSingleton;
}

// 声明单例的方式2：使用同步锁
/*
+ (instancetype)shareInstance
{
    @synchronized (self) {
        mSingleton = [[ASDFSingleton alloc] init];
        mSingleton.str = @"This is a string";//在 block 内初始化属性
    }
    return mSingleton;
}
*/
@end
