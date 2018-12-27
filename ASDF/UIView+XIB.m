//
//  UIView+XIB.m
//  ASDF
//
//  Created by Macmafia on 2018/8/27.
//  Copyright © 2018年 Macmafia. All rights reserved.
//

#import "UIView+XIB.h"
#import <objc/runtime.h>

static const char mRadius;

@implementation UIView (XIB)

-(CGFloat)cornerRadius{
    return [objc_getAssociatedObject(self, &mRadius) floatValue];
}

-(void)setCornerRadius:(CGFloat)cornerRadius{
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
    objc_setAssociatedObject(self, &mRadius, @(cornerRadius), OBJC_ASSOCIATION_ASSIGN);
}
@end
