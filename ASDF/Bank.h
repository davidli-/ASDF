//
//  BankBlock.h
//  ASDF
//
//  Created by Macmafia on 2019/5/19.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*
 *链式语法实例
 *
 *调用示例：
 *Bank *bank = [Bank new];
 *float balance = bank.store(10).take(1).check;
 *NSLog(@"+++%f",balance);
 */
@interface Bank : NSObject

//存钱
- (Bank*(^)(float))store;
//取钱
- (Bank*(^)(float))take;
//查账
- (float)check;

@end

NS_ASSUME_NONNULL_END
