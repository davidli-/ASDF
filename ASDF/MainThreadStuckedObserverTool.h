//
//  MainThreadStuckedObserverTool.h
//  ASDF
//
//  Created by Macmafia on 2018/12/18.
//  Copyright © 2018 Macmafia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MainThreadStuckedObserverTool : NSObject

+ (instancetype)shareTool;
- (void)addObserverToMainThread;
+ (void)monitorBussy;
@end

NS_ASSUME_NONNULL_END
