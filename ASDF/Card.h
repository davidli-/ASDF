//
//  Card.h
//  ASDF
//
//  Created by Macmafia on 2018/12/23.
//  Copyright © 2018 Macmafia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Card : NSObject
@property (nonatomic) int cardNumber; // 编号
@property (nonatomic) float money;    // 余额
@end

NS_ASSUME_NONNULL_END
