//
//  NSObject+Associate.h
//  ASDF
//
//  Created by Macmafia on 2017/8/30.
//  Copyright © 2017年 Macmafia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Associate)

//属性 分类中允许声明属性，但不会自动生成getter、setter函数；
@property (nonatomic, strong) id mAssociateObj;

//移除关联
- (void)removeAssociate;

@end
