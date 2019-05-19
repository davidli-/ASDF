//
//  BankBlock.m
//  ASDF
//
//  Created by Macmafia on 2019/5/19.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import "Bank.h"

@interface Bank ()
{
    float mBalance; //账户余额
}
@end

@implementation Bank

- (Bank * _Nonnull (^)(float))store{
    return ^(float money){
        mBalance += money; //修改成员变量
        return self; //最后返回当前实例对象
    };
}

- (Bank * _Nonnull (^)(float))take{
    return ^(float money){
        mBalance -= money;
        mBalance = MAX(mBalance, 0);
        return self;
    };
}

- (float)check{
    return mBalance;
}

@end
