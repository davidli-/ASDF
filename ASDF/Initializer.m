//
//  Initializer.m
//  ASDF
//
//  Created by Macmafia on 2017/12/23.
//  Copyright © 2017年 Macmafia. All rights reserved.
//

#import "Initializer.h"

int aGlobalInt = 0;
NSString *className = @"defaultName";
NSMutableDictionary *paramDic = nil;

@implementation Initializer

//+ (void)load{
//    NSLog(@"++++ super loaded~");
//    //paramDic = [NSMutableDictionary dictionaryWithDictionary:@{@"k":@"value"}];
//}

+(void)initialize
{
    NSLog(@"+++ super Initialized~");
//    paramDic = [NSMutableDictionary dictionary];
    
//    if (self == [Initializer self]) {
//        aGlobalInt = 1;
//        className = @"Initializer";
//    }else{
//        aGlobalInt = 2;
//        className = NSStringFromClass([self class]);
//    }
//    paramDic[@"name"] = className;
}

- (instancetype) init
{
    return [self initWithTitle:@"defaultTitle"];
}

- (instancetype) initWithTitle:(NSString *)title
{
    return [self initWithTitle:title date:[NSDate date]];
}

- (instancetype) initWithTitle:(NSString *)title date:(NSDate*)date
{
    if (self = [super init]) {
        aTitle = title;
        aDate  = date;
    }
    return self;
}

@end
