//
//  YYCustomedKeyModel.m
//  ASDF
//
//  Created by Macmafia on 2019/10/25.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import "YYCustomedKeyModel.h"
#import <NSObject+YYModel.h>

@implementation YYCustomedKeyModel

+ (NSDictionary*)modelCustomPropertyMapper{
    //  返回一个字典，包含了字段间的映射关系
    return @{
        @"ID":@"modelID", //key是当前属性名，value为jsonDIc中的key
        @"sex":@"gender",
        @"number":@"subDic.number"
    };
}

@end
