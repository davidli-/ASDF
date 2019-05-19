//
//  ViewController.h
//  ASDF
//
//  Created by Macmafia on 2017/7/25.
//  Copyright © 2017年 Macmafia. All rights reserved.
//

#import <UIKit/UIKit.h>

struct ADate {
    int year;
    int month;
    int day;
};

@interface ViewController : UIViewController
{
    @public
    NSString *aStr;
    double aDouble;
    struct ADate date; //结构体变量分配在栈.OC对象分配在堆
}
@end

