//
//  UIViewInspectable.m
//  ASDF
//
//  Created by Macmafia on 2018/8/27.
//  Copyright © 2018年 Macmafia. All rights reserved.
//

#import "UIViewInspectable.h"

@implementation UIViewInspectable

- (void)setBorderWidth:(CGFloat)borderWidth{
    _borderWidth = borderWidth;
    self.layer.borderWidth = borderWidth;
}

-(void)setBorderColor:(UIColor *)borderColor{
    _borderColor = borderColor;
    self.layer.borderColor = borderColor.CGColor;
}

@end
