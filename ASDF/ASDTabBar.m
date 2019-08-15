//
//  ASDTabBar.m
//  ASDF
//
//  Created by Macmafia on 2019/5/20.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import "ASDTabBar.h"
#import "Masonry.h"

@interface ASDTabBar ()

@end

@implementation ASDTabBar

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialTabBarItems];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self makeCostraints];
    }
    return self;
}

- (void)dealloc{
    //NSLog(@"+++ASDTabBar dealloced~");
}

- (void)layoutSubviews{
    [super layoutSubviews];
}

- (void)makeCostraints{
    
    _btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self initialTabBarItems];
    
    [self addSubview:_btn1];
    [self addSubview:_btn2];
    [self addSubview:_btn3];
    
    [_btn1 setTag:0];
    [_btn2 setTag:1];
    [_btn3 setTag:2];
    
    [_btn1 addTarget:self action:@selector(onAction:) forControlEvents:UIControlEventTouchUpInside];
    [_btn2 addTarget:self action:@selector(onAction:) forControlEvents:UIControlEventTouchUpInside];
    [_btn3 addTarget:self action:@selector(onAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [_btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.leading.equalTo(self).offset(30);
    }];
    
    [_btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self.mas_top);
    }];
    
    [_btn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.trailing.equalTo(self).offset(-30);
    }];
}


- (IBAction)onAction:(UIButton*)sender {
    NSInteger index = sender.tag;
    [self updateTabBarItemAtIndex:index];
    if ([_asDelegate respondsToSelector:@selector(tabBar:didSelectItemAtIndex:)]) {
        [_asDelegate tabBar:self didSelectItemAtIndex:index];
    }
}


//MARK:- api

- (void)initialTabBarItems
{
    [_btn1 setImage:[UIImage imageNamed:@"btn_home_p"] forState:UIControlStateNormal];
    [_btn2 setImage:[UIImage imageNamed:@"1"] forState:UIControlStateNormal];
    [_btn3 setImage:[UIImage imageNamed:@"btn_user_n"] forState:UIControlStateNormal];
    
    self.barTintColor = [UIColor colorWithRed:1.0 green:96/255.0 blue:34/255.0 alpha:1];
}

- (void)updateTabBarItemAtIndex:(NSInteger)index
{
    switch (index) {
        case 0:
            [_btn1 setImage:[UIImage imageNamed:@"btn_home_p"] forState:UIControlStateNormal];
            [_btn3 setImage:[UIImage imageNamed:@"btn_user_n"] forState:UIControlStateNormal];
            break;
        case 1:
            [_btn1 setImage:[UIImage imageNamed:@"btn_home_n"] forState:UIControlStateNormal];
            [_btn3 setImage:[UIImage imageNamed:@"btn_user_n"] forState:UIControlStateNormal];
            break;
        case 2:
            [_btn1 setImage:[UIImage imageNamed:@"btn_home_n"] forState:UIControlStateNormal];
            [_btn3 setImage:[UIImage imageNamed:@"btn_user_p"] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    // 1.判断下窗口能否接收事件
    if (!self.userInteractionEnabled ||
        self.hidden == YES ||
        self.alpha <= 0.01){
        return nil;
    }
    
    // 2.从后往前遍历子视图数组
    for (UIView *subview in [self.subviews reverseObjectEnumerator]) {
        // 把自己视图上的点转换成子视图上的点
        CGPoint pointS = [self convertPoint:point toView:subview];
        /*1.系统会自动为我们自定义的Tabbar最上层创建对应的UITabBarButton，
         *2.所以如果触摸点是在原Tabbar的高度范围内，则会返回对应的UITabBarItem，并自动响应点击；
         *3.1.如果触摸点在中间的按钮上且超出了原tabbar的高度，我们不处理，则默认不会响应；
         *3.2.如果我们返回触摸点所在的中间按钮，则响应该按钮的action；
         */
        if ([subview hitTest:pointS withEvent:event]) {
            return subview;
        }
    }
    return nil;
}

@end
