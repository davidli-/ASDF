//
//  YYHaveOtherEntityModel.m
//  ASDF
//
//  Created by Macmafia on 2019/10/25.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import "YYHaveOtherEntityModel.h"
#import <NSObject+YYModel.h>

@implementation YYHaveOtherEntityModel

// 声明自定义类参数类型
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"account" : [YYAccount class],
        @"accountsArr" : [YYAccount class], //指定集合中元素的类型
        @"accountsDic": [YYAccount class]
    };
}
@end
