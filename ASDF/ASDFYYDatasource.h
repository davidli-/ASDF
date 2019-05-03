//
//  ASDFYYDatasource.h
//  ASDF
//
//  Created by Macmafia on 2019/5/3.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASDFChatMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASDFYYDatasource : NSObject

- (instancetype)initWithWidth:(CGFloat)width;
- (NSInteger)numberOfRows;
- (ASDFChatMessage*)chatMessAtIndexPath:(NSIndexPath*)indexPath;
- (CGFloat)heightForRowAtIndexPath:(NSIndexPath*)indexPath;

@end

NS_ASSUME_NONNULL_END
