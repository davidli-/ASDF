//
//  ASDNotificationModel.h
//  ASDF
//
//  Created by Macmafia on 2019/1/6.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASDNotification.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^ASDNotifyBlock)(ASDNotification *);

@interface ASDNotificationModel : NSObject

@property (nonatomic, strong) id observer;  //观察者对象
@property (nonatomic, assign) SEL selector; //执行的方法
@property (nonatomic, copy) NSString *name; //通知名字
@property (nonatomic, strong) id object;    //参数
@property (nonatomic, strong) NSOperationQueue *queue;//队列
@property (nonatomic, copy) ASDNotifyBlock block;  //回调

@end

NS_ASSUME_NONNULL_END
