//
//  DynamicTool.m
//  ASDF
//
//  Created by Macmafia on 2017/8/23.
//  Copyright © 2017年 Macmafia. All rights reserved.
//

#import "DynamicTool.h"
#import <objc/runtime.h>
#import "ForwardTool.h"

void instanceMethod(id self,SEL sel)
{
    NSLog(@"instance method");
}

void classMethod(id self,SEL sel,NSString* str1,NSString* str2)
{
    NSLog(@"class method param1:%@,param2:%@",str1,str2);
}

@implementation DynamicTool

#pragma mark -动态决议
//实例方法
+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    if (sel == @selector(instanceMethodSelector)) {
        class_addMethod([self class], sel, (IMP)instanceMethod, "v@:");
    }
    return NO;
}
//类方法
+(BOOL)resolveClassMethod:(SEL)sel
{
    if (sel == @selector(classMethodSelector)) {
        class_addMethod(objc_getMetaClass("DynamicTool"), sel, (IMP)classMethod, "s#:@@");
    }
    return YES;
}

#pragma mark -消息转发
- (id)forwardingTargetForSelector:(SEL)sel
{
//    if (sel == @selector(unknownSelector)) {
//        return [ForwardTool new];
//    }
    return nil;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    NSMethodSignature *methodSignature = [super methodSignatureForSelector:aSelector];
    if (!methodSignature) {
        methodSignature = [NSMethodSignature signatureWithObjCTypes:"v@:*"];
    }
    return methodSignature;
}


- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    ForwardTool *forwardTool = [ForwardTool new];
    if ([forwardTool respondsToSelector:@selector(unknownSelector)]) {
        [anInvocation invokeWithTarget:forwardTool];
    }
}

@end
