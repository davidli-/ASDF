//
//  ExceptionHandler.h
//  ASDF
//
//  Created by Macmafia on 2017/11/28.
//  Copyright © 2017年 Macmafia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExceptionHandler : NSObject

+ (instancetype)shareInstance;
+ (void)setDefaultHandler;
+ (NSArray *)backtrace;
+ (void)installExceptionHandler;

@end
