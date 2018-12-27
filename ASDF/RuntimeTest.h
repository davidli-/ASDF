//
//  RuntimeTest.h
//  ASDF
//
//  Created by Macmafia on 2018/12/14.
//  Copyright © 2018 Macmafia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RuntimeTest : NSObject

- (void)instanceMethod1;
- (void)instanceMethod2;

+ (void)classMethod1;
+ (void)classMethod2;

@end

NS_ASSUME_NONNULL_END
