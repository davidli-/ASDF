//
//  NSMutableArray+Extension.m
//  ASDF
//
//  Created by Macmafia on 2017/8/17.
//  Copyright © 2017年 Macmafia. All rights reserved.
//

#import "NSMutableArray+Extension.h"
#import <objc/runtime.h>


@implementation NSMutableArray (Extension)

+(void)load{
    [self swizzle_install];
}

+ (void)swizzle_install
{
    Method method1 = class_getInstanceMethod(objc_getClass("__NSArrayM"), @selector(addObject:));
    Method method2 = class_getInstanceMethod(objc_getClass("__NSArrayM"), @selector(swizzle_addObject:));
    
    method_exchangeImplementations(method1, method2);
}


-(void)swizzle_addObject:(id)anObject
{
    if (nil == anObject)
    {
        @try {
            [self swizzle_addObject:anObject];
        } @catch (NSException *exception) {
            NSLog(@"Crash reason:\n %@", [exception callStackSymbols]);
        } @finally {}
    }
    else{
        [self swizzle_addObject:anObject];
    }
}

@end
