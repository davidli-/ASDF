//
//  YYModelTestCase.m
//  ASDF
//
//  Created by Macmafia on 2019/10/25.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import "YYModelTestCase.h"
#import "YYSubModel.h"
#import "YYCustomedKeyModel.h"
#import "YYHaveOtherEntityModel.h"
#import <NSObject+YYModel.h>
#import "YYPerson.h"

@implementation YYModelTestCase

+ (void)test{
    [self testCommonConverter];
    [self testCustomedKeyConverter];
    [self testHaveSubClassConverter];
    [self testDeepCopy];
    [self testGeneric];
}

// MAKK: 普通属性 对象字典互相转换
+ (void)testCommonConverter {
    NSDictionary *dic = @{
                          @"name":@"张三",
                          @"nick":@"三儿",
                          @"age":@(12),
                        };
    // 将数据转模型
    YYSubModel *model = [YYSubModel modelWithDictionary:dic];
    // 将模型转数据
    NSDictionary *dics = [model modelToJSONObject];
    NSLog(@"++++++++");
}


// MARK: 自定义属性映射数据交换
+ (void)testCustomedKeyConverter{
    NSDictionary *dic = @{
                          @"name":@"张三",
                          @"age":@(12),
                          @"gender":@"男", // 与sex字段对应
                          @"modelID":@(100),    // 与modelID字段对应
                          @"subDic":@{@"number":@(2)}, // 对应number属性
                        };
    // 将数据转模型
    YYCustomedKeyModel *model = [YYCustomedKeyModel modelWithDictionary:dic];
    // 将模型转数据
    NSDictionary *dics = [model modelToJSONObject];
    NSLog(@"++++++++");
}


// MARK: 类中包含其他子类作为属性

+ (void)testHaveSubClassConverter {
    NSDictionary *dic = @{
        @"name" : @"张三",
        @"age" : @(12),
        @"account" : @{ @"userName":@"David",@"money":@(100000) },
        @"accountsArr" : @[@{ @"userName":@"David",@"money":@(100000) }, @{ @"userName":@"Hekon",@"money":@(800000) }],
        @"accountsDic" : @{@"User":@{ @"userName":@"David",@"money":@(100000) }}
    };
    // 将数据转模型
    YYHaveOtherEntityModel *model = [YYHaveOtherEntityModel modelWithDictionary:dic];
    // 将模型转数据
    NSDictionary *dics = [model modelToJSONObject];
    NSLog(@"++++++++");
}

+ (void)testDeepCopy {
    NSDictionary *dic = @{
                          @"name":@"张三",
                          @"nick":@"三儿",
                          @"age":@(12),
                        };
    // 将数据转模型
    YYSubModel *model = [YYSubModel modelWithDictionary:dic];
    YYSubModel *model2 = [model modelCopy];
    YYSubModel *model3 = [model copy];
    NSLog(@"++++++++");
}

// 泛型，多态，根据条件将字典转换成对应的类型
+ (void)testGeneric {
    NSDictionary *dic = @{
                          @"name":@"张三",
                          @"sex":@(1)
                        };
    NSDictionary *dic2 = @{
        @"name":@"莉莉丝",
        @"age":@(0)
    };
    // 将数据转模型
    YYPerson *model1 = [YYPerson modelWithDictionary:dic];
    YYPerson *model2 = [YYPerson modelWithDictionary:dic2];
    NSLog(@"+++model1:%@, model2:%@",[model1 description],[model2 description]);
}

@end
