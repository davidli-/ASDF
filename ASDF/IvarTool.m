//
//  IvarTool.m
//  ASDF
//
//  Created by Macmafia on 2017/8/26.
//  Copyright © 2017年 Macmafia. All rights reserved.
//

#import "IvarTool.h"
#import <objc/runtime.h>

@interface IvarTool()
{
    int ivar_int;
@public
    NSArray *ivar_array;
}
@property(nonatomic, strong) NSDictionary *property_dic;
@end

@implementation IvarTool

+ (void)ivarList
{
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([IvarTool class], &count);
    
    for (int i = 0; i<count; i++)
    {
        Ivar ivar = ivars[i];
        const char *charName = ivar_getName(ivar);
        const char *charType = ivar_getTypeEncoding(ivar);
        
        NSLog(@"Name:%s,Type:%s",charName,charType);
    }
    
    free(ivars);
}


+ (void)propertyList
{
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([IvarTool class], &count);
    
    for (int i = 0; i<count; i++)
    {
        objc_property_t aProperty = properties[i];
        const char *charName = property_getName(aProperty);
        const char *charType = property_getAttributes(aProperty);
        NSLog(@"Name:%s,Type:%s",charName,charType);
    }
    
    free(properties);
}

@end
