//
//  RuntimeTool.m
//  ASDF
//
//  Created by Macmafia on 2017/8/17.
//  Copyright © 2017年 Macmafia. All rights reserved.
//

#import "RuntimeTool.h"
#import <objc/runtime.h> //包含对类、成员变量、属性、方法的操作
#import <objc/message.h> //包含消息机制

@implementation RuntimeTool


/**
 获取类中所有成员变量的名称与类型
 
 @param aClass 目标类名
 @return 返回一个数组，{键：变量名，值：类型}
 */
+ (NSArray *)ivarListWithClass:(Class)aClass
{
    if (!object_isClass(aClass))
    {
        return nil;
    }
    
    unsigned int count = 0;
    NSMutableArray *resultArr = [NSMutableArray array];
    
    Ivar *ivars = class_copyIvarList([aClass class], &count);
    
    for (int i = 0; i<count; i++)
    {
        Ivar ivar = ivars[i];
        const char *charName = ivar_getName(ivar);
        const char *charType = ivar_getTypeEncoding(ivar);
        
        NSString *name = [NSString stringWithCString:charName encoding:NSUTF8StringEncoding];
        NSString *type = [NSString stringWithCString:charType encoding:NSUTF8StringEncoding];
        
        NSDictionary *dic = @{@"ivar_name":name,@"objc_type":type};
        
        [resultArr addObject:dic];
    }
    
    free(ivars);
    
    return resultArr;
}





/**
 获取类中所有属性的名称与类型
 
 @param aClass 目标类名
 @return 返回一个数组，{键：属性名，值：类型}
 */
+ (NSArray *)propertyListWithClass:(Class)aClass
{
    if (!object_isClass(aClass))
    {
        return nil;
    }
    
    
    unsigned int count = 0;
    NSMutableArray *resultArr = [NSMutableArray array];
    
    objc_property_t *properties = class_copyPropertyList([aClass class], &count);
    
    for (int i = 0; i<count; i++)
    {
        objc_property_t aProperty = properties[i];
        const char *charName = property_getName(aProperty);
        const char *charType = property_getAttributes(aProperty);
        
        NSString *name = [NSString stringWithCString:charName encoding:NSUTF8StringEncoding];
        NSString *type = [NSString stringWithCString:charType encoding:NSUTF8StringEncoding];
        
        NSDictionary *dic = @{@"property_name":name,@"objc_type":type};
        
        [resultArr addObject:dic];
    }
    
    free(properties);
    
    return resultArr;
}




/**
 获取类中所有方法名
 
 @param aClass 目标类
 @return 返回所有方法名组成的一个数组
 */
+ (NSArray *)methodListWithClass:(Class)aClass
{
    if (!object_isClass(aClass))
    {
        return nil;
    }
    NSMutableArray *methodArr = [NSMutableArray array];
    
    unsigned int count = 0;
    Method *methods = class_copyMethodList(aClass, &count);
    
    for (int i = 0; i < count; i++) {
        SEL sel_name = method_getName(methods[i]);
        NSString *name = [NSString stringWithCString:sel_getName(sel_name) encoding:NSUTF8StringEncoding];
        [methodArr addObject:name];
    }
    free(methods);
    
    return methodArr;
}

@end
