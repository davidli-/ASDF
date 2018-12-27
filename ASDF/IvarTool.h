//
//  IvarTool.h
//  ASDF
//
//  Created by Macmafia on 2017/8/26.
//  Copyright © 2017年 Macmafia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IvarTool : NSObject
{
    double ivar_defaultDouble;
@package
    int ivar_packInt;
@public
    float  ivar_publicFloat;
@protected
    NSString *ivar_protectedStr;
@private
    NSDictionary *ivar_privateDic;
}
@property(nonatomic,copy)  NSString *property_string;
//成员变量列表
+ (void)ivarList;
//属性列表
+ (void)propertyList;

@end
