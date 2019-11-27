//
//  ASDFAnimationDemo.m
//  ASDF
//
//  Created by Macmafia on 2019/10/24.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import "ASDFAnimationDemo.h"
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@implementation ASDFAnimationDemo

- (void)BasicAnimationWithKeyPath:(NSString *)keypath
                                      fromValue:(id)fromValue
                                        byValue:(id)byValue
                                        toValue:(id)toValue
                                       duration:(NSTimeInterval)duration
                                       fillMode:(NSString *)fillMode
                             removeOnCompletion:(BOOL)removeOnCompletion
                                         onView:(UIView*)view
                                         forKey:(NSString*)key {
    CABasicAnimation *basicAnima = [CABasicAnimation animationWithKeyPath:keypath];
    basicAnima.fromValue = fromValue;
    basicAnima.toValue = toValue;
    basicAnima.byValue = byValue;
    basicAnima.duration = duration;
    basicAnima.fillMode = fillMode;
    basicAnima.removedOnCompletion = removeOnCompletion;

    [view.layer addAnimation:basicAnima forKey:key];
}

- (void)KeyframeAnimationWithKeyPath:(NSString *)keypath
                                             onView:(UIView*)view
                                             forKey:(NSString*)key {
    CGMutablePathRef path = CGPathCreateMutable();
    //第一个关键帧  -100，-100
    CGPathMoveToPoint(path, NULL, -100, -100);
    //第二个关键帧  100，-100
    CGPathAddLineToPoint(path, NULL, 100, -100);
    //第三个关键帧  100，100
    CGPathAddLineToPoint(path, NULL, 100, 100);
    //第四个关键帧  -100，100
    CGPathAddLineToPoint(path, NULL, -100, 100);
    //第五个关键帧  -100，-100
    CGPathAddLineToPoint(path, NULL, -100, -100);
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"transform.translation";
    animation.path = path;
    animation.duration = 4;
    animation.keyTimes = @[@(0),@(0.1),@(0.5),@(0.75),@(1)];
    animation.timingFunctions = @[[CAMediaTimingFunction functionWithControlPoints:1 :0.5 :0.5 :0.5],
                                  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
                                  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    //动画结束后保持动画最后的状态，两个属性需配合使用
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    
    CGPathRelease(path);
    [view.layer addAnimation:animation forKey:key];
}

- (void)setValuesAnimationOnView:(UIView*)view
                          forKey:(NSString*)key {
    CGPoint center = view.center;
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position";
    animation.duration = 4;
    animation.repeatCount = CGFLOAT_MAX;
    
    animation.calculationMode = kCAAnimationLinear;
    animation.values = @[[NSValue valueWithCGPoint:CGPointMake(center.x-100, center.y-100)],
                         [NSValue valueWithCGPoint:CGPointMake(center.x+100, center.y-100)],
                         [NSValue valueWithCGPoint:CGPointMake(center.x+100, center.y+100)],
                         [NSValue valueWithCGPoint:CGPointMake(center.x-100, center.y+100)],
                         [NSValue valueWithCGPoint:CGPointMake(center.x-100, center.y-100)]];
    animation.keyTimes = @[@(0),@(0.25),@(0.5),@(0.75),@(1)];
    animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],
                                  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
                                  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    
    [view.layer addAnimation:animation forKey:key];
    
}
@end
