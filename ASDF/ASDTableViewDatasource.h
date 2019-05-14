//
//  ASDTableViewDatasource.h
//  ASDF
//
//  Created by Macmafia on 2019/5/13.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASDTableViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASDTableViewDatasource : NSObject

- (NSUInteger)countOfDatasource;
- (ASDTableViewModel*)modelAtIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
