//
//  CustomView.m
//  ASDF
//
//  Created by Macmafia on 2018/11/8.
//  Copyright © 2018 Macmafia. All rights reserved.
//

#import "CustomView.h"

@implementation CustomView

- (void)drawRect:(CGRect)rect {
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef ref = UIGraphicsGetCurrentContext();
    NSLog(@"++++Context:%p",ref);

    //边宽
    CGFloat lineWidth = 3.0f;
    //半径
    CGFloat radius = (CGRectGetWidth(rect) - lineWidth * 2) / 2.0;
    //圆心
    CGPoint center = CGPointMake(CGRectGetWidth(rect)/2.0, CGRectGetHeight(rect) / 2.0);
    //扇形起点
    CGFloat startAngle = - M_PI_2;
    //根据进度计算扇形结束位置
    CGFloat endAngle = startAngle + 0.99 * M_PI * 2;
    //根据起始点、原点、半径绘制弧线
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];

    CGContextSetLineWidth(ref, lineWidth);
    CGContextSetFillColorWithColor(ref, [UIColor yellowColor].CGColor);
    CGContextSetStrokeColorWithColor(ref, [UIColor blueColor].CGColor);

    //从弧线结束为止绘制一条线段到圆心。这样系统会自动闭合图形，绘制一条从圆心到弧线起点的线段。
    [path addLineToPoint:center];
    CGContextAddPath(ref, path.CGPath);
    CGContextDrawPath(ref, kCGPathFillStroke);

    //得到一张新图片
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

@end
