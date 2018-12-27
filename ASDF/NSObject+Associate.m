//
//  NSObject+Associate.m
//  ASDF
//
//  Created by Macmafia on 2017/8/30.
//  Copyright © 2017年 Macmafia. All rights reserved.
//

#import "NSObject+Associate.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>

static void *mAssociateObjKey = &mAssociateObjKey;

@implementation NSObject (Associate)


- (void)setMAssociateObj:(id)obj
{
    //创建关联
    objc_setAssociatedObject(self, mAssociateObjKey, obj, OBJC_ASSOCIATION_RETAIN);
}

- (id)mAssociateObj
{
    //获取关联的对象
    return objc_getAssociatedObject(self, mAssociateObjKey);
}

- (void)removeAssociate
{
    objc_setAssociatedObject(self, mAssociateObjKey, nil, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
