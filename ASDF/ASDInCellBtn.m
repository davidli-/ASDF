//
//  ASDInCellBtn.m
//  ASDF
//
//  Created by Macmafia on 2019/6/27.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import "ASDInCellBtn.h"

@implementation ASDInCellBtn

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{

    // 1.判断下窗口能否接收事件
    if (!self.userInteractionEnabled ||
        self.hidden == YES ||
        self.alpha <= 0.01){
        return nil;
    }
    // 2.触摸点不在自己上
    if (![self pointInside:point withEvent:event]){
        return nil;
    }
    // 3.触摸点在自己上，返回superView，即TableViewCellContentView
    return self.superview;
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    NSLog(@"++ASDInCellBtn touch began~");
//    [super touchesBegan:touches withEvent:event];
//}

@end
