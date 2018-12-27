//
//  NSObject+JsonToModel.m
//  ASDF
//
//  Created by Macmafia on 2017/8/26.
//  Copyright © 2017年 Macmafia. All rights reserved.
//

#import "NSObject+JsonToModel.h"
#import <objc/runtime.h>


@implementation NSObject (JsonToModel)

- (instancetype)initModelWithDictionary:(NSDictionary *)jsonDic
{
    if (self = [self init])
    {
        NSMutableArray * keysArr;
        if (!jsonDic) {
            return nil;
        }
        
        keysArr = [NSMutableArray array];
        
        //获取类的属性及属性对应的类型
        unsigned int count;
        objc_property_t * properties = class_copyPropertyList([self class], &count);
        for (int i = 0; i < count; i++)
        {
            objc_property_t property = properties[i];
            //获取属性名
            const char *charName = property_getName(property);
            NSString *propertyName = [NSString stringWithCString:charName encoding:NSUTF8StringEncoding];
            
            if (propertyName.length) {
                [keysArr addObject:propertyName];
            }
        }
        free(properties);
        
        //给属性赋值
        for (NSString * key in keysArr) {
            [self setValue:jsonDic[key] forKey:key];
        }
    }
    return self;    
}

@end
