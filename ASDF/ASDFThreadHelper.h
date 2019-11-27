//
//  ASDFThreadHelper.h
//  ASDF
//
//  Created by Macmafia on 2018/12/21.
//  Copyright © 2018 Macmafia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASDFThreadHelper : NSObject

/// 线程初始化
/// @param name 线程名
-(instancetype)initWithName:(NSString*)name;

/// 开启线程
- (void)start;

/// 停止当前线程
- (void)stop;

/// 获取线程
-(NSThread *)getThread;

@end

NS_ASSUME_NONNULL_END
