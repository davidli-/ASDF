//
//  ASDTabBarController.m
//  ASDF
//
//  Created by Macmafia on 2019/5/20.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import "ASDTabBarController.h"
#import "ASDTabBar.h"
#import "ViewController.h"
#import "ViewControllerII.h"
#import "ASDFCollectionViewController.h"

@interface ASDTabBarController ()<ASDTabBarDelegate,UITabBarControllerDelegate>

@end

@implementation ASDTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //加载方式1 手动写布局
    ASDTabBar *mBar = [[ASDTabBar alloc] init];
    
    /*加载方式2 nib自动布局
    ASDTabBar *mBar = [[[NSBundle mainBundle] loadNibNamed:@"ASDTabBar" owner:self options:nil] lastObject];
    [mBar initialTabBarItems];
     */
    
    mBar.asDelegate = self;
    [self setValue:mBar forKey:@"tabBar"];
    
    __weak ASDTabBarController *wSlf = self;
    wSlf.delegate = self;
}

//MARK:-ASDTabBarDelegate
/*点击超出TabBar高度的中间时会走这个代理，其他的会触发下面tabBar原有的代理，
 *因为点击到的实际上不是我们自定义的按钮，是系统默认的TabBarItem，详细情况可在运行后通过Xcode底部调试按钮查看视图层级*
 */
- (void)tabBar:(ASDTabBar *)tabBar didSelectItemAtIndex:(NSInteger)index{
    //NSLog(@"+++~ didselect tabbar:%ld",(long)index);
    if (index == 1) {
        self.selectedIndex = index;
    }
}

//MARK:-UITabBarDelegate
/*没超出TabBar高度的部分 还是会走这个代理，中间按钮超出TabBar高度的部分点击后会通过按钮action响应上面我们自定义的代理*/
- (void)tabBar:(ASDTabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    //NSLog(@"~~TabBar select:%ld",(long)item.tag);
    
    NSInteger index = item.tag;
    [tabBar updateTabBarItemAtIndex:index];
}

//MARK:-UITabBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController
shouldSelectViewController:(UIViewController *)viewController
{
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController
 didSelectViewController:(UIViewController *)viewController
{
    //NSLog(@"++++Controller select:%ld",tabBarController.selectedIndex);
}

@end
