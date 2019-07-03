//
//  ASDClickTableViewCell.m
//  ASDF
//
//  Created by Macmafia on 2019/6/27.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import "ASDClickTableViewCell.h"

@implementation ASDClickTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)onClicked:(id)sender {
    NSLog(@"+++clicked btn");
}

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
//    // 1.判断下窗口能否接收事件
//    if (!self.userInteractionEnabled ||
//        self.hidden == YES ||
//        self.alpha <= 0.01){
//        return nil;
//    }
//    // 2.触摸点不在自己上
//    if (![self pointInside:point withEvent:event]){
//        return nil;
//    }
//    // 3.从后往前遍历子视图数组
//    int count = (int)self.subviews.count;
//
//    for (int i = count - 1; i >= 0; i--) {
//        // 获取子视图
//        UIView *childView = self.subviews[i];
//        // 坐标系的转换,把窗口上的点转换为子视图上的点
//        // 把自己视图上的点转换成子视图上的点
//        CGPoint childP = [self convertPoint:point toView:childView];
//
//        //label的interaction enable默认被关闭，这里让label响应触摸事件
//        if ([childView isKindOfClass:NSClassFromString(@"UITableViewCellContentView")] &&
//            [childView pointInside:childP withEvent:event]) {
//            return childView;
//        }
//        UIView *fitView = [childView hitTest:childP withEvent:event];
//        if (fitView) {
//            return fitView;
//        }
//    }
//    // 4.触摸点在自己上，但没有找到更合适的子view，返回自己
//    return self;
//}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"++ClickTableViewCell touch began~");
    [super touchesBegan:touches withEvent:event];
}
@end
