//
//  AnimateClickedView.m
//  ASDF
//
//  Created by Macmafia on 2018/12/14.
//  Copyright © 2018 Macmafia. All rights reserved.
//

#import "AnimateClickedView.h"

@implementation AnimateClickedView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    CGPoint convertedPoint = [self.layer convertPoint:point toLayer:self.layer.presentationLayer];
    
    if ([self.layer.presentationLayer containsPoint:convertedPoint]) {
        NSLog(@"++++++恭喜您中奖了！");
        return self;
    }else{
        NSLog(@"没点中红包，继续加油哦~");
        return nil;
    }
}
@end
