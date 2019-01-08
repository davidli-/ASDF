//
//  CustomLayer.m
//  ASDF
//
//  Created by Macmafia on 2018/11/8.
//  Copyright © 2018 Macmafia. All rights reserved.
//

#import "CustomLayer.h"
#import <UIKit/UIKit.h>

@implementation CustomLayer

- (void)drawInContext:(CGContextRef)ctx
{
    //画圆
    CGContextAddEllipseInRect(ctx, CGRectMake(0, 0, 50, 50));
    CGContextSetRGBFillColor(ctx, 1, 0, 1, 1);
    CGContextDrawPath(ctx, kCGPathFillStroke);
    
    //画三角形
    CGContextSetLineWidth(ctx, 2);
    CGContextSetFillColorWithColor(ctx, [UIColor blueColor].CGColor);
    CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
    
    UIBezierPath *aPath = [UIBezierPath bezierPath];
    aPath.lineWidth = 2.0; //设置线宽
    aPath.lineCapStyle = kCGLineCapRound; //线条拐角
    aPath.lineJoinStyle = kCGLineCapRound; //终点处理
    [aPath moveToPoint:CGPointMake(100, 50)];
    [aPath addLineToPoint:CGPointMake(140, 80)];
    [aPath addLineToPoint:CGPointMake(60, 80)];
    [aPath closePath];
    CGContextAddPath(ctx, aPath.CGPath);
    CGContextDrawPath(ctx, kCGPathFillStroke);
}
@end
