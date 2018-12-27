//
//  NSMutableArray+Extension.h
//  ASDF
//
//  Created by Macmafia on 2017/8/17.
//  Copyright © 2017年 Macmafia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Extension)


/**
 启动可变数组检测 事先加载
 */
+ (void)swizzle_install;


@end
