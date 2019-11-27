//
//  ASDFSingleton.h
//  ASDF
//
//  Created by Macmafia on 2019/1/4.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*打印日志 看三种方式初始化的单例对象是否是同一个
 ASDFSingleton *s1 = [ASDFSingleton shareInstance];
 ASDFSingleton *s2 = [[ASDFSingleton alloc] init];
 ASDFSingleton *s3 = [ASDFSingleton new];
 NSLog(@"++s1:%@\n++s2:%@\n++s3:%@",s1,s2,s3);
 */

@interface ASDFSingleton : NSObject
+ (instancetype)shareInstance;
- (void)instanceMethod;
@end

NS_ASSUME_NONNULL_END
