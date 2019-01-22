//
//  People.m
//  ASDF
//
//  Created by Macmafia on 2019/1/14.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import "People.h"

@interface People()
{
    //声明成员变量
    NSString *_name;//以下划线开头的成员变量
    NSString *nick;
}
//声明属性
@property (nonatomic,copy) NSString *name;
@property (nonatomic, copy) NSString *aliasName;
@end

@implementation People
//合成属性 绑定成员变量到指定的属性上 并在 getter、setter中使用此成员变量赋值
@synthesize name = _name;
@synthesize aliasName = nick;

- (NSString *)name{
    return _name;
}

- (void)setName:(NSString *)aName{
    if (aName && _name && ![aName isEqualToString:_name]) {
        return;
    }
    _name = aName;
}

- (void)test{
    self.name = @"A";
    self.aliasName = @"B";
    NSLog(@"++self.name='%@',++self.aliasName='%@',++_name='%@',++nick='%@'",self.name,self.aliasName,_name,nick);
}
@end
