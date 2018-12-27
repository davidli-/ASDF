//
//  RuntimeTest.m
//  ASDF
//
//  Created by Macmafia on 2018/12/14.
//  Copyright © 2018 Macmafia. All rights reserved.
//

#import "RuntimeTest.h"
#import <objc/runtime.h>

void dynamicAdd(id self,SEL selector)
{
    NSLog(@"动态决议");
}

@implementation RuntimeTest

#pragma mark -Private

- (void)instanceMethod1
{
    NSLog(@"+++++++111111");
}


- (void)instanceMethod2
{
    NSLog(@"+++++++22222222");
}



+ (void)classMethod1
{
    NSLog(@"+++++++333333");
}


+ (void)classMethod2
{
    NSLog(@"+++++++44444444");
}


#pragma mark -动态决议
+(BOOL)resolveClassMethod:(SEL)sel
{
    if (sel == @selector(xxx)) {
        class_addMethod([self class], sel, (IMP)dynamicAdd, "v@:");
    }
    return NO;
}

+(BOOL)resolveInstanceMethod:(SEL)sel
{
    if (sel == @selector(xxx)) {
        class_addMethod([self class], sel, (IMP)dynamicAdd, "v@:");
    }
    return NO;
}

@end
