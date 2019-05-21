//
//  ASDTabBar.h
//  ASDF
//
//  Created by Macmafia on 2019/5/20.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ASDTabBar;

@protocol ASDTabBarDelegate <NSObject>

- (void)tabBar:(ASDTabBar *)tabBar didSelectItemAtIndex:(NSInteger)index;

@end

@interface ASDTabBar : UITabBar

@property (strong, nonatomic) IBOutlet UIButton *btn1;
@property (strong, nonatomic) IBOutlet UIButton *btn2;
@property (strong, nonatomic) IBOutlet UIButton *btn3;

@property (nonatomic, weak) id <ASDTabBarDelegate> asDelegate;

- (void)initialTabBarItems;
- (void)updateTabBarItemAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
