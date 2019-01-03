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

//声明单例的方式1：
+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //if (!mSingleton) {//不用这个判断也可以 因为dispatch_once只会执行一次
            mSingleton = [[ASDFSingleton alloc] init];
            mSingleton.str = @"This is a string";//在 block 内初始化属性
        //}
    });
    return mSingleton;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mSingleton = [super allocWithZone:zone];
    });
    return mSingleton;
}
@end
