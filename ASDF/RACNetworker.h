//
//  RACNetworker.h
//  ASDF
//
//  Created by Macmafia on 2019/5/26.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RACSignal.h"

NS_ASSUME_NONNULL_BEGIN

@interface RACNetworker : NSObject

+ (instancetype)shareIns;
- (RACSignal*)fetchRequestWithPage:(int)page size:(int)size;

@end

NS_ASSUME_NONNULL_END
